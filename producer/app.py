import sys
import threading
import atexit

from flask import Flask, request
from pykafka import KafkaClient

app = Flask(__name__)

WAIT_TIME = 2 #Seconds

globalThread = threading.Thread()

client = KafkaClient(hosts="broker:9092,broker:9093,broker:9093")

topicOne = client.topics['sampleOne']
print(client.topics, "topics listed", file=sys.stdout)

def get_generator():
    import random
    global globalThread
    # run outside the request context
    globalThread = threading.Timer(WAIT_TIME, get_generator, ())
    globalThread.start()
    with topicOne.get_producer(use_rdkafka=True) as producer:
        resp  = "random number " + str(random.random() * 5)
        producer.produce(resp.encode(), partition_key=b"testOne")
        print(resp, file=sys.stdout)

def exit_thread():
    global globalThread
    # kill producer irrespective on exit
    if hasattr(globalThread, 'cancel'):
        globalThread.cancel()
        print(" exit_thread called", file=sys.stdout)

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
    
atexit.register(exit_thread)

if __name__ == '__main__':
    app.run(debug=True, host='0.0.0.0', port=5000)
