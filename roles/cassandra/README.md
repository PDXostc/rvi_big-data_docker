# Cassandra base image

## DockerHub

[poklet/cassandra](https://registry.hub.docker.com/u/poklet/cassandra/)

## Container name

`cassandra`

## Exported ports

* `9042`
* `9160`

## Exported volumes

* `/var/lib/cassandra`

## Notes

This role will wait for 30 seconds until cassandra is up. This wait is
unfortunately neccessary in most cases.

