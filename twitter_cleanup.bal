// Clean up all the old tweets
// BE SUPER CAREFUL
// Parameters: twitter account, number of days to delete
// To start:
// ballerina run twitter_cleanup.bal --config twitter.toml
// To list all tweets from today:
// curl localhost:9090/B7aDemo/0
// To delete all tweets from today:
// curl -X DELETE localhost:9090/B7aDemo/0

import ballerina/http;
import wso2/twitter;
import ballerina/config;
import ballerina/io;
import ballerina/time;

twitter:Client twc = new({
    clientId: config:getAsString("clientId"),
    clientSecret: config:getAsString("clientSecret"),
    accessToken: config:getAsString("accessToken"),
    accessTokenSecret: config:getAsString("accessTokenSecret"),
    clientConfig: {}  
});

@http:ServiceConfig {
    basePath: "/"
}
service tweetCleaner on new http:Listener(9090) {
    @http:ResourceConfig {
        methods: ["GET"],
        path: "/{account}/{days}"
    }  
    resource function list (http:Caller caller, http:Request request, string account, int days) {
        http:Response res = new;
        twitter:Status[] tws = getTweets(account, days);
        json[] tweets = [];
        foreach var tw in tws {
            json t = {  date: tw.createdAt,
                        id: tw.id,
                        text: tw.text};
            tweets[tweets.length()] = t;
            io:println(tw.createdAt + ": " + tw.id);
        }
        json out = { tweets : tweets };
        res.setJsonPayload(untaint out, contentType = "application/json");
        _ = caller->respond(res);
    }

    @http:ResourceConfig {
        methods: ["DELETE"],
        path: "/{account}/{days}"
    }  
    resource function delete (http:Caller caller, http:Request request, string account, int days) {
        http:Response res = new;
        json[] tweets = [];
        twitter:Status[] tws = getTweets(account, days);
        foreach var tw in tws {
            json t = {  date: tw.createdAt,
                        id: tw.id,
                        text: tw.text};
            tweets[tweets.length()] = t;
            _ = twc->destroyStatus(untaint tw.id);
            io:println(tw.createdAt + ": " + tw.id);
        }
        json out = { deleted : tweets };
        res.setJsonPayload(untaint out, contentType = "application/json");
        _ = caller->respond(res);
    }
}

function getTweets(string account, int days) returns twitter:Status[] {
    string searchStr = "";
    searchStr = "from:" + account + " since:" + time:currentTime().subtractDuration(0, 0, days, 0, 0, 0, 0).format("yyyy-MM-dd");
    io:println(searchStr);
    var v = twc->search(searchStr, {});
    twitter:Status[] out = [];
    if (v is twitter:Status[]) {
        out = v;
    } else {
        io:println("Error: ", v);
    }
    return out;
}
