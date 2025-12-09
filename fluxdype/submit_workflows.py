#!/usr/bin/env python3
import json
import requests
import time
import sys

SERVER_URL = "http://localhost:8188"
WORKFLOWS = [
    ("image_1_landscape.json", "Landscape"),
    ("image_2_abstract.json", "Abstract Art"),
    ("image_3_portrait.json", "Portrait")
]

print("=" * 50)
print("ComfyUI Workflow Submission")
print("=" * 50)

# Wait for server to be ready
print("\nWaiting for server...")
for i in range(10):
    try:
        resp = requests.get(f"{SERVER_URL}/system_stats", timeout=5)
        print("✓ Server is ready!")
        break
    except:
        if i < 9:
            print(f"  Attempt {i+1}/10...")
            time.sleep(3)
        else:
            print("✗ Server did not respond. Check if ComfyUI is running.")
            sys.exit(1)

# Submit workflows
jobs = []
print("\nSubmitting workflows...")

for workflow_file, desc in WORKFLOWS:
    try:
        with open(workflow_file, 'r') as f:
            workflow = json.load(f)

        response = requests.post(
            f"{SERVER_URL}/prompt",
            json=workflow,
            timeout=30
        )

        if response.status_code == 200:
            data = response.json()
            job_id = data.get('prompt_id')
            jobs.append(job_id)
            print(f"✓ {desc}: {job_id}")
        else:
            print(f"✗ {desc}: Error {response.status_code}")

    except Exception as e:
        print(f"✗ {desc}: {str(e)}")

print("\n" + "=" * 50)
if jobs:
    print(f"✓ Submitted {len(jobs)} image(s)")
    print("\nJob IDs:")
    for i, job_id in enumerate(jobs, 1):
        print(f"  {i}. {job_id}")

    print(f"\nOutput: D:\\workspace\\fluxdype\\ComfyUI\\output\\")
    print("\nMonitoring progress...")

    # Monitor progress
    completed = set()
    check_count = 0

    while len(completed) < len(jobs) and check_count < 360:
        for job_id in jobs:
            if job_id in completed:
                continue

            try:
                hist_response = requests.get(f"{SERVER_URL}/history/{job_id}", timeout=5)
                if hist_response.status_code == 200:
                    history = hist_response.json()
                    if history.get(job_id):
                        print(f"✓ Job {job_id[:8]}... completed!")
                        completed.add(job_id)
            except:
                pass

        if len(completed) < len(jobs):
            remaining = len(jobs) - len(completed)
            print(f"  {remaining} image(s) still processing...")
            time.sleep(10)
            check_count += 1

    if len(completed) == len(jobs):
        print("\n" + "=" * 50)
        print("✓✓✓ ALL IMAGES GENERATED! ✓✓✓")
        print("=" * 50)
    else:
        print(f"\nGeneration in progress: {len(completed)}/{len(jobs)} completed")
else:
    print("✗ No workflows submitted successfully")
    sys.exit(1)
