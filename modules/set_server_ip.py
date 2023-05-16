import socket
from json import load

def json2dict(path_json: str) -> dict:
    json_file = open(path_json,'r')
    data : dict = load(json_file)
    json_file.close()
    return data

def get_default_ip() -> str:
    s = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
    try:
        s.connect(('8.8.8.8', 80))
        ip_local = s.getsockname()[0]
    except Exception as e:
        print("Error getting local IP: ", e)
        ip_local = None
    finally:
        s.close()
    return ip_local

def main():
    bind_config = json2dict('bind.json')
    https_port = bind_config["https_port"]
    print(f'{get_default_ip()}:{https_port}')

if __name__ == '__main__':
    main()