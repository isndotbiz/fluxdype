#!/usr/bin/env python3
"""
Submit a ComfyUI workflow to the API server.
Converts from ComfyUI's export format to the API format.
"""

import json
import sys
import time
import requests
from pathlib import Path


def convert_workflow_to_api_format(workflow_data):
    """Convert workflow from ComfyUI export format to API format."""
    nodes_dict = {}
    
    # Create a mapping of link IDs to their connection info
    link_map = {}
    if 'links' in workflow_data:
        for link in workflow_data['links']:
            # link format: [link_id, source_node_id, source_slot, target_node_id, target_slot, type]
            link_id = link[0]
            link_map[link_id] = {
                'source_node': link[1],
                'source_slot': link[2],
            }
    
    # Convert nodes array to dictionary
    for node in workflow_data['nodes']:
        node_id = str(node['id'])
        
        # Create node entry
        nodes_dict[node_id] = {
            'class_type': node['type'],
            'inputs': {}
        }
        
        # Map widget values to input names
        widget_values = node.get('widgets_values', [])
        widget_index = 0
        
        # Process inputs
        if 'inputs' in node:
            for inp in node['inputs']:
                input_name = inp['name']
                
                if inp.get('link') is not None:
                    # This input is connected to another node's output
                    link_id = inp['link']
                    if link_id in link_map:
                        link_info = link_map[link_id]
                        nodes_dict[node_id]['inputs'][input_name] = [
                            str(link_info['source_node']),
                            link_info['source_slot']
                        ]
                elif widget_index < len(widget_values):
                    # Use widget value for this input
                    nodes_dict[node_id]['inputs'][input_name] = widget_values[widget_index]
                    widget_index += 1
    
    return nodes_dict


def submit_workflow(workflow_path, host='localhost', port=8188, wait=False):
    """Submit workflow to ComfyUI API."""
    # Read workflow file
    with open(workflow_path, 'r', encoding='utf-8') as f:
        workflow_data = json.load(f)
    
    # Convert to API format
    api_workflow = convert_workflow_to_api_format(workflow_data)
    
    # Prepare payload
    payload = {
        'prompt': api_workflow
    }
    
    # Submit to API
    url = f'http://{host}:{port}/prompt'
    print(f'Submitting workflow to {url}...')
    
    try:
        response = requests.post(url, json=payload)
        response.raise_for_status()
        
        result = response.json()
        job_id = result.get('prompt_id')
        
        print(f'✓ Workflow submitted successfully')
        print(f'Job ID: {job_id}')
        
        if wait and job_id:
            print('Waiting for job to complete...')
            max_wait = 3600  # 1 hour timeout
            elapsed = 0
            check_interval = 2
            
            while elapsed < max_wait:
                time.sleep(check_interval)
                elapsed += check_interval
                
                history_url = f'http://{host}:{port}/history/{job_id}'
                try:
                    history_response = requests.get(history_url)
                    if history_response.status_code == 200:
                        history = history_response.json()
                        if job_id in history:
                            print('\n✓ Job completed!')
                            print(f'Output: {json.dumps(history[job_id], indent=2)}')
                            return 0
                except:
                    pass
                
                print('.', end='', flush=True)
            
            print(f'\nWarning: Job did not complete within {max_wait} seconds')
        
        return 0
        
    except requests.exceptions.RequestException as e:
        print(f'Error: Failed to submit workflow: {e}')
        if hasattr(e, 'response') and e.response is not None:
            try:
                error_detail = e.response.json()
                print(f'Error details: {json.dumps(error_detail, indent=2)}')
            except:
                print(f'Error response: {e.response.text}')
        return 1


if __name__ == '__main__':
    import argparse
    
    parser = argparse.ArgumentParser(description='Submit ComfyUI workflow')
    parser.add_argument('workflow_path', help='Path to workflow JSON file')
    parser.add_argument('--host', default='localhost', help='ComfyUI host (default: localhost)')
    parser.add_argument('--port', type=int, default=8188, help='ComfyUI port (default: 8188)')
    parser.add_argument('--wait', action='store_true', help='Wait for job to complete')
    
    args = parser.parse_args()
    
    sys.exit(submit_workflow(args.workflow_path, args.host, args.port, args.wait))
