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
print("ComfyUI Workflow Submission (DEBUG)")
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
        print(f"\n--- Submitting {desc} ---")
        print(f"File: {workflow_file}")

        with open(workflow_file, 'r') as f:
            workflow = json.load(f)

        print(f"Workflow loaded, {len(workflow)} nodes")

        json_data = json.dumps(workflow).encode('utf-8')
        print(f"JSON size: {len(json_data)} bytes")

        req = urllib.request.Request(
            f"{SERVER_URL}/prompt",
            data=json_data,
            headers={'Content-Type': 'application/json'}
        )

        try:
            with urllib.request.urlopen(req, timeout=30) as response:
                response_text = response.read().decode('utf-8')
                print(f"Response code: {response.status}")
                data = json.loads(response_text)
                job_id = data.get('prompt_id')
                jobs.append(job_id)
                print(f"[OK] {desc}: {job_id}")
        except urllib.error.HTTPError as http_err:
            error_body = http_err.read().decode('utf-8')
            print(f"[FAIL] HTTP {http_err.code}: {http_err.reason}")
            print(f"Error body: {error_body}")
        except Exception as inner_err:
            print(f"[FAIL] Connection error: {inner_err}")

    except FileNotFoundError:
        print(f"[FAIL] {desc}: File not found: {workflow_file}")
    except json.JSONDecodeError as json_err:
        print(f"[FAIL] {desc}: Invalid JSON: {json_err}")
    except Exception as e:
        print(f"[FAIL] {desc}: {str(e)}")

print("\n" + "=" * 50)
if jobs:
    print(f"[OK] Submitted {len(jobs)} image(s)")
    print(f"\nOutput: D:\\workspace\\fluxdype\\ComfyUI\\output\\")
else:
    print("[FAIL] No workflows submitted")
    sys.exit(1)
