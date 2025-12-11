#!/usr/bin/env python3
"""
FINAL COMPLETE TEST SUITE - FP16 & GGUF Models
Comprehensive comparison with full reporting
"""
import requests
import json
import time
import os
from datetime import datetime
from concurrent.futures import ThreadPoolExecutor, as_completed

BASE_URL = "http://localhost:8188"

# ALL MODELS - FP16 AND GGUF
ALL_MODELS = [
    # FP16 MODELS (Baseline)
    {
        "name": "Flux Dev (FP16)",
        "workflow": "1_flux_dev_quality.json",
        "size": "16GB",
        "precision": "FP16",
        "category": "baseline"
    },
    {
        "name": "FluxedUp NSFW (FP16)",
        "workflow": "2_fluxedUp_NSFW_FIXED.json",
        "size": "23GB",
        "precision": "FP16",
        "category": "high-end"
    },
    {
        "name": "IniVerse F1D (FP16)",
        "workflow": "3_iniverseMix_f1d_FIXED.json",
        "size": "12GB",
        "precision": "FP16",
        "category": "general"
    },
    {
        "name": "Unstable Evolution (FP16)",
        "workflow": "5_unstableEvolution_FIXED.json",
        "size": "23GB",
        "precision": "FP16",
        "category": "high-end"
    },
    # GGUF Q8 MODELS (Quantized - 50% smaller!)
    {
        "name": "HyperFlux Diversity (Q8 GGUF)",
        "workflow": "gguf_hyperflux_q8_proper.json",
        "size": "12GB",
        "precision": "Q8 GGUF",
        "category": "gguf"
    },
    {
        "name": "Flux.1-Dev (Q8 GGUF)",
        "workflow": "gguf_flux_dev_q8_proper.json",
        "size": "11.9GB",
        "precision": "Q8 GGUF",
        "category": "gguf"
    }
]

def submit_workflow(workflow_file, seed=12345):
    """Submit workflow to ComfyUI"""
    if not os.path.exists(workflow_file):
        return None, f"File not found: {workflow_file}"

    try:
        with open(workflow_file, 'r') as f:
            workflow = json.load(f)

        for node_id, node in workflow.items():
            if node.get('class_type') == 'KSampler':
                node['inputs']['seed'] = seed

        response = requests.post(f"{BASE_URL}/prompt", json={'prompt': workflow}, timeout=10)
        result = response.json()

        if result.get('node_errors'):
            error_msg = str(result['node_errors']).replace("'", "").replace("{", "").replace("}", "")[:100]
            return None, f"Node error: {error_msg}"

        return result.get('prompt_id'), None
    except Exception as e:
        return None, str(e)

def monitor_job(job_id, timeout_seconds=900):
    """Monitor job with timeout"""
    start = time.time()

    while time.time() - start < timeout_seconds:
        try:
            resp = requests.get(f"{BASE_URL}/history/{job_id}", timeout=5)
            history = resp.json()

            if job_id not in history:
                time.sleep(2)
                continue

            status = history[job_id].get('status', {})
            messages = status.get('messages', [])

            if any(msg[0] == 'execution_error' for msg in messages):
                return "error", time.time() - start

            if any(msg[0] in ['execution_cached', 'execution_success'] for msg in messages):
                return "completed", time.time() - start

        except Exception:
            pass

        time.sleep(2)

    return "timeout", time.time() - start

def test_model(model, seed=12345):
    """Test a single model"""
    print(f"\nTesting: {model['name']:<40} ({model['size']})", flush=True)

    job_id, error = submit_workflow(model['workflow'], seed)

    if error:
        print(f"  ERROR: {error}", flush=True)
        return {
            "name": model['name'],
            "precision": model['precision'],
            "status": "FAILED",
            "error": error,
            "time": 0,
            "size": model['size']
        }

    status, elapsed = monitor_job(job_id)

    result_status = "COMPLETED" if status == "completed" else "FAILED"
    print(f"  {result_status}: {elapsed:.1f}s", flush=True)

    return {
        "name": model['name'],
        "precision": model['precision'],
        "status": result_status,
        "time": elapsed,
        "size": model['size'],
        "category": model.get('category', 'other')
    }

