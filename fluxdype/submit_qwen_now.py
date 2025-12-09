#!/usr/bin/env python3
import json
import urllib.request
import urllib.error
import time
import sys
import os

os.environ['PYTHONIOENCODING'] = 'utf-8'

SERVER_URL = "http://localhost:8188"

print("Submitting Qwen FP8 Image...\n")

try:
    with open("qwen_working.json", 'r') as f:
        workflow = json.load(f)

    api_payload = {"prompt": workflow}
    json_data = json.dumps(api_payload).encode('utf-8')

    req = urllib.request.Request(
        f"{SERVER_URL}/prompt",
        data=json_data,
        headers={'Content-Type': 'application/json'}
    )

    with urllib.request.urlopen(req, timeout=30) as response:
        data = json.loads(response.read().decode('utf-8'))
        job_id = data.get('prompt_id')
        print(f"SUCCESS! Job ID: {job_id}\n")
        print("Generating with Qwen Image FP8")
        print("- Steps: 20")
        print("- CFG: 2.5")
        print("- Resolution: 1024x1024")
        print(f"\nOutput: D:\\workspace\\fluxdype\\ComfyUI\\output\\")

except urllib.error.HTTPError as e:
    print(f"FAILED: HTTP {e.code}")
    print(e.read().decode('utf-8'))
    sys.exit(1)
except Exception as e:
    print(f"ERROR: {e}")
    sys.exit(1)
