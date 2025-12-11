#!/usr/bin/env python3
"""
Production Background Removal API
ComfyUI-RMBG Integration Helper

Mission-critical for UI/UX workflows
Provides simple Python interface to production_bg_removal.json workflow
"""

import json
import time
import requests
import uuid
from pathlib import Path
from typing import Optional, Dict, Any, Tuple
import logging

logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)


class BackgroundRemovalAPI:
    """Production-grade API for background removal using ComfyUI-RMBG"""

    def __init__(
        self,
        comfy_host: str = "localhost",
        comfy_port: int = 8188,
        workflow_path: str = "workflows/production_bg_removal.json",
        timeout: int = 300
    ):
        """
        Initialize the API client

        Args:
            comfy_host: ComfyUI server hostname (default: localhost)
            comfy_port: ComfyUI server port (default: 8188)
            workflow_path: Path to production_bg_removal.json
            timeout: Request timeout in seconds (default: 300)
        """
        self.base_url = f"http://{comfy_host}:{comfy_port}"
        self.timeout = timeout
        self.workflow = self._load_workflow(workflow_path)

    def _load_workflow(self, path: str) -> Dict[str, Any]:
        """Load workflow template from JSON file"""
        with open(path, "r") as f:
            return json.load(f)

    def process_image(
        self,
        image_filename: str,
        output_prefix: str = "bg_removal_output",
        poll_interval: float = 1.0,
        max_retries: int = 3
    ) -> Tuple[bool, str]:
        """
        Process image through background removal workflow

        Args:
            image_filename: Filename in ComfyUI input folder
            output_prefix: Custom output prefix (optional)
            poll_interval: Seconds between status checks
            max_retries: Retry attempts on network error

        Returns:
            Tuple of (success, message/job_id)
        """
        workflow = json.loads(json.dumps(self.workflow))  # Deep copy

        # Configure image input (Node 1 - LoadImage)
        workflow["nodes"][0]["widgets_values"][0] = image_filename

        # Configure output filename (Node 5 - SaveImage)
        workflow["nodes"][4]["widgets_values"][0] = output_prefix

        logger.info(f"Processing image: {image_filename}")
        logger.info(f"Output prefix: {output_prefix}")

        # Submit workflow
        retry_count = 0
        job_id = None

        while retry_count < max_retries:
            try:
                response = requests.post(
                    f"{self.base_url}/prompt",
                    json=workflow,
                    timeout=self.timeout
                )
                response.raise_for_status()
                job_id = response.json().get("prompt_id")
                logger.info(f"Job submitted: {job_id}")
                break

            except requests.RequestException as e:
                retry_count += 1
                if retry_count >= max_retries:
                    error_msg = f"Failed to submit job after {max_retries} retries: {e}"
                    logger.error(error_msg)
                    return False, error_msg
                logger.warning(f"Retry {retry_count}/{max_retries}: {e}")
                time.sleep(2)

        if not job_id:
            return False, "No job_id returned from server"

        # Wait for completion
        start_time = time.time()
        while True:
            elapsed = time.time() - start_time
            if elapsed > self.timeout:
                error_msg = f"Processing timeout after {self.timeout}s"
                logger.error(error_msg)
                return False, error_msg

            try:
                response = requests.get(
                    f"{self.base_url}/history/{job_id}",
                    timeout=self.timeout
                )
                response.raise_for_status()
                history = response.json()

                if job_id in history:
                    # Job complete
                    logger.info(f"Job completed in {elapsed:.1f}s")
                    logger.info(f"Output: {output_prefix}_*.png")
                    return True, job_id

            except requests.RequestException as e:
                logger.warning(f"Status check error: {e}")

            time.sleep(poll_interval)

    def process_batch(
        self,
        image_files: list,
        output_prefix: str = "bg_removal_output",
        delay_between: float = 1.0
    ) -> Dict[str, Any]:
        """
        Process multiple images sequentially

        Args:
            image_files: List of filenames
            output_prefix: Custom output prefix
            delay_between: Seconds to wait between submissions

        Returns:
            Results dict with successes and failures
        """
        results = {
            "total": len(image_files),
            "succeeded": 0,
            "failed": 0,
            "details": []
        }

        for idx, filename in enumerate(image_files, 1):
            logger.info(f"[{idx}/{len(image_files)}] Processing: {filename}")

            # Generate unique prefix for each image
            base_prefix = output_prefix or "bg_removal"
            unique_prefix = f"{base_prefix}_{Path(filename).stem}"

            success, result = self.process_image(
                filename,
                output_prefix=unique_prefix
            )

            if success:
                results["succeeded"] += 1
                results["details"].append({
                    "filename": filename,
                    "status": "success",
                    "job_id": result
                })
            else:
                results["failed"] += 1
                results["details"].append({
                    "filename": filename,
                    "status": "failed",
                    "error": result
                })

            if idx < len(image_files):
                time.sleep(delay_between)

        return results

    def get_system_stats(self) -> Dict[str, Any]:
        """Get ComfyUI system statistics"""
        try:
            response = requests.get(
                f"{self.base_url}/system_stats",
                timeout=self.timeout
            )
            response.raise_for_status()
            return response.json()
        except requests.RequestException as e:
            logger.error(f"Failed to get system stats: {e}")
            return {}

    def health_check(self) -> bool:
        """Check if ComfyUI server is running"""
        try:
            response = requests.get(
                f"{self.base_url}/system_stats",
                timeout=5
            )
            return response.status_code == 200
        except requests.RequestException:
            return False


def main():
    """Example usage"""
    import sys

    # Initialize API
    api = BackgroundRemovalAPI(
        comfy_host="localhost",
        comfy_port=8188,
        workflow_path="workflows/production_bg_removal.json"
    )

    # Check health
    if not api.health_check():
        print("ERROR: ComfyUI server not running")
        print("Start server with: .\\start-comfy.ps1")
        sys.exit(1)

    # Single image example
    if len(sys.argv) > 1:
        image_file = sys.argv[1]
        success, result = api.process_image(image_file)
        if success:
            print(f"SUCCESS: {result}")
        else:
            print(f"FAILED: {result}")
    else:
        # Batch example
        print("Background Removal API - Batch Processing Example")
        print("-" * 60)

        # Example: process all JPG files in a folder
        images = [
            "sample1.jpg",
            "sample2.jpg",
            "sample3.jpg"
        ]

        results = api.process_batch(images, output_prefix="batch_output")
        print(f"\nBatch Results:")
        print(f"  Total:    {results['total']}")
        print(f"  Success:  {results['succeeded']}")
        print(f"  Failed:   {results['failed']}")

        for detail in results["details"]:
            status = "✓" if detail["status"] == "success" else "✗"
            print(f"  {status} {detail['filename']}")


if __name__ == "__main__":
    main()
