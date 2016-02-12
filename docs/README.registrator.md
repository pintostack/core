# Registrator

[Registrator](https://github.com/gliderlabs/registrator) is used for service discovery purposes.
It listens for docker events and registers/deregisters services. Service information is
extracted from docker container.


## Build registrator

To build registrator `go` should be installed.

```
export GOPATH=~/go
go get github.com/gliderlabs/registrator
cd $GOPATH/src/github.com/gliderlabs/registrator
git add remote pintostack https://github.com/pintostack/registrator
git fetch pintostack
git checkout pintostack/master
go get
go build -o /bin/registrator
```


## Run registrator

To run registrator on a slave machine:

```
DOCKER_HOST=unix:///var/run/docker.sock registrator \
--marathon-ports=true --cleanup=true \
--service-name-single "{{NAME}}" \
--service-name-group "{{NAME}}-port{{PORT_INDEX}}" \
--service-check-script "nc -w 5 -z {{HOST}} {{PORT}} >/dev/null" \
--service-check-interval "10s" \
consul://$HOST:8500
```

`DOCKER_HOST` variable should be provided to watch docker events.

`--service-name-single` and `--service-name-group` parameters
are used as default service name (if it's not explicitly provided
via `SERVICE_PORTX_NAME` environment variable).
The first one is used for such a containes with one port exported.
The second one is used for such a container that exports multiple ports.

`--service-check-script` is default check script for a service.
This check will be binded to the if no explicit check provided
with `SERVICE_PORTX_CHECK_SCRIPT` environment variable.


## Service customization

A service can be customized by environment variables. See this
[page](http://gliderlabs.com/registrator/latest/user/services/) for basic information.
These variables can be set in Marathon application file.

Pintostack extended registrator supports two features:
- port indexation
- variable substitution

### Port indexation

If container port is unknown, i.e. `"containerPort": 0` where is no way
in standard registrator to customize this port. We cannot use `SERVICE_ZZZ_NAME`
variable because we don't know which `ZZZ` port will be assigned by Marathon.
In this case we can use `SERVICE_PORTX_NAME` notation. The `PORTX` refers to
the port mapping by index.

```
SERVICE_PORT0_NAME="http"
SERVICE_PORT1_NAME="rpc"
```

### Variable substitution

It's possible to customize service variables with fixed list of keywords.
For example:

```
SERVICE_PORT0_NAME="{{NAME}}-port{{PORT_INDEX}}"
SERVICE_PORT0_CHECK_SCRIPT="nc -w 5 -z {{HOST}} {{PORT}}"
```

The following keywords are supported:
- `{{NAME}}` - service name (first word of container name)
- `{{HOST_PORT}}`, `{{PORT}}` - host port number
- `{{EXPOSED_PORT}}` - container port number
- `{{HOST_IP}}`, `{{HOST}}` - host IP address
- `{{EXPOSED_IP}}` - container IP address
- `{{PORT_INDEX}}` - port mapping index: 0, 1, 2, ...

