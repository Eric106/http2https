from flask import Flask, request
import requests
from json import load

def json2dict(path_json: str) -> dict:
    json_file = open(path_json,'r')
    data : dict = load(json_file)
    json_file.close()
    return data

app = Flask(__name__)
bind_config = json2dict('bind.json')

@app.route('/', defaults={'path': ''})
@app.route('/<path:path>')
def proxy(path):
    http_ip = bind_config['ip']
    http_port = bind_config['http_port']
    url = f'http://{http_ip}:{http_port}{request.full_path}'
    headers = dict(request.headers)
    headers['Host'] = f'{http_ip}:{http_port}'

    response = requests.request(
        method=request.method,
        url=url,
        headers=headers,
        data=request.get_data(),
        cookies=request.cookies,
        allow_redirects=False
    )

    excluded_headers = ['content-encoding', 'content-length', 'transfer-encoding', 'connection']
    headers = [(name, value) for (name, value) in response.raw.headers.items() if name.lower() not in excluded_headers]

    return response.content, response.status_code, headers
