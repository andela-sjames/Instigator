import sys
import threading
import atexit

from flask import Flask, request

app = Flask(__name__)


WAIT_TIME = 2 #Seconds

globalThread = threading.Thread()

def get_generator():
    import random
    global globalThread
    # run outside the request context
    globalThread = threading.Timer(WAIT_TIME, get_generator, ())
    globalThread.start()
    resp  = {
        "random_value": random.random() * 5
    }
    print(resp, file=sys.stdout)

@app.route('/')
def hello_world():
    return 'Hello, World!'


@app.route('/start_producer', methods=['GET', ])
def produce():
    global globalThread
    if request.method == 'GET':
        # calls itself the first time and exits the request context
        globalThread = threading.Timer(WAIT_TIME, get_generator, ())
        globalThread.start()
        return 'Producer started'


@app.route('/stop_producer', methods=['GET', ])
def stop():
    global globalThread
    if request.method == 'GET':
        globalThread.cancel()
        return 'Producer stoped'
    
    
# atexit.register(stop)


if __name__ == '__main__':
    app.run(debug=True, host='0.0.0.0', port=5000)
