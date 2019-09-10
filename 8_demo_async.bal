// Move all the invocation and tweeting functionality to another function
// call it asynchronously

// To run it:
// ballerina run 8_demo_async.bal --b7a.config.file=twitter.toml
// To invoke:
// curl -X POST localhost:9090
// Invoke many times to show how quickly the function returns
// then go to the browser and refresh a few times to see how gradually new tweets appear

import ballerina/config;
import ballerina/http;
import ballerina/stringutils;
import wso2/twitter;

twitter:Client tw = new ({
    clientId: config:getAsString("clientId"),
    clientSecret: config:getAsString("clientSecret"),
    accessToken: config:getAsString("accessToken"),
    accessTokenSecret: config:getAsString("accessTokenSecret"),
    clientConfig: {}
});

http:Client homer = new ("http://quotes.rest");

@http:ServiceConfig {
    basePath: "/"
}
service hello on new http:Listener(9090) {
    @http:ResourceConfig {
        path: "/",
        methods: ["POST"]
    }
    resource function hi(http:Caller caller, http:Request request) returns error? {
        // start is the keyword to make the call asynchronously.
        _ =start doTweet();
        http:Response res = new;
        // just respond back with the text.
        res.setPayload("Async call\n");
        _ = check caller->respond(res);
        return;
    }
}

// Move the logic of getting the quote and pushing it to twitter
// into a separate function to be called asynchronously.
function doTweet() returns error? {
    // We can remove all the error handling here because we call
    // it asynchronously, don't want to get any output and
    // don't care if it takes too long or fails.
    var hResp = check homer->get("/qod.json");
    var payload = check hResp.getTextPayload();
    if (!stringutils:contains(payload, "#ballerina")) {
        payload = payload + " #ballerina";
    }
    _ = check tw->tweet(payload);
    return;
}
