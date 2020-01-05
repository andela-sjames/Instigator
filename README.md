# Instigator
A simple push/pull project that demonstrates the use of kafka for streaming data between two services. 

## Docker

To develop and/or run this application, download and install [docker](https://www.docker.com/get-started) and [docker-compose](https://docs.docker.com/compose/install/) from their website before proceeding.

Run the command `docker-compose up` from the **root directory** i.e. where you have the `docker-compose.yml` file and you should be good to go.

`docker-compose down` or `CMD/ctrl + C` to stop the application.

`docker-compose build` to build the application and `docker-compose up --build`  to build and run the application in one commnand. :)

## Services

The application consists of the following services:

- Zookeeper ensemble (3 nodes)
- Kafka Broker cluster(3 nodes)
- Go Consumer
- Python Producer
- Kafka-manager

These services are coupled together using the `docker-compose.yml` file at the root of the application.

### Brief context:
Kafka relies on Zookeeper to work as zookeeper stores a couple of things like kafka broker's metadata, Topic metadata, Consumer metadata and partition offset? a question mark there because recent versions of Kafka allows for this to be stored on the kafka cluster as well.

### Zookeeper Ensemble:
Ideally, this replication mode should not be deployed on the same physical machine but let's allow this for development and for proof of concept.
Reference: https://hub.docker.com/_/zookeeper,



### RUNNING THE APP

Once you have the application running locally using `docker-compose up` from the **root directory** you can navigate to the following addresses for administration/monitoring.

#### Zookeeper:
It comes with an admin server enabled by default
http://localhost:{8080-8082}/commands/{stats} where `stat` can be any of the following
e.g. http://localhost:8081/commands/dirs, http://localhost:8080/commands/stats

Here we are checking two different nodes on the zookeeper ensemble. Zookeeper runs on port `{2181 - 2183}` on the host machine but on port `2181` on the docker containers to avoid port collision as we can't re-use ports.

```
configuration
connection_stat_reset
connections
dirs
dump
environment
get_trace_mask
is_read_only
monitor
ruok
server_stats
set_trace_mask
stat_reset
stats
watch_summary
watches
watches_by_path
```

#### Kafka Brokers:
Runs on port `{9092-9094}`on the local machines and on port `9092` for the containers, it uses the `KAFKA_ZOOKEEPER_CONNECT=zoo1:2181,zoo2:2181,zoo3:2181` env variable to send it's metadata to the zookeeper ensemble before operations begins.

#### Kafka-Manager:
This runs on port `9000`, http://localhost:9000, this gives you access to the `kafka-manager` admin UI where you can create a cluster and monitor the activities of your cluster in realtime while performing admistrative task on your cluster to optimize performance.

For this setup add this line `zoo1:2181,zoo2:2181,zoo3:2181` to the cluster host field when you need to create a cluster from the UI dashboard.
```
Username: admin
password: admin
```

####

