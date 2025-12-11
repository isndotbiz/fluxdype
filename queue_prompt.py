import json
import urllib.request
import urllib.parse
import random
import uuid

# Load the workflow
with open('HyperFlux-Turbo-REALISTIC-FIXED.json', 'r') as f:
    workflow = json.load(f)

# Update the prompt text in node 17 (CLIPTextEncode)
for node in workflow['nodes']:
    if node['type'] == 'CLIPTextEncode':
        node['widgets_values'][0] = "exotic brazilian woman, detailed face, 8k, photorealistic, professional, perfect composition, sharp focus, beautiful skin, natural lighting"
    # Randomize seed
    if node['type'] == 'RandomNoise':
        node['widgets_values'][0] = random.randint(0, 999999999)

# Prepare the API request
prompt_data = {
    "prompt": workflow,
    "client_id": str(uuid.uuid4())
}

# Send to ComfyUI
url = "http://localhost:8188/prompt"
headers = {'Content-Type': 'application/json'}
data = json.dumps(prompt_data).encode('utf-8')

req = urllib.request.Request(url, data=data, headers=headers)
with urllib.request.urlopen(req) as response:
    result = json.loads(response.read().decode('utf-8'))
    print(f"✓ Queued successfully! Prompt ID: {result.get('prompt_id', 'unknown')}")
    print(f"Queue number: {result.get('number', 'unknown')}")
