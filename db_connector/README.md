
# Custom Connector - Tweet Store  

Add tweet messages to a local database based on H2 and retrieve data from the DB. 

## How to test 

- Currently local package exporting and importing are not supported(WIP) from ballerina push/pull. 
- Hence you need to use consume the code in the same package. 
- Sample code : db_connector_sample.bal 
- Build : >> .../db_connector$ ballerina build demo.tweet.store
- Run : Get the balx from target and >> .../db_connector$ ballerina run demo.tweet.store.balx  

Client : 
- curl http://localhost:6060/tweetstore
