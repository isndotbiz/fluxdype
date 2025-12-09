#!/usr/bin/env python3
"""
Create 10 Nighttime Beach Portfolio - Lighting Variation Theme
Using realistic settings: 12 steps, low guidance, photorealistic prompts
"""

import json
import os

# Load realistic template
with open('HyperFlux-Turbo-REALISTIC-FIXED.json', 'r') as f:
    template = json.load(f)

# Define all 10 beach scenarios with specific lighting
beach_portfolio = [
    {
        "name": "moonlight_dip",
        "title": "Moonlight Dip (Cold Blue Light)",
        "prompt": "waist-up shot of a curvy Brazilian woman wading into the ocean at midnight, illuminated only by a full moon; she is topless, wearing wet black bikini bottoms; moonlight reflects off the water and her wet skin, creating cool blue highlights on her chest and shoulders; hair slicked back, looking back at the shore; deep shadows, high contrast, bioluminescent plankton sparkling in the water around her waist, 8k, mysterious atmosphere, raw unedited photo, visible pores, natural skin texture",
        "width": 896,
        "height": 1152,
        "guidance": 1.7
    },
    {
        "name": "bonfire_glow",
        "title": "Bonfire Glow (Warm Orange Light)",
        "prompt": "low angle shot of a Brazilian woman sitting on a log next to a beach bonfire; the fire is out of frame but casting a flickering warm orange glow on her bronze skin; she is laughing, head thrown back, wearing denim cutoffs and nothing else; deep shadows on her back, bright highlights on her breasts and throat; sparks flying in the air, smoke haze, cinematic lighting, raw candid photo, Fujifilm XT4, authentic skin texture, visible pores",
        "width": 896,
        "height": 1152,
        "guidance": 1.8
    },
    {
        "name": "flashlight_find",
        "title": "Flashlight Find (Harsh Direct Light)",
        "prompt": "POV shot, harsh flashlight beam illuminating a startled Brazilian woman standing in the dunes at night; she is shielding her eyes with one hand, topless, wearing a white sarong tied at the waist; the light is bright and direct, casting sharp shadows behind her and highlighting the texture of the sand and her skin imperfections; dark background, thriller vibe, found footage style, authentic grain, flash photography, hard shadows, unretouched photograph",
        "width": 896,
        "height": 1152,
        "guidance": 1.6
    },
    {
        "name": "city_distant",
        "title": "City Distant (Bokeh Background)",
        "prompt": "medium shot of a sophisticated Brazilian model leaning against a pier railing at night; distant city lights of Rio blurring in the background (bokeh); she is wearing unbuttoned white linen pants, torso bare; ambient purple and yellow city glow rim-lighting her silhouette; she is looking sideways, wind blowing her dark curly hair across her face; moody, urban beach aesthetic, f/1.4 aperture, Sony A7III, natural skin texture",
        "width": 896,
        "height": 1152,
        "guidance": 1.7
    },
    {
        "name": "wet_sand_sprawl",
        "title": "Wet Sand Sprawl (Texture Focus)",
        "prompt": "high angle full body shot looking down at a Brazilian woman lying on her back in the wet sand where the tide meets the shore; it is pitch black night, lit by a soft camera flash; she is naked, covered in sand and sea foam; waves washing over her legs; water reflecting the flash; raw, gritty, Sports Illustrated Swimsuit behind-the-scenes style, messy hair, intense gaze, flash photography, hard shadows, visible sand texture, authentic skin pores",
        "width": 1152,
        "height": 896,
        "guidance": 1.8
    },
    {
        "name": "storm_chaser",
        "title": "Storm Chaser (Dramatic Weather)",
        "prompt": "cinematic shot of a fit Brazilian woman standing on a rocky outcrop at the beach during a night storm; lightning strikes in the distance illuminating the scene for a split second; she is topless, wearing soaked army green cargo shorts; rain is pouring, skin glistening; the lightning creates a stark white rim light on her profile; chaotic waves crashing behind her, power, energy, 8k resolution, raw weather photography, natural imperfections",
        "width": 896,
        "height": 1152,
        "guidance": 1.9
    },
    {
        "name": "car_headlights",
        "title": "Car Headlights (Silhouette & Beams)",
        "prompt": "wide shot of a Brazilian woman standing in front of a parked Jeep on the beach; the car headlights are on, illuminating her from behind (backlit); she is a silhouette with glowing edges, wearing a bikini bottom, topless; the light beams cut through the salty mist; you can see the curve of her waist and hips defined by the light; atmospheric, moody, cinematic composition, real photograph, natural lighting",
        "width": 1152,
        "height": 896,
        "guidance": 1.7
    },
    {
        "name": "night_swim_exit",
        "title": "Night Swim Exit (Water Physics)",
        "prompt": "front-facing shot of a Brazilian woman emerging from the dark ocean, water waist deep; ambient moonlight; she is squeezing water out of her long hair, elbows up, chest exposed; water droplets frozen in mid-air; skin is goosebumped from the cold; intense texture on the water surface; dark blue and black color palette, hyper-realistic, visible pores, authentic skin texture, unretouched photo",
        "width": 896,
        "height": 1152,
        "guidance": 1.7
    },
    {
        "name": "fireworks",
        "title": "Fireworks (Colorful Lighting)",
        "prompt": "close up portrait of a Brazilian woman on the beach looking up at the sky; fireworks exploding above (off camera) casting alternating red and green light on her face and bare chest; she is smiling in awe; reflection of fireworks visible in her dark eyes; soft focus background of a crowd; celebratory atmosphere, vibrant colors, detailed skin pores, real photograph, Canon 5D Mark IV",
        "width": 896,
        "height": 1152,
        "guidance": 1.8
    },
    {
        "name": "pre_dawn_grey",
        "title": "Pre-Dawn Grey (Morning Coming)",
        "prompt": "eye-level shot of a Brazilian woman sitting on a lifeguard tower ladder, looking out at the horizon; it is pre-dawn, the sky is a deep navy blue turning grey; she is wearing a towel loosely around her waist, topless; soft, flat lighting (low contrast); mist rising from the sand; tired but peaceful expression; melancholic vibe, film grain, analog photography style, Kodak Portra 400, authentic skin texture",
        "width": 896,
        "height": 1152,
        "guidance": 1.6
    }
]