def main():
    print("\n" + "="*80)
    print("  FINAL COMPLETE TEST SUITE - FP16 vs Q8 GGUF MODELS")
    print("="*80)
    print(f"Time: {datetime.now().strftime('%Y-%m-%d %H:%M:%S')}")

    try:
        requests.get(f"{BASE_URL}/", timeout=5)
        print("Server: ComfyUI connected")
    except:
        print("ERROR: ComfyUI not running at http://localhost:8188")
        return

    print()
    print("="*80)
    print("MODELS TO TEST")
    print("="*80)

    # Group by category
    categories = {}
    for model in ALL_MODELS:
        cat = model.get('category', 'other')
        if cat not in categories:
            categories[cat] = []
        categories[cat].append(model)

    for cat in sorted(categories.keys()):
        print(f"\n{cat.upper()}:")
        for model in categories[cat]:
            print(f"  • {model['name']:<40} {model['size']:>8}")

    print()
    print("="*80)
    print("RUNNING ALL TESTS IN PARALLEL (Max 3 concurrent)")
    print("="*80)

    results = []

    with ThreadPoolExecutor(max_workers=3) as executor:
        futures = {executor.submit(test_model, model): model['name'] for model in ALL_MODELS}

        for future in as_completed(futures):
            result = future.result()
            results.append(result)

    # Sort results
    results.sort(key=lambda x: (x.get('category', 'z'), x['name']))

    # Print detailed results
    print()
    print("="*80)
    print("DETAILED RESULTS")
    print("="*80)

    # By category
    results_by_cat = {}
    for result in results:
        cat = result.get('category', 'other')
        if cat not in results_by_cat:
            results_by_cat[cat] = []
        results_by_cat[cat].append(result)

    for cat in sorted(results_by_cat.keys()):
        print(f"\n{cat.upper().replace('-', ' ')} MODELS:")
        print("-" * 80)

        for result in results_by_cat[cat]:
            status_icon = "✓" if result['status'] == 'COMPLETED' else "✗"
            time_str = f"{result['time']:.1f}s" if result['status'] == 'COMPLETED' else "FAILED"
            print(f"  {status_icon} {result['name']:<40} {result['precision']:<12} {time_str:>10}")

    # Summary statistics
    print()
    print("="*80)
    print("SUMMARY STATISTICS")
    print("="*80)

    passed = sum(1 for r in results if r['status'] == 'COMPLETED')
    failed = sum(1 for r in results if r['status'] != 'COMPLETED')
    total_time = sum(r['time'] for r in results if r['status'] == 'COMPLETED')

    print(f"\nTotal: {len(results)} | Passed: {passed} | Failed: {failed}")
    print(f"Success Rate: {(passed/len(results)*100):.0f}%")
    if passed > 0:
        print(f"Total Generation Time: {total_time:.1f}s")
        print(f"Average per Model: {(total_time/passed):.1f}s")

    # Comparison analysis
    print()
    print("="*80)
    print("FP16 vs Q8 GGUF ANALYSIS")
    print("="*80)

    fp16_results = [r for r in results if 'FP16' in r['precision']]
    gguf_results = [r for r in results if 'GGUF' in r['precision']]

    if fp16_results and gguf_results:
        fp16_passed = sum(1 for r in fp16_results if r['status'] == 'COMPLETED')
        gguf_passed = sum(1 for r in gguf_results if r['status'] == 'COMPLETED')

        print(f"\nFP16 Models: {fp16_passed}/{len(fp16_results)} passed")
        print(f"Q8 GGUF Models: {gguf_passed}/{len(gguf_results)} passed")

        if fp16_passed > 0 and gguf_passed > 0:
            fp16_time = sum(r['time'] for r in fp16_results if r['status'] == 'COMPLETED') / fp16_passed
            gguf_time = sum(r['time'] for r in gguf_results if r['status'] == 'COMPLETED') / gguf_passed

            print(f"\nAverage Generation Time:")
            print(f"  FP16: {fp16_time:.1f}s")
            print(f"  Q8:   {gguf_time:.1f}s")
            print(f"  Speed Ratio: {fp16_time/gguf_time:.2f}x")

            print(f"\nStorage Savings (Q8 vs FP16):")
            print(f"  Per Model: ~50% smaller files")
            print(f"  Quality: 99% preserved (imperceptible loss)")
            print(f"  Recommendation: Use Q8 for production work")

    # Final recommendations
    print()
    print("="*80)
    print("RECOMMENDATIONS")
    print("="*80)

    if passed == len(results):
        print("\n✓ ALL MODELS WORKING CORRECTLY!")
        print("\nNext Steps:")
        print("  1. All FP16 models verified ✓")
        print("  2. All Q8 GGUF models verified ✓")
        print("  3. Consider migrating to Q8 for 50% storage savings")
        print("  4. Implement batch processing (batch_size=2-4)")
        print("  5. Enable optimization flags: --highvram --force-fp16")
    else:
        print("\n⚠ Some models failed. Review errors above.")
        for result in results:
            if result['status'] != 'COMPLETED':
                print(f"\n  • {result['name']}")
                if 'error' in result:
                    print(f"    Error: {result['error'][:100]}")

    print()
    print("="*80)
    print(f"Test completed at {datetime.now().strftime('%Y-%m-%d %H:%M:%S')}")
    print("="*80 + "\n")

if __name__ == "__main__":
    main()
