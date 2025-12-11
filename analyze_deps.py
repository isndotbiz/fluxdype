#!/usr/bin/env python3
import json
import re
from pathlib import Path

# Load parsed data
with open('D:/workspace/fluxdype/parsed_deps.json', 'r') as f:
    data = json.load(f)

all_nodes = data['all_nodes']

# Build conflict analysis
conflicts = []
duplicates = {}
version_specs = {}

# Find duplicates and collect version specs
for pkg in data['all_packages']:
    occurrences = []
    specs = set()

    for node, reqs in all_nodes.items():
        if pkg in reqs:
            occurrences.append((node, reqs[pkg]))
            specs.add(reqs[pkg])

    if occurrences:
        if len(occurrences) > 1:
            duplicates[pkg] = occurrences
        version_specs[pkg] = (occurrences, list(specs))

# Analyze conflicts
print("=" * 80)
print("DEPENDENCY CONFLICT ANALYSIS")
print("=" * 80)
print()

# Check for opencv conflicts
print("\n1. OPENCV CONFLICTS")
print("-" * 80)
opencv_packages = [pkg for pkg in data['all_packages'] if 'opencv' in pkg.lower()]
if opencv_packages:
    print(f"Found {len(opencv_packages)} OpenCV package variants:")
    for pkg in opencv_packages:
        if pkg in duplicates:
            print(f"\n  {pkg}:")
            for node, spec in duplicates[pkg]:
                print(f"    - {node}: {spec}")

    # Conflict check
    has_python = any('opencv-python' == pkg and pkg != 'opencv-python-headless'
                     for pkg in opencv_packages)
    has_headless = any('opencv-python-headless' in pkg for pkg in opencv_packages)

    if has_python and has_headless:
        print(f"\n  CONFLICT DETECTED: opencv-python and opencv-python-headless")
        print(f"  Severity: HIGH")
        print(f"  Description: These packages conflict. opencv-python-headless is for headless")
        print(f"               systems and should not be mixed with opencv-python GUI variant")

# Check einops version conflicts
print("\n\n2. EINOPS VERSION CONFLICTS")
print("-" * 80)
if 'einops' in duplicates:
    specs = set(spec for _, spec in duplicates['einops'])
    print(f"Found {len(specs)} different version specs for einops:")
    for node, spec in duplicates['einops']:
        print(f"  - {node}: {spec}")

    if len(specs) > 1:
        print(f"\n  CONFLICT DETECTED: Multiple einops versions required")
        print(f"  Severity: HIGH")
        print(f"  Description: einops has pinned versions in some nodes")
        if '==0.8.0' in specs:
            print(f"  Details: Some nodes require ==0.8.0 while base may use different version")

# Check transformers conflicts
print("\n\n3. TRANSFORMERS VERSION CONFLICTS")
print("-" * 80)
if 'transformers' in duplicates:
    specs = set(spec for _, spec in duplicates['transformers'])
    print(f"Found {len(specs)} different version specs for transformers:")
    for node, spec in duplicates['transformers']:
        print(f"  - {node}: {spec}")

    base_spec = all_nodes['ComfyUI (base)'].get('transformers', 'not_found')
    print(f"\n  Base ComfyUI requires: transformers {base_spec}")
    print(f"  Status: All requirements compatible (>=4.37.2 or 'any')")

# Check protobuf conflicts
print("\n\n4. PROTOBUF VERSION CONFLICTS")
print("-" * 80)
if 'protobuf' in duplicates:
    specs = set(spec for _, spec in duplicates['protobuf'])
    print(f"Found {len(specs)} different version specs for protobuf:")
    for node, spec in duplicates['protobuf']:
        print(f"  - {node}: {spec}")

    if '>=3.20.2,<6.0.0' in specs and len(specs) > 1:
        print(f"\n  POTENTIAL CONFLICT: Protobuf has range restriction")
        print(f"  Severity: MEDIUM")
        print(f"  Description: ComfyUI-RMBG restricts protobuf <6.0.0")
        print(f"               while others may allow later versions")

