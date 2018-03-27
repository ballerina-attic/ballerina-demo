package demo.tweet.store;

import ballerina/net.http;
import ballerina/data.sql;
import ballerina/runtime;
import ballerina/log;
import ballerina/io;

// A ServiceEndpoint listens to HTTP request on port 9090
endpoint http:ServiceEndpoint dataServiceEP {
    port:6060
};


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
        path:"/tweetstore"
    }
    customers (endpoint caller, http:Request req) {
        var result = tweetSaveEP -> persist("Hello Twitter", "kasunindrasiri");
        json allTweets =? tweetSaveEP->getAllTweets();
        http:Response res = {};
        res.setJsonPayload(allTweets);
        _ = caller -> respond(res);

    }
}








