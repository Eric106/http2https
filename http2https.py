from modules.proxy import app

if __name__ == '__main__':
    print('starting WSGI server at https://localhost:8080')
    app.run(host='0.0.0.0', port=8080)
