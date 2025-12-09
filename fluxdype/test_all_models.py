#!/usr/bin/env python3
"""
Test all Flux models with their workflows
"""

import requests
import json
import time
import sys
from pathlib import Path

COMFY_URL = "http://localhost:8188"

workflows = [
    "1_flux_dev_quality.json",
    "2_fluxedUp_NSFW.json",
    "3_iniverseMix_f1d.json",
    "4_iniverseMix_guofeng.json",
    "5_unstableEvolution.json"
]

def test_workflow(workflow_file):
    """Test a single workflow"""
    print(f"\n{'='*70}")
    print(f"Testing: {workflow_file}")
    print(f"{'='*70}")

    workflow_path = Path(__file__).parent / workflow_file

    if not workflow_path.exists():
        print(f"ERROR: Workflow file not found: {workflow_path}")
        return False

    # Load workflow
    with open(workflow_path, 'r') as f:
        workflow = json.load(f)

    # Submit to ComfyUI
    data = {
        "prompt": workflow,
        "client_id": "test_script"
    }

    try:
        print(f"Submitting workflow to {COMFY_URL}/prompt...")
        start_time = time.time()

        response = requests.post(
            f"{COMFY_URL}/prompt",
            json=data,
            timeout=10
        )
        response.raise_for_status()
        result = response.json()

        prompt_id = result.get("prompt_id")
        if not prompt_id:
            print(f"ERROR: No prompt_id returned: {result}")
            return False

        print(f"✓ Submitted successfully! Prompt ID: {prompt_id}")
        print(f"⏱  Waiting for generation to complete...")

        # Wait for completion (check every 5 seconds)
        max_wait = 300  # 5 minutes max
        elapsed = 0

        while elapsed < max_wait:
            time.sleep(5)
            elapsed += 5

            # Check history
            history_response = requests.get(f"{COMFY_URL}/history/{prompt_id}")
            history = history_response.json()

            if prompt_id in history:
                duration = time.time() - start_time
                print(f"✓ Generation completed in {duration:.2f} seconds!")

                # Check for outputs
                outputs = history[prompt_id].get("outputs", {})
                if outputs:
                    print(f"✓ Images generated:")
                    for node_id, output in outputs.items():
                        if "images" in output:
                            for img in output["images"]:
                                print(f"  - {img.get('filename', 'unknown')}")

                return True

            print(f"  Still generating... ({elapsed}s elapsed)")

        print(f"ERROR: Timeout waiting for generation (max {max_wait}s)")
        return False

    except requests.exceptions.ConnectionError:
        print(f"ERROR: Cannot connect to ComfyUI at {COMFY_URL}")
        print(f"Make sure ComfyUI server is running!")
        return False
    except Exception as e:
        print(f"ERROR: {e}")
        return False

def main():
    print("\n" + "="*70)
    print("FLUX MODEL TESTING SUITE")
    print("="*70)
    print(f"ComfyUI Server: {COMFY_URL}")
    print(f"Total workflows to test: {len(workflows)}")

    # Check if server is running
    try:
        response = requests.get(f"{COMFY_URL}/system_stats", timeout=5)
        print(f"✓ ComfyUI server is running")
    except:
        print(f"\n❌ ERROR: ComfyUI server is not responding at {COMFY_URL}")
        print(f"Please start the server with: .\\start-comfy.ps1")
        sys.exit(1)

    # Test each workflow
    results = {}
    for workflow in workflows:
        success = test_workflow(workflow)
        results[workflow] = success

        if not success:
            print(f"\n⚠️  Workflow failed: {workflow}")
            # Don't stop, continue with other workflows

        # Wait a bit between tests
        if workflow != workflows[-1]:
            print(f"\nWaiting 3 seconds before next test...")
            time.sleep(3)

    # Summary
    print(f"\n{'='*70}")
    print("TEST SUMMARY")
    print(f"{'='*70}")

    passed = sum(1 for v in results.values() if v)
    failed = len(results) - passed

    for workflow, success in results.items():
        status = "✓ PASSED" if success else "❌ FAILED"
        print(f"{status}: {workflow}")

    print(f"\nTotal: {passed}/{len(results)} passed, {failed} failed")

    if failed == 0:
        print(f"\n🎉 All models tested successfully!")
    else:
        print(f"\n⚠️  Some models failed testing. Check logs above for details.")

    print(f"\nGenerated images are in: D:\\workspace\\fluxdype\\ComfyUI\\output\\")
    print("")

if __name__ == "__main__":
    main()
