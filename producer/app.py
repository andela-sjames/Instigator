import threading

from flask import Flask

app = Flask(__name__)

clock_timer = None

def get_generator():
    import random
    resp  = {
        "random_value": random.random() * 5
    }
    print(resp)

@app.route('/', methods=['GET', ])
def hello_world():
    return 'Hello, World!'


@app.route('/start_producer', methods=['GET', ])
def produce():
    global clock_timer
    timer = threading.Timer(20, get_generator)
    timer.start()
    clock_timer = timer
    return 'Producer started'


@app.route('/stop_producer', methods=['GET', ])
def stop():
    global clock_timer
    clock_timer.cancel()
    return 'Producer stoped'


if __name__ == '__main__':
    app.run(debug=True, host='0.0.0.0', port=5000)