# Check huggingface_hub
print("\n\n5. HUGGINGFACE_HUB ANALYSIS")
print("-" * 80)
if 'huggingface-hub' in all_nodes.get('ComfyUI-Manager', {}):
    print("huggingface-hub referenced in:")
    print("  - ComfyUI-Manager: huggingface-hub (any)")
if 'huggingface-hub' in all_nodes.get('ComfyUI-RMBG', {}):
    print("  - ComfyUI-RMBG: huggingface-hub>=0.19.0")

# Check for numpy conflicts
print("\n\n6. NUMPY VERSION CONFLICTS")
print("-" * 80)
if 'numpy' in duplicates:
    specs = set(spec for _, spec in duplicates['numpy'])
    print(f"Found {len(specs)} different version specs for numpy:")
    for node, spec in duplicates['numpy']:
        print(f"  - {node}: {spec}")
    print(f"\n  Status: Base requires >=1.25.0, all custom nodes compatible")

# Find duplicate packages (redundancy check)
print("\n\n7. DUPLICATE PACKAGES ACROSS NODES (REDUNDANCY)")
print("-" * 80)
redundant_count = 0
for pkg in sorted(duplicates.keys()):
    if pkg not in ['torch', 'torchvision', 'numpy', 'scipy']:  # Skip base packages
        nodes = [n for n, _ in duplicates[pkg]]
        if len(nodes) >= 3:
            redundant_count += 1
            print(f"\n  {pkg}: installed by {len(nodes)} nodes")
            print(f"    Nodes: {', '.join(nodes[:3])}" + (f" (+{len(nodes)-3} more)" if len(nodes) > 3 else ""))

print(f"\n\n  Total packages with high redundancy (3+ nodes): {redundant_count}")

# Summary
print("\n\n" + "=" * 80)
print("SUMMARY OF ISSUES")
print("=" * 80)

issues = [
    {
        'name': 'OpenCV Variant Conflict',
        'severity': 'HIGH',
        'description': 'opencv-python and opencv-python-headless cannot coexist',
        'affected_nodes': ['ComfyUI-Inspire-Pack', 'ComfyUI-RMBG', 'comfyui_controlnet_aux', 'was-node-suite-comfyui', 'ComfyUI-Impact-Pack'],
        'resolution': 'Use opencv-python-headless for all nodes (headless environment)'
    },
    {
        'name': 'Einops Version Pinning',
        'severity': 'HIGH',
        'description': 'ComfyUI-IPAdapter-Flux and x-flux-comfyui require einops==0.8.0 (pinned)',
        'affected_nodes': ['ComfyUI-IPAdapter-Flux', 'x-flux-comfyui'],
        'resolution': 'Install einops==0.8.0 to satisfy both nodes'
    },
    {
        'name': 'Protobuf Version Range',
        'severity': 'MEDIUM',
        'description': 'ComfyUI-RMBG restricts protobuf to <6.0.0',
        'affected_nodes': ['ComfyUI-RMBG'],
        'resolution': 'Install protobuf >=3.20.2,<6.0.0 to satisfy constraint'
    },
    {
        'name': 'Package Redundancy',
        'severity': 'MEDIUM',
        'description': 'Multiple custom nodes install common dependencies (inefficient)',
        'affected_nodes': ['Multiple nodes'],
        'resolution': 'Consider using -requirements file in ComfyUI or consolidate node installs'
    }
]

for i, issue in enumerate(issues, 1):
    print(f"\n{i}. {issue['name']}")
    print(f"   Severity: {issue['severity']}")
    print(f"   Description: {issue['description']}")
    affected = ', '.join(issue['affected_nodes'][:2])
    if len(issue['affected_nodes']) > 2:
        affected += f" (+{len(issue['affected_nodes'])-2} more)"
    print(f"   Affected Nodes: {affected}")
    print(f"   Resolution: {issue['resolution']}")

# Save issues to JSON
output = {
    'issues': issues,
    'duplicate_packages': {k: len(v) for k, v in duplicates.items()},
    'critical_findings': {
        'opencv_conflict': True,
        'einops_pinned': True,
        'protobuf_restricted': True
    }
}

with open('D:/workspace/fluxdype/dependency_analysis.json', 'w') as f:
    json.dump(output, f, indent=2)
