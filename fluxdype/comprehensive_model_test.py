#!/usr/bin/env python3
"""
Comprehensive Model Testing Suite
Tests ALL models in parallel and generates detailed report
"""
import requests
import json
import time
import os
from datetime import datetime
from concurrent.futures import ThreadPoolExecutor, as_completed

BASE_URL = "http://localhost:8188"

# All test models
MODELS = [
    {
        "name": "Flux Dev Quality",
        "workflow": "1_flux_dev_quality.json",
        "model_size": "16GB",
        "type": "FP16",
        "category": "baseline"
    },
    {
        "name": "FluxedUp NSFW",
        "workflow": "2_fluxedUp_NSFW_FIXED.json",
        "model_size": "23GB",
        "type": "FP16",
        "category": "high-performance"
    },
    {
        "name": "IniVerse Mix F1D",
        "workflow": "3_iniverseMix_f1d_FIXED.json",
        "model_size": "12GB",
        "type": "FP16",
        "category": "general"
    },
    {
        "name": "Unstable Evolution",
        "workflow": "5_unstableEvolution_FIXED.json",
        "model_size": "23GB",
        "type": "FP16",
        "category": "high-performance"
    }
]

def submit_workflow(workflow_file, seed=12345):
    """Submit workflow and return job ID"""
    if not os.path.exists(workflow_file):
        return None, f"File not found: {workflow_file}"

    try:
        with open(workflow_file, 'r') as f:
            workflow = json.load(f)

        # Update seed
        for node_id, node in workflow.items():
            if node.get('class_type') == 'KSampler':
                node['inputs']['seed'] = seed

        response = requests.post(f"{BASE_URL}/prompt", json={'prompt': workflow}, timeout=10)
        result = response.json()

        if result.get('node_errors'):
            return None, f"Submission error: {result['node_errors']}"

        return result.get('prompt_id'), None
    except Exception as e:
        return None, str(e)

def monitor_job(job_id, timeout_seconds=900):
    """Monitor a job until completion"""
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

            # Check for error
            if any(msg[0] == 'execution_error' for msg in messages):
                return "error", time.time() - start

            # Check for completion
            if any(msg[0] in ['execution_cached', 'execution_success'] for msg in messages):
                return "completed", time.time() - start

        except Exception as e:
            pass

        time.sleep(2)

    return "timeout", time.time() - start

def test_model(model, seed=12345):
    """Test a single model"""
    print(f"\n{'='*60}")
    print(f"Testing: {model['name']}")
    print(f"{'='*60}")
    print(f"  Type: {model['type']}")
    print(f"  Size: {model['model_size']}")
    print(f"  Workflow: {model['workflow']}")
    print(f"  Status: Submitting...", end="", flush=True)

    job_id, error = submit_workflow(model['workflow'], seed)

    if error:
        print(f"\n  ERROR: {error}")
        return {
            "name": model['name'],
            "status": "FAILED",
            "error": error,
            "time": 0
        }

    print(f" OK (ID: {job_id[:8]}...)")
    print(f"  Status: Monitoring...", end="", flush=True)

    status, elapsed = monitor_job(job_id)

    print(f" {status.upper()} ({elapsed:.1f}s)")

    return {
        "name": model['name'],
        "status": status.upper(),
        "time": elapsed,
        "model_size": model['model_size'],
        "type": model['type'],
        "category": model['category']
    }

def main():
    print("\n" + "="*60)
    print("  COMPREHENSIVE MODEL TEST SUITE")
    print("="*60)
    print(f"Time: {datetime.now().strftime('%Y-%m-%d %H:%M:%S')}")

    # Check server
    try:
        requests.get(f"{BASE_URL}/", timeout=5)
        print("Server: ComfyUI connected")
    except:
        print("ERROR: ComfyUI not running")
        return

    print()
    print("="*60)
    print("TESTING CONFIGURATION")
    print("="*60)

    for i, model in enumerate(MODELS, 1):
        print(f"\n{i}. {model['name']}")
        print(f"   Type: {model['type']} | Size: {model['model_size']}")
        print(f"   Workflow: {model['workflow']}")

    print()
    print("="*60)
    print("RUNNING TESTS (Parallel)")
    print("="*60)

    results = []

    # Run tests in parallel
    with ThreadPoolExecutor(max_workers=2) as executor:
        futures = {executor.submit(test_model, model): model['name'] for model in MODELS}

        for future in as_completed(futures):
            result = future.result()
            results.append(result)

    # Sort by category
    results.sort(key=lambda x: (x['category'], x['name']))

    # Print results
    print()
    print("="*60)
    print("TEST RESULTS SUMMARY")
    print("="*60)
    print()

    passed = sum(1 for r in results if r['status'] == 'COMPLETED')
    failed = sum(1 for r in results if r['status'] != 'COMPLETED')
    total_time = sum(r['time'] for r in results)

    # By category
    categories = {}
    for result in results:
        cat = result['category']
        if cat not in categories:
            categories[cat] = []
        categories[cat].append(result)

    for category in sorted(categories.keys()):
        print(f"\n{category.upper().replace('-', ' ')} MODELS:")
        print("-" * 60)

        for result in categories[category]:
            status_icon = "✓" if result['status'] == 'COMPLETED' else "✗"
            time_str = f"{result['time']:.1f}s" if result['status'] == 'COMPLETED' else "FAILED"
            print(f"  {status_icon} {result['name']:<30} {time_str:>12}")

    print()
    print("="*60)
    print("OVERALL STATISTICS")
    print("="*60)
    print(f"\nTotal Models: {len(results)}")
    print(f"Passed: {passed}")
    print(f"Failed: {failed}")
    print(f"Success Rate: {(passed/len(results)*100):.1f}%")
    print(f"Total Generation Time: {total_time:.1f}s")
    if passed > 0:
        print(f"Average Time per Model: {(total_time/passed):.1f}s")

    print()
    print("="*60)
    print("RECOMMENDATIONS")
    print("="*60)

    if passed == len(results):
        print("\n✓ All models working correctly!")
        print("\nNext Steps:")
        print("  1. Consider converting large FP16 models to Q8 GGUF")
        print("  2. Test batch processing (batch_size=2-4)")
        print("  3. Implement TeaCache optimization")
        print("  4. Use launch flags: --highvram --force-fp16 --bf16-vae --bf16-text-enc")
    else:
        print("\n✗ Some models failed:")
        for result in results:
            if result['status'] != 'COMPLETED':
                print(f"  - {result['name']}: {result.get('error', result['status'])}")

    print()
    print("="*60)
    print()

if __name__ == "__main__":
    main()
