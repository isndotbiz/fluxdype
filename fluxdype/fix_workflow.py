#!/usr/bin/env python3
"""Fix workflow to remove image loading dependency."""

import json

# Load workflow
with open('HyperFlux-Turbo-NSFW-Fast.json', 'r') as f:
    workflow = json.load(f)

# Remove nodes 13 (LoadImage), 12 (VAEEncode), 19 (GetImageSizeRatio)
# Keep node 23 (EmptySD3LatentImage) but make it independent
# Remove node 8 (ReferenceLatent) and connect node 17's output directly to node 3

nodes_to_remove = {12, 13, 19}  # Remove image-related nodes
node_8_to_rewire = True  # Change node 8 behavior

# Filter out removed nodes
workflow['nodes'] = [n for n in workflow['nodes'] if n['id'] not in nodes_to_remove]

# Fix node 8 (ReferenceLatent) - remove the latent input requirement
for node in workflow['nodes']:
    if node['id'] == 8:
        # Remove the latent input, keep only conditioning
        node['inputs'] = [inp for inp in node['inputs'] if inp['name'] != 'latent']
    
    # Fix node 23 (EmptySD3LatentImage) - make width/height fixed instead of linked
    if node['id'] == 23:
        for inp in node['inputs']:
            inp['link'] = None
        # Use fixed 1024x1024 resolution
        node['widgets_values'] = [1024, 1024, 1]

# Remove links related to removed nodes
links_to_keep = []
for link in workflow['links']:
    # link format: [link_id, source_node, source_slot, target_node, target_slot, type]
    source_node = link[1]
    target_node = link[3]
    link_id = link[0]
    
    # Keep links that don't involve removed nodes or problematic connections
    if source_node not in nodes_to_remove and target_node not in nodes_to_remove:
        # Remove links 27 (to node 8's latent input), 37, 38 (to node 23's width/height)
        if link_id not in [27, 37, 38]:
            links_to_keep.append(link)

workflow['links'] = links_to_keep

# Save fixed workflow
with open('HyperFlux-Turbo-NSFW-Fast-FIXED.json', 'w') as f:
    json.dump(workflow, f, indent=2)

print("✓ Created fixed workflow: HyperFlux-Turbo-NSFW-Fast-FIXED.json")
print("  - Removed image loading nodes (13, 12, 19)")
print("  - Fixed ReferenceLatent node to work without image input")
print("  - Set EmptySD3LatentImage to use fixed 1024x1024 resolution")
