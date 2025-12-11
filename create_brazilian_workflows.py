#!/usr/bin/env python3
"""Generate 3 Brazilian portrait workflows with custom prompts."""

import json
import os

# Load the fixed workflow as template
with open('HyperFlux-Turbo-NSFW-Fast-FIXED.json', 'r') as f:
    template = json.load(f)

# Define the 3 prompts and their metadata
workflows = [
    {
        "name": "carnival_backstage",
        "title": "Post-Carnival Backstage",
        "prompt": "portrait of a gorgeous Brazilian dancer in a backstage dressing room, removing her costume; she is wearing a vibrant feathered headpiece and low-rise sequin bikini bottoms, but is completely topless; her bronze skin is covered in a fine sheen of sweat and stray glitter particles; she is looking at the camera with a tired but seductive smile, holding her heavy breasts with her hands to relieve the weight; warm vanity mirror lights reflecting in her dark eyes, colorful feathers in background, raw texture, 8k, masterpiece",
        "width": 768,
        "height": 1152,
        "guidance": 2.0
    },
    {
        "name": "ipanema_beach",
        "title": "Ipanema Beach Sunset",
        "prompt": "low angle full body shot of a thick Brazilian woman kneeling in the surf at sunset on Ipanema beach; she is wearing only white linen pants that are soaked and clinging to her hips, torso completely bare; water droplets running down her chest, nipples hard from the ocean breeze; she is arching her back, running wet sandy hands through her long dark curly hair; golden hour lighting hitting her side, deep blue ocean background, soft focus, cinematic film grain, highly detailed skin pores",
        "width": 768,
        "height": 1152,
        "guidance": 1.8
    },
    {
        "name": "sao_paulo_penthouse",
        "title": "São Paulo Penthouse Rain",
        "prompt": "medium shot of an exotic Brazilian model standing on a high-rise balcony at night, heavy rain falling against the glass behind her; she is leaning against the railing, wearing tight denim jeans unzipped at the top, topless; city neon lights (red and blue) reflecting off her wet skin; she is looking over her shoulder at the viewer with a sultry expression, hair plastered to her neck; moody atmosphere, cyberpunk color palette, sharp focus on eyes and chest, volumetric fog",
        "width": 768,
        "height": 1152,
        "guidance": 2.2
    }
]

# Create workflows directory
os.makedirs('workflows', exist_ok=True)

for config in workflows:
    workflow = json.loads(json.dumps(template))  # Deep copy
    
    # Update workflow metadata
    workflow['id'] = f"brazilian-{config['name']}"
    
    # Find and update specific nodes
    for node in workflow['nodes']:
        # Update CLIPTextEncode (node 17) with new prompt
        if node['id'] == 17 and node['type'] == 'CLIPTextEncode':
            node['widgets_values'] = [config['prompt']]
        
        # Update EmptySD3LatentImage (node 23) with new resolution
        if node['id'] == 23 and node['type'] == 'EmptySD3LatentImage':
            node['widgets_values'] = [config['width'], config['height'], 1]
        
        # Update FluxGuidance (node 4) with custom guidance
        if node['id'] == 4 and node['type'] == 'FluxGuidance':
            node['widgets_values'] = [config['guidance']]
        
        # Update SaveImage (node 5) filename prefix
        if node['id'] == 5 and node['type'] == 'SaveImage':
            node['widgets_values'] = [f"Brazilian_{config['name']}"]
    
    # Save workflow
    output_path = f"workflows/{config['name']}.json"
    with open(output_path, 'w') as f:
        json.dump(workflow, f, indent=2)
    
    print(f"✓ Created: {output_path}")
    print(f"  Title: {config['title']}")
    print(f"  Resolution: {config['width']}x{config['height']} (2:3 portrait)")
    print(f"  Guidance: {config['guidance']}")
    print()

print("\n✓ All 3 workflows created in 'workflows/' directory")
print("\nTo submit all workflows:")
print("  python submit-workflow.py workflows/carnival_backstage.json --wait")
print("  python submit-workflow.py workflows/ipanema_beach.json --wait")
print("  python submit-workflow.py workflows/sao_paulo_penthouse.json --wait")
print("\nOr submit all at once (no wait):")
print("  Get-ChildItem workflows/*.json | ForEach-Object { python submit-workflow.py $_.FullName }")
