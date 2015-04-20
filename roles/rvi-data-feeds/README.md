# RVI Data Feeds

## DockerHub

[advancedtelematic/rvi_data_feeds](https://registry.hub.docker.com/u/advancedtelematic/rvi_data_feeds/)

## Container name

`rvi-data-feeds`

## Dependencies

* `roles/docker-hub`
* `roles/cassandra`
* `roles/kafka`

## Notes

This role will migrate the RVI Schema to Cassandra and import historical data
into it. This will take quite some time, so be patient.

## Issues

* The migration script is run for every play
* The import is run for every play, even if the data is already imported
