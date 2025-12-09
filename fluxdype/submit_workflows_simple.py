#!/usr/bin/env python3
import json
import urllib.request
import urllib.error
import time
import sys
import os

os.environ['PYTHONIOENCODING'] = 'utf-8'

SERVER_URL = "http://localhost:8188"
WORKFLOWS = [
    ("image_1_landscape.json", "Landscape"),
    ("image_2_abstract.json", "Abstract Art"),
    ("image_3_portrait.json", "Portrait")
]

print("=" * 50)
print("ComfyUI Workflow Submission")
print("=" * 50)

# Wait for server
print("\nWaiting for server...")
server_ready = False
for i in range(10):
    try:
        req = urllib.request.Request(f"{SERVER_URL}/system_stats")
        with urllib.request.urlopen(req, timeout=5) as response:
            print("[OK] Server is ready!")
            server_ready = True
            break
    except Exception as wait_err:
        if i < 9:
            print(f"  Attempt {i+1}/10... (waiting)")
            time.sleep(3)
        else:
            print("[FAIL] Server did not respond after 10 attempts")
            print(f"Error: {wait_err}")
            sys.exit(1)

if not server_ready:
    print("[FAIL] Failed to connect to server")
    sys.exit(1)

# Submit workflows
jobs = []
print("\nSubmitting workflows...")

for workflow_file, desc in WORKFLOWS:
    try:
        with open(workflow_file, 'r') as f:
            workflow = json.load(f)

        json_data = json.dumps(workflow).encode('utf-8')
        req = urllib.request.Request(
            f"{SERVER_URL}/prompt",
            data=json_data,
            headers={'Content-Type': 'application/json'}
        )

        with urllib.request.urlopen(req, timeout=30) as response:
            data = json.loads(response.read())
            job_id = data.get('prompt_id')
            jobs.append(job_id)
            print(f"[OK] {desc}: {job_id}")

    except Exception as e:
        print(f"[FAIL] {desc}: {str(e)}")

print("\n" + "=" * 50)
if jobs:
    print(f"[OK] Submitted {len(jobs)} image(s)")
    print(f"\nOutput: D:\\workspace\\fluxdype\\ComfyUI\\output\\")
else:
    print("[FAIL] No workflows submitted")
    sys.exit(1)
