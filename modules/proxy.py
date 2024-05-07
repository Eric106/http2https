# from pprint import pprint
from flask import Flask, Response, request
import requests
from json import load

def json2dict(path_json: str) -> dict:
    json_file = open(path_json,'r')
    data : dict = load(json_file)
    json_file.close()
    return data

app = Flask(__name__)
bind_config = json2dict('bind.json')

@app.route('/', defaults={'path': ''}, methods=["GET", "POST"])  # ref. https://medium.com/@zwork101/making-a-flask-proxy-server-online-in-10-lines-of-code-44b8721bca6
@app.route('/<path:path>', methods=["GET", "POST"])  # NOTE: better to specify which methods to be accepted. Otherwise, only GET will be accepted. Ref: https://flask.palletsprojects.com/en/3.0.x/quickstart/#http-methods
def proxy(path):  #NOTE var :path will be unused as all path we need will be read from :request ie from flask import request
    url = f"http://{bind_config['ip']}:{bind_config['http_port']}/"
    res = requests.request(  # ref. https://stackoverflow.com/a/36601467/248616
        method          = request.method,
        url             = request.url.replace(request.host_url, url),
        headers         = {k:v for k,v in request.headers if k.lower() != 'host'}, # exclude 'host' header
        data            = request.get_data(),
        cookies         = request.cookies,
        allow_redirects = False,
    )

    #region exlcude some keys in :res response
    excluded_headers = ['content-encoding', 'content-length', 'transfer-encoding','hop-by-hop', 'connection']  #NOTE we here exclude all "hop-by-hop headers" defined by RFC 2616 section 13.5.1 ref. https://www.rfc-editor.org/rfc/rfc2616#section-13.5.1
    headers          = [
        (k,v) for k,v in res.raw.headers.items()
        if k.lower() not in excluded_headers
    ]
    #endregion exlcude some keys in :res response

    response = Response(res.content, res.status_code, headers)
    return response