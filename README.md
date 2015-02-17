# Install docker
sudo apt-get install docker.io
sudo apt-get install fig

Add yourself to the docker group:
usermod -aG docker $USERID

Ensure that docker is listening on TCP:2375:
Edit /etc/default/docker to add DOCKER_OPTS="-H tcp://localhost:2375 -H unix:///var/run/docker.sock"
or create /etc/systemd/system/docker.service with an appropriate
'ExecStart' line in its '[Service]' stanza

Start the docker daemon:
sudo service docker start # or
sudo systemctl start docker # or
sudo docker -d

# Build data feeds image

cd rvi_big_data/data_feeds
sbt docker:publishLocal

# Build api image

cd rvi_big_data/data-api
sbt docker:publishLocal

# Build ui image

apt-get install clojure1.6
wget -O $CLOUJURE_BIN/lein
https://raw.githubusercontent.com/technomancy/leiningen/stable/bin/lein
cd rvi_big_data/rvi-demo-ui
lein uberimage

# Build zookeeper image
cd rvi_big_data/docker
docker build -t "advancedtelematic/zookeeper" ./zookeeper

# Start containers
Edit fig.yml to update IP addresses:
- kafka > environment > EXPOSED_HOST should be set to the IP address of the docker host
- ui > environment > TRACES_URI should be set to the "ws://<docker_host_ip>:9000/ws"
fig up -d
