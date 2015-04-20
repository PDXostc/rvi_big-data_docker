# RVI Big Data POC

## Overview

All components can be deployed as docker containers, locally or in cloud. The image below shows the components and their dependencies.

<pre>
                                           ┏━━━━━━━━━━━━━━━━━━━━━━━━━━┓
                                           ┃Docker                    ┃
                                           ┃  ┌────────────────────┐  ┃
                                           ┃  │       Feeder       │  ┃
                                           ┃  └────────────────────┘  ┃
                                           ┗━━━━━━━━━━━━━┳━━━━━━━━━━━━┛
                                                         │
                                                         │
                                                         │
                                                         │
                                                         ▼                         ┏━━━━━━━━━━━━━━━━━━━━━━━━━━┓
┏━━━━━━━━━━━━━━━━━━━━━━━━━━┓                ┏━━━━━━━━━━━━━━━━━━━━━━━━━┓            ┃Docker                    ┃
┃Docker                    ┃                ┃Docker                   ┃            ┃   ╔════════════════════╗ ┃
┃  ┌────────────────────┐  ┃                ┃ ┌────────────────────┐  ┃            ┃   ║     Ingestion      ║ ┃
┃  │     Zookeeper      │  ┃◀──────┬────────┫ │       Kafka        │  ┃◀───────────┃   ║ ┌─────────────────┐║ ┃
┃  └────────────────────┘  ┃       │        ┃ └────────────────────┘  ┃            ┃   ║ │      Spark      │║ ┃
┗━━━━━━━━━━━━━━━━━━━━━━━━━━┛       │        ┗━━━━━━━━━━━━━━━━━━━━━━━━━┛            ┃   ║ └─────────────────┘║ ┃
                                   │                     ▲                         ┃   ╚════════════════════╝ ┃
                                   │                     │                         ┗━━━━━━━━━━━━━━━━━━━━━━━━━━┛
                                   │                     │                                       │
                                   │                     │                                       │
                                   │       ┏━━━━━━━━━━━━━━━━━━━━━━━━━━┓                          │
                                   │       ┃Docker                    ┃                          │
                                   │       ┃   ╔════════════════════╗ ┃                          │
                                   │       ┃   ║        API         ║ ┃                          │
                                   └───────┃   ║ ┌─────────────────┐║ ┃─────┐                    │
                                           ┃   ║ │      Spark      │║ ┃     │                    │
                                           ┃   ║ └─────────────────┘║ ┃     │                    │
                                           ┃   ╚════════════════════╝ ┃     │                    ▼
                                           ┗━━━━━━━━━━━━━━━━━━━━━━━━━━┛     │      ┏━━━━━━━━━━━━━━━━━━━━━━━━━━┓
                                                         ▲                  │      ┃Docker                    ┃
                                                         │                  │      ┃  ┌────────────────────┐  ┃
                                                         │                  └─────▶┃  │     Cassandra      │  ┃
                                                         │                         ┃  └────────────────────┘  ┃
                                           ┏━━━━━━━━━━━━━━━━━━━━━━━━━━┓            ┗━━━━━━━━━━━━━━━━━━━━━━━━━━┛
                                           ┃Docker                    ┃
                                           ┃  ┌────────────────────┐  ┃
                                           ┃  │         UI         │  ┃
                                           ┃  └────────────────────┘  ┃
                                           ┗━━━━━━━━━━━━━━━━━━━━━━━━━━┛
</pre>

## Quick Start

