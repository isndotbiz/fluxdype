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
    ("qwen_1_portrait.json", "Portrait"),
    ("qwen_2_landscape.json", "Landscape"),
    ("qwen_3_abstract.json", "Abstract Art")
]

print("=" * 60)
print("Qwen FP8 Optimized Workflow Submission (3 Images)")
print("=" * 60)

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

        # Wrap workflow in "prompt" key as required by ComfyUI API
        api_payload = {"prompt": workflow}
        json_data = json.dumps(api_payload).encode('utf-8')

        req = urllib.request.Request(
            f"{SERVER_URL}/prompt",
            data=json_data,
            headers={'Content-Type': 'application/json'}
        )

        try:
            with urllib.request.urlopen(req, timeout=30) as response:
                response_text = response.read().decode('utf-8')
                data = json.loads(response_text)
                job_id = data.get('prompt_id')
                jobs.append(job_id)
                print(f"[OK] {desc}: {job_id}")
        except urllib.error.HTTPError as http_err:
            error_body = http_err.read().decode('utf-8')
            print(f"[FAIL] HTTP {http_err.code}: {http_err.reason}")
            try:
                err_json = json.loads(error_body)
                if 'error' in err_json:
                    print(f"  Error: {err_json['error'].get('message', 'Unknown')}")
            except:
                print(f"  Error body: {error_body}")

    except FileNotFoundError:
        print(f"[FAIL] {desc}: File not found: {workflow_file}")
    except json.JSONDecodeError as json_err:
        print(f"[FAIL] {desc}: Invalid JSON: {json_err}")
    except Exception as e:
        print(f"[FAIL] {desc}: {str(e)}")

print("\n" + "=" * 60)
if jobs:
    print(f"[OK] Submitted {len(jobs)} image(s)")
    print(f"\nModel: Qwen Image FP8")
    print(f"Settings: 20 steps, CFG 2.5, Euler sampler")
    print(f"\nOutput: D:\\workspace\\fluxdype\\ComfyUI\\output\\")
    print("\nJob IDs:")
    for i, job_id in enumerate(jobs, 1):
        print(f"  {i}. {job_id}")
else:
    print("[FAIL] No workflows submitted")
    sys.exit(1)
