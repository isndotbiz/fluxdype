#!/usr/bin/env python3
"""
Create template with dual LoRAs:
- Turbo LoRA at 0.8 strength
- Facebook/Meta LoRA at 0.8 strength (assuming filename with 'facebook' or 'meta')
"""

import json

# Load realistic template
with open('HyperFlux-Turbo-REALISTIC-FIXED.json', 'r') as f:
    template = json.load(f)

# Update LoRA configuration
for node in template['nodes']:
    if node['id'] == 14 and node['type'] == 'Power Lora Loader (rgthree)':
        # The Power Lora Loader can have multiple LoRAs
        # Update first LoRA (Turbo) to 0.8
        node['widgets_values'][2]['strength'] = 0.8
        
        # Add second LoRA slot (Facebook/Meta)
        # Assuming the LoRA filename contains 'facebook' or similar
        # You may need to adjust this based on actual filename
        node['widgets_values'].insert(3, {
            "on": True,
            "lora": "flux-RealismLora.safetensors",  # Common name, adjust if needed
            "strength": 0.8,
            "strengthTwo": None
        })
        
        node['properties']['_notes'] = "Dual LoRA: Turbo 0.8 + Realism 0.8"

# Save template
with open('HyperFlux-Turbo-DualLoRA-FIXED.json', 'w') as f:
    json.dump(template, f, indent=2)

print("✓ Created: HyperFlux-Turbo-DualLoRA-FIXED.json")
print()
print("Configuration:")
print("  - Turbo LoRA: FLUX.1-Turbo-Alpha.safetensors @ 0.8")
print("  - Realism LoRA: flux-RealismLora.safetensors @ 0.8")
print()
print("📝 Note: If the Facebook/Meta LoRA has a different filename,")
print("   edit the JSON file and change 'flux-RealismLora.safetensors'")
print("   to the correct filename.")
print()
print("Common LoRA names to try:")
print("  - flux-RealismLora.safetensors")
print("  - FLUX-dev-lora-add-details.safetensors") 
print("  - Any file with 'facebook', 'meta', or 'realism' in the name")
