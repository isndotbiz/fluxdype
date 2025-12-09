#!/usr/bin/env python3
import requests
import json
import time

workflows = [
    "2_fluxedUp_NSFW.json",
    "3_iniverseMix_f1d.json",
    "4_iniverseMix_guofeng.json",
    "5_unstableEvolution.json"
]

for wf in workflows:
    print(f"\nTesting: {wf}")
    try:
        with open(wf, "r") as f:
            workflow = json.load(f)

        data = {"prompt": workflow}
        response = requests.post("http://localhost:8188/prompt", json=data, timeout=10)
        result = response.json()

        if result.get("node_errors"):
            print(f"  ERROR: {result['node_errors']}")
        else:
            print(f"  SUCCESS: prompt_id = {result.get('prompt_id')}")

    except Exception as e:
        print(f"  FAILED: {e}")

    time.sleep(2)  # Wait between submissions

print("\nAll workflows submitted!")