# Create workflows directory
os.makedirs('workflows/beach_portfolio', exist_ok=True)

print("🌊 Creating Nighttime Beach Portfolio (10 scenarios)\n")
print("Settings: 12 steps, 896x1152 (portrait), realistic mode\n")

for idx, scene in enumerate(beach_portfolio, 1):
    workflow = json.loads(json.dumps(template))  # Deep copy
    
    workflow['id'] = f"beach-portfolio-{scene['name']}"
    
    # Update nodes
    for node in workflow['nodes']:
        # Update prompt
        if node['id'] == 17 and node['type'] == 'CLIPTextEncode':
            node['widgets_values'] = [scene['prompt']]
        
        # Update resolution
        if node['id'] == 23 and node['type'] == 'EmptySD3LatentImage':
            node['widgets_values'] = [scene['width'], scene['height'], 1]
        
        # Update guidance (already lowered, but fine-tune per scene)
        if node['id'] == 4 and node['type'] == 'FluxGuidance':
            node['widgets_values'] = [scene['guidance']]
        
        # Update filename
        if node['id'] == 5 and node['type'] == 'SaveImage':
            node['widgets_values'] = [f"Beach_{idx:02d}_{scene['name']}"]
    
    # Save workflow
    output_path = f"workflows/beach_portfolio/{idx:02d}_{scene['name']}.json"
    with open(output_path, 'w') as f:
        json.dump(workflow, f, indent=2)
    
    print(f"{idx:2d}. ✓ {scene['title']}")
    print(f"     File: {output_path}")
    print(f"     Resolution: {scene['width']}x{scene['height']}, Guidance: {scene['guidance']}")
    print()

print("\n✅ All 10 beach portfolio workflows created!")
print("\n🚀 To submit all at once:")
print("   Get-ChildItem workflows/beach_portfolio/*.json | Sort-Object Name | ForEach-Object { python submit-workflow.py $_.FullName; Start-Sleep -Seconds 1 }")
print("\n⏱️  Total generation time: ~2-3 minutes for all 10 images")
print("\n📥 To download after completion:")
print("   python download_outputs.py")
