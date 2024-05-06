# from pprint import pprint
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
    url = f'http://{http_ip}:{http_port}/{path}'
    # print('='*50)
    # pprint(request.headers)
    try:
        response = requests.request(
            method=request.method,
            url=url,
            headers={key: value for (key, value) in request.headers},
            data=request.get_data(),
            cookies=request.cookies,
            allow_redirects=False  # Prevent the target service from redirecting
        )
    except Exception:
        return "503 Iternal Server Error", 503

    # print('-'*50)
    # pprint(response.headers)
    # print('='*50)
    return response.content, response.status_code, dict(response.headers)