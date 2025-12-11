import requests

job_id = "adf23b5f-0acc-4b92-a8f1-2ad3ddd1d580"
r = requests.get(f'http://localhost:8188/history/{job_id}')
data = r.json()[job_id]
img = data['outputs']['5']['images'][0]
url = f"http://localhost:8188/view?filename={img['filename']}&type={img['type']}"
img_data = requests.get(url)
open('outputs/midnight_passenger_REALISTIC.png', 'wb').write(img_data.content)
print(f"✓ Downloaded: outputs/midnight_passenger_REALISTIC.png ({len(img_data.content)/1024/1024:.2f} MB)")
