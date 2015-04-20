## RVI UI

## DockerHub

[advancedtelematic/rvi_demo_ui](https://registry.hub.docker.com/u/advancedtelematic/rvi_demo_ui/)

## Container name

`rvi-api`

## Exported ports

* `10555`

## Dependencies

* `roles/docker-hub`
* `roles/rvi-api`

## Notes

This is currently pinned to version `0.5.3`. You can access the UI on
port `10555`.

## Issues

* Needs to run on the same machine as `rvi-api`, as the IP is static at the
  moment.
