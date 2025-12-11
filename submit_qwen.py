#!/usr/bin/env python3
import json
import urllib.request
import urllib.error
import time
import sys
import os

os.environ['PYTHONIOENCODING'] = 'utf-8'

SERVER_URL = "http://localhost:8188"

print("=" * 60)
print("Qwen FP8 Optimized Workflow Submission")
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

# Submit workflow
print("\nSubmitting Qwen FP8 workflow...")
try:
    with open("qwen_fp8_optimized.json", 'r') as f:
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
            print(f"[OK] Qwen FP8 workflow submitted: {job_id}")
            print(f"\nSettings:")
            print(f"  - Model: qwen_image_fp8_e4m3fn.safetensors")
            print(f"  - Steps: 20")
            print(f"  - CFG: 2.5")
            print(f"  - Sampler: euler")
            print(f"  - Size: 1024x1024")
            print(f"\nOutput will be saved to:")
            print(f"  D:\\workspace\\fluxdype\\ComfyUI\\output\\")
            print(f"\nJob ID: {job_id}")
    except urllib.error.HTTPError as http_err:
        error_body = http_err.read().decode('utf-8')
        print(f"[FAIL] HTTP {http_err.code}: {http_err.reason}")
        try:
            err_json = json.loads(error_body)
            if 'error' in err_json:
                print(f"  Error: {err_json['error'].get('message', 'Unknown')}")
        except:
            print(f"  Error body: {error_body}")
        sys.exit(1)

except FileNotFoundError:
    print("[FAIL] Workflow file not found: qwen_fp8_optimized.json")
    sys.exit(1)
except json.JSONDecodeError as json_err:
    print(f"[FAIL] Invalid JSON in workflow: {json_err}")
    sys.exit(1)
except Exception as e:
    print(f"[FAIL] Error: {str(e)}")
    sys.exit(1)

print("\n" + "=" * 60)
