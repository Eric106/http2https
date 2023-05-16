from gevent.pywsgi import WSGIServer
from modules.proxy import app

if __name__ == '__main__':
    http_server = WSGIServer(('localhost', 8000), app)
    http_server.serve_forever()
