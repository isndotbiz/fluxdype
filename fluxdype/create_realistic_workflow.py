#!/usr/bin/env python3
"""
Create REALISTIC workflow with improvements:
- 12 steps instead of 8 (still fast, better detail)
- Lower guidance (1.5-2.0) to reduce painting effect
- Enhanced prompts with realism keywords
- Raw photo emphasis
"""

import json

# Load template
with open('HyperFlux-Turbo-NSFW-Fast-FIXED.json', 'r') as f:
    template = json.load(f)

# Create enhanced realism version
workflow = json.loads(json.dumps(template))
workflow['id'] = "brazilian-realistic-enhanced"

# Update nodes for realism
for node in workflow['nodes']:
    # Increase steps from 8 to 12
    if node['id'] == 16 and node['type'] == 'BasicScheduler':
        node['widgets_values'] = ["beta", 12, 1]  # 12 steps
        node['properties']['_notes'] = "12 Steps for better realism without major speed hit"
    
    # Lower guidance to reduce painting effect
    if node['id'] == 4 and node['type'] == 'FluxGuidance':
        node['widgets_values'] = [1.8]  # Lower from 3.5 to 1.8
    
    # Lower Turbo LoRA strength to reduce stylization
    if node['id'] == 14 and node['type'] == 'Power Lora Loader (rgthree)':
        # Reduce from 0.85 to 0.75 for more photorealism
        node['widgets_values'][2]['strength'] = 0.75

# Save enhanced workflow template
with open('HyperFlux-Turbo-REALISTIC-FIXED.json', 'w') as f:
    json.dump(workflow, f, indent=2)

print("✓ Created: HyperFlux-Turbo-REALISTIC-FIXED.json")
print("  Settings:")
print("  - Steps: 12 (was 8)")
print("  - Guidance: 1.8 (was 3.5)")
print("  - Turbo LoRA: 0.75 (was 0.85)")
print("  - Result: More realistic, less 'painted' look")
print()

# Now create the realistic midnight passenger
realistic_prompt = """raw unedited photo, POV from driver seat looking at stunning Brazilian woman in luxury car passenger seat at night; she is wearing white skirt but completely topless; dynamic orange streetlights passing through window creating moving highlights across her bronze skin and breasts; she looks out window with bored sultry expression, one hand on bare thigh; bokeh city lights, motion blur background, sharp focus on torso, high contrast shadows, film noir, Fujifilm XT4, ISO 1600, authentic skin texture, visible pores, natural imperfections, unretouched photograph"""

workflow = json.loads(json.dumps(template))
workflow['id'] = "midnight-passenger-realistic"

for node in workflow['nodes']:
    if node['id'] == 16 and node['type'] == 'BasicScheduler':
        node['widgets_values'] = ["beta", 12, 1]
    if node['id'] == 4 and node['type'] == 'FluxGuidance':
        node['widgets_values'] = [1.6]  # Even lower for this scene
    if node['id'] == 14 and node['type'] == 'Power Lora Loader (rgthree)':
        node['widgets_values'][2]['strength'] = 0.70  # Even more photorealistic
    if node['id'] == 17 and node['type'] == 'CLIPTextEncode':
        node['widgets_values'] = [realistic_prompt]
    if node['id'] == 23 and node['type'] == 'EmptySD3LatentImage':
        node['widgets_values'] = [768, 1152, 1]
    if node['id'] == 5 and node['type'] == 'SaveImage':
        node['widgets_values'] = ["Brazilian_realistic_midnight_passenger"]

with open('workflows/midnight_passenger_realistic.json', 'w') as f:
    json.dump(workflow, f, indent=2)

print("✓ Created: workflows/midnight_passenger_realistic.json")
print("  Prompt: Enhanced with 'raw unedited photo', 'Fujifilm XT4', 'visible pores'")
print("  Guidance: 1.6 (very low)")
print("  LoRA strength: 0.70")
print()
print("🚀 To submit:")
print("   python submit-workflow.py workflows/midnight_passenger_realistic.json")
print()
print("📝 Key changes for realism:")
print("   1. Added camera metadata (Fujifilm XT4, ISO 1600)")
print("   2. 'raw unedited photo' and 'unretouched photograph'")
print("   3. 'visible pores' and 'natural imperfections'")
print("   4. Lower guidance prevents AI 'smoothing'")
print("   5. Lower LoRA strength reduces stylization")
