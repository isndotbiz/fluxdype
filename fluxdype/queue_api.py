import json
import requests
import random

# ComfyUI API-format workflow
workflow_api = {
    "1": {
        "inputs": {
            "sampler_name": "euler"
        },
        "class_type": "KSamplerSelect"
    },
    "2": {
        "inputs": {
            "noise_seed": random.randint(0, 999999999),
            "control_after_generate": "randomize"
        },
        "class_type": "RandomNoise"
    },
    "3": {
        "inputs": {
            "model": ["14", 0],
            "conditioning": ["8", 0]
        },
        "class_type": "BasicGuider"
    },
    "4": {
        "inputs": {
            "conditioning": ["17", 0],
            "guidance": 1.8
        },
        "class_type": "FluxGuidance"
    },
    "5": {
        "inputs": {
            "images": ["6", 0],
            "filename_prefix": "HyperFlux_ExoticBrazilian"
        },
        "class_type": "SaveImage"
    },
    "6": {
        "inputs": {
            "samples": ["7", 0],
            "vae": ["9", 0]
        },
        "class_type": "VAEDecode"
    },
    "7": {
        "inputs": {
            "noise": ["2", 0],
            "guider": ["3", 0],
            "sampler": ["1", 0],
            "sigmas": ["16", 0],
            "latent_image": ["23", 0]
        },
        "class_type": "SamplerCustomAdvanced"
    },
    "8": {
        "inputs": {
            "conditioning": ["4", 0]
        },
        "class_type": "ReferenceLatent"
    },
    "9": {
        "inputs": {
            "vae_name": "ae.safetensors"
        },
        "class_type": "VAELoader"
    },
    "10": {
        "inputs": {
            "clip_name1": "t5xxl_fp16.safetensors",
            "clip_name2": "clip_l.safetensors",
            "type": "flux",
            "device": "default"
        },
        "class_type": "DualCLIPLoader"
    },
    "11": {
        "inputs": {
            "unet_name": "hyperfluxDiversity_q80.gguf"
        },
        "class_type": "UnetLoaderGGUF"
    },
    "14": {
        "inputs": {
            "model": ["11", 0],
            "clip": ["10", 0],
            "lora_01": {
                "on": True,
                "lora": "FLUX.1-Turbo-Alpha.safetensors",
                "strength": 0.75
            }
        },
        "class_type": "Power Lora Loader (rgthree)"
    },
    "16": {
        "inputs": {
            "model": ["14", 0],
            "scheduler": "beta",
            "steps": 12,
            "denoise": 1.0
        },
        "class_type": "BasicScheduler"
    },
    "17": {
        "inputs": {
            "clip": ["14", 1],
            "text": "exotic brazilian woman, detailed face, 8k, photorealistic, professional, perfect composition, sharp focus, beautiful skin, natural lighting, attractive"
        },
        "class_type": "CLIPTextEncode"
    },
    "23": {
        "inputs": {
            "width": 1024,
            "height": 1024,
            "batch_size": 1
        },
        "class_type": "EmptySD3LatentImage"
    }
}

# Send request
url = "http://localhost:8188/prompt"
data = {
    "prompt": workflow_api
}

response = requests.post(url, json=data)
result = response.json()

if response.status_code == 200:
    print(f"✓ Successfully queued!")
    print(f"  Prompt ID: {result.get('prompt_id', 'N/A')}")
    print(f"  Queue position: {result.get('number', 'N/A')}")
else:
    print(f"✗ Error: {result}")
