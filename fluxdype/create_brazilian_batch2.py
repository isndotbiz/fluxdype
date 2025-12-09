#!/usr/bin/env python3
"""Generate 3 more Brazilian workflows - focused on liquid textures & dramatic lighting."""

import json
import os

# Load the fixed workflow as template
with open('HyperFlux-Turbo-NSFW-Fast-FIXED.json', 'r') as f:
    template = json.load(f)

# Define the 3 new prompts - doubling down on wet/dramatic vibes
workflows = [
    {
        "name": "amazon_storm",
        "title": "Amazon Storm (Heavy Rain & Jungle)",
        "prompt": "cinematic medium shot of a fierce Brazilian woman standing in a dense tropical jungle during a heavy rainstorm; she is wearing unbuttoned military green cargo pants that hang low on her hips, completely topless; heavy rain is plastering her long dark hair to her face and neck; water streams down her cleavage, soaking her skin, nipples erect and piercing from the cold rain; she is looking up at the canopy, eyes closed, mouth slightly open catching the rain; lush green background, dramatic overcast lighting, 8k, raw photo, hyper-realistic water physics",
        "negative": "dry skin, sunny, cartoon, bright colors, shirt, bra, bad anatomy, blurry",
        "width": 768,
        "height": 1152,
        "guidance": 2.0
    },
    {
        "name": "midnight_passenger",
        "title": "Midnight Passenger (Car Interior & Streetlights)",
        "prompt": "POV shot from the driver's seat looking at a stunning Brazilian passenger in a luxury sports car at night; she is leaning back in the black leather seat, wearing a white skirt but topless; passing orange streetlights streak across her bronze skin, creating dynamic highlights on her breasts and stomach; she is looking out the window with a bored, sultry expression, one hand resting on her bare thigh; bokeh city lights through the window, motion blur in background, sharp focus on torso, high contrast, film noir aesthetic",
        "negative": "steering wheel blocking view, clothes on top, daylight, flat lighting, 3d render, bad eyes",
        "width": 768,
        "height": 1152,
        "guidance": 2.1
    },
    {
        "name": "rio_rooftop",
        "title": "Rio Rooftop (Golden Hour & Sweat)",
        "prompt": "eye-level close shot of a sweaty Brazilian woman leaning against a raw concrete railing on a rooftop in Rio de Janeiro at sunset; she is wearing tight denim shorts, unzipped, and nothing else; her skin is oiled and glowing in the deep orange sunlight; beads of sweat rolling down her chest and between her breasts; golden backlight flaring through her frizzy dark hair; favela hillside visible in the blurred background; authentic look, imperfections, moles, skin pores, warm color palette, 35mm Kodak Portra style",
        "negative": "makeup, airbrushed, studio lighting, cold colors, winter, clothes, bad abs, plastic skin",
        "width": 768,
        "height": 1152,
        "guidance": 1.9
    }
]

# Create workflows directory if it doesn't exist
os.makedirs('workflows', exist_ok=True)

print("🔥 Creating Batch 2: Wet textures & dramatic lighting workflows\n")

for config in workflows:
    workflow = json.loads(json.dumps(template))  # Deep copy
    
    # Update workflow metadata
    workflow['id'] = f"brazilian-batch2-{config['name']}"
    
    # Find and update specific nodes
    for node in workflow['nodes']:
        # Update CLIPTextEncode (node 17) with new prompt
        if node['id'] == 17 and node['type'] == 'CLIPTextEncode':
            node['widgets_values'] = [config['prompt']]
        
        # Update EmptySD3LatentImage (node 23) with resolution
        if node['id'] == 23 and node['type'] == 'EmptySD3LatentImage':
            node['widgets_values'] = [config['width'], config['height'], 1]
        
        # Update FluxGuidance (node 4) with custom guidance
        if node['id'] == 4 and node['type'] == 'FluxGuidance':
            node['widgets_values'] = [config['guidance']]
        
        # Update SaveImage (node 5) filename prefix
        if node['id'] == 5 and node['type'] == 'SaveImage':
            node['widgets_values'] = [f"Brazilian_batch2_{config['name']}"]
    
    # Save workflow
    output_path = f"workflows/{config['name']}.json"
    with open(output_path, 'w') as f:
        json.dump(workflow, f, indent=2)
    
    print(f"✓ Created: {output_path}")
    print(f"  Title: {config['title']}")
    print(f"  Resolution: {config['width']}x{config['height']} (2:3 portrait)")
    print(f"  Guidance: {config['guidance']}")
    print(f"  Focus: {config['prompt'][:80]}...")
    print()

print("\n✅ All 3 workflows created in 'workflows/' directory")
print("\n🚀 To submit all at once:")
print("   python -c \"import subprocess, time; [subprocess.run(['python', 'submit-workflow.py', f'workflows/{w}.json']) or time.sleep(1) for w in ['amazon_storm', 'midnight_passenger', 'rio_rooftop']]\"")
print("\n⚡ Then download:")
print("   python download_outputs.py")