The easiest way to deploy the system is to use prebuild docker images. There is an [Ansible](http://www.ansible.com/home) playbooks, allowing to install the system on the existing docker host.

### Installing docker

The installation guides for all supported operating systems can be found [here](https://docs.docker.com/installation/#installation).

### Create a dockerhub user
Create an account at [docker hub](https://hub.docker.com/account/signup/). You will need to be added to the advancedtelematic organisation there.

### Installing Ansible.

The installation instructions can be found [here](http://docs.ansible.com/intro_installation.html). Provided playbook was tested with versions 1.8.4 and 1.9.0.1.

### Running playbook.

To run the playbook the following command should be used: `ansible-playbook deploy-rvi.yml -i inventory/rvi`. In case the docker host differs from `127.0.0.1:2375` the file should be adjusted by setting the parameters of the `rvi` entry. Please refer to the list of the available parameters on the [Ansible documentation page](http://docs.ansible.com/intro_inventory.html#list-of-behavioral-inventory-parameters). 

## Manual building docker images.

The following third-party images are used in the POC:

1. [Kafka](https://registry.hub.docker.com/u/ches/kafka/). Have to be linked to the zookeeper container in order to run.
2. [Cassandra](https://registry.hub.docker.com/u/poklet/cassandra/)

### Zookeeper
The Zookeeper image can build by executing `docker build ./zookeeper`. It is also available on [Docker Hub](https://registry.hub.docker.com/u/advancedtelematic/zookeeper/).

### Api

The api container contains REST Api and standalone spark cluster running inside of single JVM. 

[GitHub repository](https://github.com/advancedtelematic/rvi_big_data-data-api.git)

`./sbt docker:publishLocal` builds the docker image on the docker host specified by `DOCKER_HOST` environment variable.

Creating DB schema:
```
docker run -it --rm --link <cassandra-container>:cass1 -v `pwd`/scripts:/data poklet/cassandra bash -c 'cqlsh $CASS1_PORT_9160_TCP_ADDR -f /data/schema.cql'
```

Running the container:
```
docker run --rm -t -i --link=<cassandra-container>:cassandra --link=<kafka-container>:kafka --link=<zookeeper_container>:zk -p 9000:9000 advancedtelematic/rvi_data_api
```
`<cassandra-container>`, `<kafka-container>` and `<zookeeper-container` must be replaced by name or id of the corresponding container.

### UI 

A single page web application is running inside of this container. 

[GitHub repository](https://github.com/advancedtelematic/rvi_big_data-rvi-demo-ui.git) 

To be able to build the image the [Leiningen](http://leiningen.org/) build tool have to be 
installed. On a debian linux it can be done using following commands:
```
apt-get install clojure1.6
wget -O $CLOUJURE_BIN/lein https://raw.githubusercontent.com/technomancy/leiningen/stable/bin/lein
```
or as described [here](http://leiningen.org/#install)

The `lein uberimage` builds the image. Please note, thet the docker host needs to be accessible via http in order to run this command. It can be archived 
by editing the `/etc/default/docker` file and adding `DOCKER_OPTS="-H tcp://localhost:2375 -H unix:///var/run/docker.sock"`.

Running the container: 
```
docker run --rm -t -i --expose=10555 -p 10555:10555 -e TRACES_URI="ws://<api-ip>:9000/ws" API_URI: http://<api-ip>:9000/ advancedtelematic/rvi_demo_ui
```
where `<api-ip>` should be replaced with ip address of the REST API (usually is equal to the ip address of the docker host).

### Data feeder

[GitHub repository](https://github.com/advancedtelematic/rvi_big_data-data_feeds.git) 

#### Import of historical data

```
JAVA_OPTS="-Xms512M -XX:NewRatio=3 -Xmx4G -Xss10M" sbt "runMain com.advancedtelematic.feed.CassandraFeeder" -Dcassandra.host=<ip_of_cassandra>
```

#### Docker container

The process running inside of this container feeds kafka `gps_trace` topic with the data from the `data/compressed` folder.
Building image: `./sbt docker:publishLocal`

Running the container:
```
docker run --rm -t -i --link=<kafka-container>:kafka advancedtelematic/rvi_data_feeds
```

### Data ingestion

Spark streaming running on localhost, preprocesses the data and stores it into cassandra. 

[GitHub repository](https://github.com/advancedtelematic/rvi_big_data-data-ingestion.git) 

`./sbt docker:publishLocal` builds the docker image on the docker host specified by `DOCKER_HOST` environment variable.

Running the container:
```
docker run --rm -t -i --link=<cassandra-container>:cassandra --link=<zookeeper_container>:zk advancedtelematic/rvi_data_ingestion
```

## Starting in vagrant

The vagrant machine is configured by running the following:

```
./setup-coreos-vagrant.sh
```

This also deploys the application. Keep in mind the task "Import data" takes a while (10min+).

To redeploy the application to vagrant run:

```
ssh-add ~/.vagrant.d/insecure_private_key
ansible-playbook deploy-rvi-dev.yml -i coreos-ansible-example/inventory/vagrant
```

## Starting locally
update hosts-dev and set `ansible_ssh_user` to your user.

```
ansible-playbook deploy-rvi-dev.yml -i hosts-dev
```

## API

### Data stream.

The data feeded into the kafka is available via websocket uri `ws://<api-host>:9000/ws`. The stream consists of entries in [EDN](https://github.com/edn-format/edn) 
format and contains following fields:

- `:id` vehicle identification number
- `:lat` - lattitude
- `:lng` - longtitude
- `:occupied` - occupancy

The stream can be filtered:

- by speed of a vehicle. Can be activated by sending a JSON message containing fields `min` and `max`. Example: 
```js
{
    "min": 80,
    "max": 100
}``` 
- by area. The area should be defined as a JSON array containing vertices of a polygon. Each vertex is defined as a object with the fields `lat` and `lng`.
 
### Point-in-time fleet position.

URI: http://<api-host>:9000/fleet/position

Query parameters:

- `timestamp` - number of milliseconds since January 1, 1970, 00:00:00 GMT.
- multiple `area` parameters - strings in format `<lat>,<lng>`, specifying vertices of a polygon.

Example:
```
http://127.0.0.1:9000/fleet/position?time=1211244390000&area=37.72347854862523%2C-122.47386932373047&area=37.76745803822967%2C-122.47386932373047&area=37.76745803822967%2C-122.40863800048828&area=37.72347854862523%2C-122.40863800048828
```

### Pickups heat map

URI: http://<api-host>:9000/pickups

Query parameters:

- `dateFrom`- number of milliseconds since January 1, 1970, 00:00:00 GMT.
- `dateTo` - number of milliseconds since January 1, 1970, 00:00:00 GMT.
- `hourFrom` and `hourTo` - hours of the day [0..23]
- multiple `area` parameters - strings in format `<lat>,<lng>`, specifying vertices of a polygon.

Example:
```
http://127.0.0.1:9000/pickups?dateFrom=1211061600000&dateTo=1211148000000&hourFrom=12&hourTo=13&area=37.71587450674273%2C-122.4862289428711&area=37.766915240907736%2C-122.4862289428711&area=37.766915240907736%2C-122.4031448364258&area=37.71587450674273%2C-122.4031448364258
```
