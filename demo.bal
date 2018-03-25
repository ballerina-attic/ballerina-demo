import ballerina/net.http;
import ballerina/io;
import ballerina/config;
import ballerina/util;
import ballerina/time;
import ballerina/net.uri;
import ballerina/security.crypto;

import wso2/twitter;

endpoint http:ServiceEndpoint inbound {
   port:9090
};

@http:ServiceConfig {
   basePath: "/"
}
service<http:Service> hello bind inbound  {
   @http:ResourceConfig{
       path: "/hello",  methods: ["POST"]
   }
    hi (endpoint client, http:Request req) {
        string name = deNull(req.getStringPayload());
        if (name == "") {name = "World";}
        http:Response res = {};
        res.setStringPayload("Hello "+name+"\n");
        _ = client -> respond(res);
   }

   @http:ResourceConfig{
       path: "/tweet",  methods: ["POST"]
   }
   tweet (endpoint client, http:Request req) {

        string status = deNull(req.getStringPayload());

        twitter:TwitterConnector twitter = {};

        twitter.init(           
            deNull(config:getAsString("consumerKey")), 
            deNull(config:getAsString("consumerSecret")), 
            deNull(config:getAsString("accessToken")),
            deNull(config:getAsString("accessTokenSecret"))
        );

        http:Response tweetResponse =? twitter.tweet(status);

        json jsonPayload =? tweetResponse.getJsonPayload();

        if (tweetResponse.statusCode == 200) {
            json newJSON = { Tweet: jsonPayload.text, 
                             TweetedAt: jsonPayload.created_at
                            };
            tweetResponse.setJsonPayload(newJSON);
        }
        _ = client->respond(tweetResponse);
    }
}

function deNull (string | null | error input) returns (string) {
    match input {
        string sReturn => { return sReturn;}
        null | error => { return "Parameter not found";}
    }
}

