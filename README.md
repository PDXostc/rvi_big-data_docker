1. Build zookeeper image: docker build -t "advancedtelematic/zookeeper" ./zookeeper
2. Change kafka.environment.EXPOSED_HOST to point match docker's host, if needed. 
3. Start zookeeper and kafka containers: fig up -d
