#!/usr/bin/env python3
"""Create a test workflow with the dual LoRA setup."""

import json

# Load dual LoRA template
with open('HyperFlux-Turbo-DualLoRA-FIXED.json', 'r') as f:
    workflow = json.load(f)

workflow['id'] = "dual-lora-test"

# Set a test prompt
test_prompt = """raw unedited photo, medium shot of a stunning Brazilian woman on Copacabana beach at golden hour; she is wearing denim shorts and a white crop top, torso bare underneath; warm sunset light creating soft highlights on her bronze skin; she is looking directly at camera with a confident smile, wind blowing her long dark hair; authentic skin texture, visible pores, natural imperfections, Fujifilm XT4, ISO 400, f/2.8, unretouched photograph, photorealistic"""

for node in workflow['nodes']:
    if node['id'] == 17 and node['type'] == 'CLIPTextEncode':
        node['widgets_values'] = [test_prompt]
    
    if node['id'] == 23 and node['type'] == 'EmptySD3LatentImage':
        node['widgets_values'] = [896, 1152, 1]
    
    if node['id'] == 5 and node['type'] == 'SaveImage':
        node['widgets_values'] = ["DualLoRA_Test"]

# Save test workflow
with open('workflows/dual_lora_test.json', 'w') as f:
    json.dump(workflow, f, indent=2)

print("✓ Created: workflows/dual_lora_test.json")
print()
print("Test Configuration:")
print("  - Resolution: 896x1152")
print("  - Steps: 12")
print("  - Guidance: 1.8")
print("  - Turbo LoRA: 0.8")
print("  - Realism LoRA: 0.8")
print()
print("🚀 To test:")
print("   python submit-workflow.py workflows/dual_lora_test.json")
print()
print("⚠️  If submission fails with LoRA error:")
print("   1. Open HyperFlux-Turbo-DualLoRA-FIXED.json in a text editor")
print("   2. Find node 14 (Power Lora Loader)")
print("   3. Change the second LoRA filename to match your actual file")
print("   4. Re-run this script")
