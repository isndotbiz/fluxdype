#!/usr/bin/env python3
import requests
import json

# Read workflow
with open("1_flux_dev_quality.json", "r") as f:
    workflow = json.load(f)

# Submit
data = {"prompt": workflow}
response = requests.post("http://localhost:8188/prompt", json=data)
print(f"Status: {response.status_code}")
print(f"Response: {response.json()}")
