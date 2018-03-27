import ballerina/net.http;
import ballerina/data.sql;
import ballerina/runtime;
import ballerina/log;
import ballerina/io;

import demo.tweet.store;

// A ServiceEndpoint listens to HTTP request on port 9090
endpoint http:ServiceEndpoint dataServiceEP {
    port:6060
};

// A sql client endpoint can be used to connect to a database
// and execute SQL queries against it.
//endpoint sql:Client customerDB {
//    database:sql:DB.H2_FILE,
//    host:"./",
//    port:10,
//    name:"CUSTOMER_DB",
//    username:"root",
//    password:"root",
//    options:{maximumPoolSize:5}
//};


endpoint TweetSaveEP tweetSaveEP {
    name:"CUSTOMER_DB",
    path:"./"
};



// A service is a network-accessible API
@http:ServiceConfig {
    basePath:"/"
}
service<http:Service> data_service bind dataServiceEP {

    // A resource is an invokable API method
    // This resource only accepts HTTP GET requests on '/customer'
    // 'caller' is the client invoking this resource
    @http:ResourceConfig {
        methods:["GET"],
        path:"/customer"
    }
    customers (endpoint caller, http:Request req) {

        var result = tweetSaveEP -> persist("Hello Twitter", "kasunindrasiri");

        json allTweets =? tweetSaveEP->getAllTweets();

        // Set the JSON payload to the response message
        http:Response res = {};
        res.setJsonPayload(allTweets);

         // Send the response back to the caller.
         _ = caller -> respond(res);


        //table dt =? customerDB -> select("SELECT * FROM CUSTOMER", null, null);
        //// Convert data table to JSON object.
        //json response =? <json>dt;
        //http:Response res = {};
        //// Set the JSON payload to the response message
        //res.setJsonPayload(response);

        // Send the response back to the caller.
        // _ = caller -> respond(res);
    }
}





// TweetSave Connector


//struct TweetSaveConfig {
//    string name;
//    string path;
//}
//
//struct TweetSaveEP {
//
//    //http:ClientEndpoint httpClient;
//    sql:Client sqlClient;
//}
//
//function <TweetSaveEP ep> init (TweetSaveConfig conf) {
//    // endpoint http:ClientEndpoint httpEP {targets:[{uri:conf.url}]};
//    endpoint  sql:Client dbSQLClient  {
//        database:sql:DB.H2_FILE,
//        host:conf.path,
//        //port:10,
//        name:conf.name,
//        //username:"root",
//        //password:"root",
//        options:{maximumPoolSize:5}
//    };
//    ep.sqlClient = dbSQLClient;
//}
//
//function <TweetSaveEP ep> getClient () returns (TweetSaveClient) {
//    return {customerDB:ep};
//}
//
//struct TweetSaveClient {
//    TweetSaveEP customerDB;
//}
//
//
//
//function <TweetSaveClient client> persist (string content, string tweeterId) returns boolean |error {
//    endpoint sql:Client localClient = client.customerDB.sqlClient;
//    sql:Parameter[] params = [];
//    sql:Parameter para1 = {sqlType : sql:Type.VARCHAR, value : content};
//    sql:Parameter para2 = {sqlType : sql:Type.VARCHAR, value : tweeterId};
//    params = [para1, para2];
//    io:println("persist 1");
//
//    var ret = localClient -> update("INSERT INTO TWEET_STORE (CONTENT, TWEET_ID) VALUES (?,?)", params);
//
//    match ret {
//        int rows => {
//            io:println("Inserted row count:" + rows);
//        }
//        sql:SQLConnectorError err => {
//            io:println("Insertion  failed:" + err.message);
//            return false;
//        }
//    }
//    io:println("persist 2");
//
//    return true;
//}
//
//function <TweetSaveClient client> getAllTweets () returns json |error {
//    endpoint sql:Client localClient = client.customerDB.sqlClient;
//
//    table dt =? localClient -> select("SELECT * FROM TWEET_STORE", null, null);
//    var response = <json>dt;
//    return response;
//}








