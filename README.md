# Setup JanusGraph
A tutorial for running [JanusGraph](https://janusgraph.org/) on Cassandra and Elasticsearch using [Elassandra](https://www.elassandra.io/), and then visualizing the graph using [Graphexp](https://github.com/bricaud/graphexp).

![](https://github.com/RyanQuey/janus-graph-tutorial/raw/main/images/search-results-default-view.png)

## WARNING
This will create files and potentially overwrite files on your box. Run with caution.
I think only is a problem if you have an existing janus-graph-0.5.2 installation and it's at ~/lib/janusgraph-0.5.2 . See ./scripts/startup/setup-janus.sh for what we do.

```
./scripts/startup/setup-janus.sh
```

If you don't have Cassandra/Elasticsearch running on your box already, you can use our docker compose file to start Elassandra.

```
docker-compose up -d
```
You might want to wait a second as that starts.


# Start JanusGraph Server
You can start a server from within an existing app by installing the mvn package in your pom.xml, or run it as a standalone process. The script below will started in a standalone process. This is required before being able to start the gremlin client.

```
# this is for websocket server
./scripts/startup/start-janus-server.sh
```

## If you want to start an HTTP server instead:
```
./scripts/startup/start-http-janus-server.sh
```
The websocket one works fine though. Probably just use that.

# Start JanusGraph Gremlin Client
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

Get everything using this, which is safe only if there's just a small demo graph
```
g.V()
```

You probably won't get anything back, unless you added some vertices. But now you're setup!

## Quit the client
To quit the client, just do `:q`

# Setup GraphExp
GraphExp is an easy way to visualize your graph from a browser. Other options exist such as [invana-studio](https://github.com/invanalabs/invana-studio), [gremlin-visualizer](https://github.com/prabushitha/gremlin-visualizer), and others, but we will demonstrate how to setup GraphExp for this project.

## Make sure JanusGraph server is running on HTTP or Websocket
[See instructions above](https://github.com/RyanQuey/janus-graph-tutorial#start-janus-graph-server)

## clone and run graphexp script
This will serve a simple html file that uses D3 to visualize your graph contents

```
git clone https://github.com/bricaud/graphexp.git
cd graphexp
# serve their html file that will connect to your JanusGraph using D3.js
python -m SimpleHTTPServer
```
Note that graphexp is making HTTP calls from the browser, not the Python server. So make sure ports on your machine are setup accordingly.

Until your graph vertices and edges are loaded, you'll only see a blank UI
![](https://github.com/RyanQuey/janus-graph-tutorial/raw/main/images/graphexp-setup.png)


## Connect over websocket or HTTP
JanusGraph Server has the ability to serve over HTTP or websocket. Make sure that Graphexp is configured to the right protocol in accordance with what protocol JanusGraph is serving. 

GraphExp configuration is set in the browser fields

### Example Config using Websocket
![](https://github.com/RyanQuey/janus-graph-tutorial/raw/main/images/graphexp.websocket.png)

## Can set the color of each node by label
![](https://github.com/RyanQuey/janus-graph-tutorial/raw/main/images/color-node-by-label.png)

# Can you connect JanusGraph to Datastax Astra...?
## NOTE never got this to work
This was never completed, but documents what I started trying and some potential routes to look into.

1) download Astra credentials bundle and put it in the ./creds dir (as long as it stays in the creds dir, we have gitignore'd that for you already)
2) Unzip your bundle 
```
unzip ./creds/secure-connect-<your-db-name-in-astra>.zip -d ./creds/
```

3) either make a new keyspace or note what keyspace you made in Astra.
4) set a password on your keystore

  * if you don't, I got this error if storage.cql.ssl.keystore.keypassword is blank: 
      ```
      Caused by: java.lang.IllegalArgumentException: Invalid configuration value for [root.storage.cql.ssl.keystore.keypassword]
      ```
  * Or if I put empty string: 
      ```
      Caused by: java.security.UnrecoverableKeyException: Cannot recover key
      ```
  * Can change it as follows:
      ```
      keytool -storepass '' -keystore identity.jks  -storepasswd
      # then put in a password that you want to
      ```

      Now put that pass in storage.cql.ssl.keystore.keypassword (in step 5 below)

5) using the ./conf/astra-janusgraph-cql-es-server.properties.example file as a template, use info from Astra secure connect bundle to fill out all keys listed there. 
  * Note that the example file assumes you are still running elasticsearch locally
  * For further details, see here: https://community.datastax.com/answers/8759/view.html. 
  * For Janus Graph reference on the configs, see here: https://docs.janusgraph.org/basics/configuration-reference/
  * Note that unless you are using older versions of Cassandra, you want to use `cql` options rather than `cassandra` (which uses thrift)

```
cp ./conf/astra-janusgraph-cql-es-server.properties.example ./conf/astra-janusgraph-cql-es-server.properties
vim  ./conf/astra-janusgraph-cql-es-server.properties
# ...
```

# Using Invana-Studio (TODO)
Looks like no setup is required, just setup your server and can use their hosted vis tool here: https://graph-explorer.herokuapp.com/connect

Haven't tried yet though.
