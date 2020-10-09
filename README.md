# Setup Janus Graph
## DANGER DANGER
This will create files and potentially overwrite files on your box. Run with caution.
Particularly if you have an existing janus-graph-0.5.2 installation and it's at ~/lib/janusgraph-0.5.2 

```
./scripts/startup/setup-janus.sh
```

If you don't have Cassandra/Elasticsearch running on your box already, you can use our docker compose file to start Elassandra.

```
docker-compose up -d
```
You might want to wait a second as that starts.


# Start Janus Graph Server
You can start a server from within an existing app by installing the mvn package in your pom.xml, or run it as a standalone process. The script below will started in a standalone process. This is required before being able to start the gremlin client.

```
# this is for websocket server
./scripts/startup/start-janus-server.sh
```

If you want to start an HTTP server instead:
```
./scripts/startup/start-http-janus-server.sh
```
The websocket one works fine though. Probably just use that.

# Start Janus Graph Gremlin Client
In order to start running some gremlin code, need to start the client. No need for a custom script for that.
```
~/lib/janusgraph-0.5.2/bin/gremlin.sh
```

## Setup your remote
Inside the gremlin client:
```
      :remote connect tinkerpop.server conf/remote.yaml session
      :remote console
```

## Run some queries

```
g.V()
```

You probably won't get anything back, unless you added some vertices. But now you're setup!

## Quit the client
To quit the client, just do `:q`

