#!/usr/bin/env python3
"""
Test all 4 FIXED workflows - 2 images each
"""
import requests
import json
import time

workflows = [
    ("2_fluxedUp_NSFW_FIXED.json", "FluxedUp NSFW", [54321, 99999]),
    ("3_iniverseMix_f1d_FIXED.json", "IniVerse Mix F1D", [98765, 88888]),
    ("4_iniverseMix_guofeng_FIXED.json", "IniVerse Mix Guofeng", [11111, 22222]),
    ("5_unstableEvolution_FIXED.json", "Unstable Evolution", [77777, 66666])
]

print("\n" + "="*70)
print("TESTING 4 FIXED MODELS - 2 IMAGES EACH")
print("="*70)

for wf_file, model_name, seeds in workflows:
    print(f"\n{'='*70}")
    print(f"MODEL: {model_name}")
    print(f"{'='*70}")

    for i, seed in enumerate(seeds, 1):
        print(f"\n  Image {i}/2 (seed: {seed})...")

        try:
            # Load workflow
            with open(wf_file, "r") as f:
                workflow = json.load(f)

            # Update seed
            for node_id, node in workflow.items():
                if node.get("class_type") == "KSampler":
                    node["inputs"]["seed"] = seed

            # Submit
            data = {"prompt": workflow}
            response = requests.post("http://localhost:8188/prompt", json=data, timeout=10)
            result = response.json()

            if result.get("node_errors"):
                print(f"    ERROR: {result['node_errors']}")
            else:
                prompt_id = result.get('prompt_id')
                print(f"    Submitted! ID: {prompt_id}")

        except Exception as e:
            print(f"    FAILED: {e}")

        time.sleep(2)  # Small delay between submissions

print(f"\n{'='*70}")
print("ALL WORKFLOWS SUBMITTED!")
print(f"{'='*70}")
print("\nWait ~5-10 minutes for all generations to complete")
print("Images will be in: D:\\workspace\\fluxdype\\ComfyUI\\output\\")
print("")
