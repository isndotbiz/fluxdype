#!/usr/bin/env python3
"""
Create 9 POV/Intimate workflows with Instagram realism LoRA at 0.8
Phone camera aesthetic, vertical format
"""

import json
import os

# Load the base template
with open('HyperFlux-Turbo-REALISTIC-FIXED.json', 'r') as f:
    template = json.load(f)

# Update template for Instagram LoRA aesthetic
for node in template['nodes']:
    # Set Turbo LoRA to 0.8
    if node['id'] == 14 and node['type'] == 'Power Lora Loader (rgthree)':
        node['widgets_values'][2]['strength'] = 0.8
        # Second LoRA slot for Instagram/Realism LoRA
        if len(node['widgets_values']) > 3:
            node['widgets_values'][3]['strength'] = 0.8
        node['properties']['_notes'] = "Turbo LoRA 0.8 + Instagram Realism LoRA 0.8"
    
    # Reduce steps to 8 for speed
    if node['id'] == 16 and node['type'] == 'BasicScheduler':
        node['widgets_values'] = ["beta", 8, 1]
    
    # Lower guidance for raw aesthetic
    if node['id'] == 4 and node['type'] == 'FluxGuidance':
        node['widgets_values'] = [2.0]

# Save updated template
with open('HyperFlux-POV-Instagram-FIXED.json', 'w') as f:
    json.dump(template, f, indent=2)

# Define 9 POV scenarios
pov_scenarios = [
    {
        "name": "morning_missionary",
        "title": "Good Morning Missionary POV",
        "prompt": "POV shot looking down at a stunning Brazilian woman lying on white hotel sheets; her legs are wrapped around the viewer's waist; she is moaning, head thrown back, hands gripping the sheets; intimate view of a thick veiny penis penetrating her wet pussy; her breasts are bouncing from the motion; morning sunlight hitting her sweat-slicked skin; phone camera quality, flash off, natural lighting, messy hair, raw unedited photo, vascular skin texture",
    },
    {
        "name": "backstage_doggy",
        "title": "Backstage Doggy Mirror POV",
        "prompt": "full body shot of a woman bent over a dressing room vanity table, looking back at the camera with a lustful expression; she is wearing only high heels; reflection in the mirror shows the viewer's hips and a large cock driving into her from behind; her ass cheeks are red from slapping; clutter of makeup on the table; harsh fluorescent lighting, raw aesthetic, candid snap, phone camera, veiny skin texture",
    },
    {
        "name": "cowgirl_ride",
        "title": "Cowgirl Ride Top Down POV",
        "prompt": "high angle shot of a gorgeous girl riding the viewer, straddling the camera; she is sitting upright, back arched, hands resting on the viewer's chest (out of frame); looking down with heavy bedroom eyes; visible insertion point where the cock disappears inside her; her tits are swaying; background is a dark bedroom with LED strips; flash photography, shiny skin, instagram story style, vascular details",
    },
    {
        "name": "standing_wall",
        "title": "Standing Wall Pin POV",
        "prompt": "POV shot of a woman pinned against a shower glass door; one of her legs is hooked over the viewer's arm; close up of a penis sliding between her thighs and entering her; water running down her body; she is biting her lip, eyes rolled back; steam fogging the edges of the frame; hard texture, wet skin, authentic phone photo, veiny skin texture",
    },
    {
        "name": "lazy_sunday",
        "title": "Lazy Sunday Prone Bone POV",
        "prompt": "POV shot from behind of a woman lying flat on her stomach on a bed, face buried in the pillow; her ass is arched up; view of a cock balls-deep in her ass; her hands are gripping the headboard; soft afternoon light filtering through blinds creating stripes on her back; dust motes, cozy but dirty vibe, high fidelity texture, vascular skin details",
    },
    {
        "name": "titjob_tease",
        "title": "Titjob Tease POV",
        "prompt": "looking down POV at a busty Brazilian woman kneeling on the floor looking up; she is using her spit-covered tits to sandwich the viewer's erect cock; the glans is visible poking out the top between her cleavage; she has a cheeky smile, making eye contact; messy room background; harsh camera flash, overexposed skin highlights, amateur aesthetic, veiny texture",
    },
    {
        "name": "edge_of_bed",
        "title": "Edge of Bed Spread POV",
        "prompt": "full body shot of a woman lying on the edge of a mattress, legs spread wide open hanging off the side; POV of the viewer standing between her legs; a thick cock is visible in the foreground about to enter her dripping wet cunt; she is reaching out with both hands to grab it; messy bedroom, clothes scattered on floor; grainy low-light photo, vascular skin",
    },
    {
        "name": "kitchen_counter",
        "title": "Kitchen Counter Lift POV",
        "prompt": "POV shot of holding a petite woman up on a marble kitchen counter; her legs are wrapped tight around the viewer's neck; view of a penis burying itself deep inside her; she is arching back, knocking over a wine glass; kitchen lights in background; dynamic motion blur, raw energy, candid, phone camera, veiny skin texture",
    },
    {
        "name": "facial_aftermath",
        "title": "Facial Aftermath POV",
        "prompt": "close high angle shot of a woman lying on a black leather sofa, looking up at the camera, exhausted and panting; her face and chest are covered in fresh thick cum; a limp penis is visible in the bottom foreground of the frame (POV); she is wiping her mouth with the back of her hand; smudged makeup, messy hair, club lighting in background, flash on, hyper-realism, vascular details",
    }
]

# Create workflows directory
os.makedirs('workflows/pov_portfolio', exist_ok=True)

print("🔥 Creating POV/Intimate Portfolio (9 scenarios)")
print("Settings: 8 steps, 896x1152 (phone vertical), Instagram LoRA 0.8\n")

for idx, scene in enumerate(pov_scenarios, 1):
    workflow = json.loads(json.dumps(template))
    workflow['id'] = f"pov-{scene['name']}"
    
    for node in workflow['nodes']:
        if node['id'] == 17 and node['type'] == 'CLIPTextEncode':
            node['widgets_values'] = [scene['prompt']]
        
        if node['id'] == 23 and node['type'] == 'EmptySD3LatentImage':
            node['widgets_values'] = [896, 1152, 1]  # Phone vertical
        
        if node['id'] == 5 and node['type'] == 'SaveImage':
            node['widgets_values'] = [f"POV_{idx:02d}_{scene['name']}"]
    
    output_path = f"workflows/pov_portfolio/{idx:02d}_{scene['name']}.json"
    with open(output_path, 'w') as f:
        json.dump(workflow, f, indent=2)
    
    print(f"{idx:2d}. ✓ {scene['title']}")
    print(f"     {output_path}")

print("\n✅ All 9 POV workflows created!")
print("\n⚙️  Configuration:")
print("   - Turbo LoRA: 0.8 strength")
print("   - Instagram/Realism LoRA: 0.8 strength") 
print("   - Steps: 8 (ultra fast)")
print("   - Resolution: 896x1152 (phone vertical)")
print("   - Guidance: 2.0 (raw, unfiltered)")
print("\n🚀 To submit all:")
print("   Get-ChildItem workflows/pov_portfolio/*.json | Sort-Object Name | ForEach-Object { python submit-workflow.py $_.FullName; Start-Sleep -Seconds 1 }")
