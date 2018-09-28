// Add twitter connector: import, create endpoint,
// create a new resource that invoke it
// To find it:
// ballerina search twitter
// To get it for tab completion:
// ballerina pull wso2/twitter
// To run it:
// ballerina run demo.bal --config twitter.toml
// To invoke:
// curl -X POST -d "Demo" localhost:9090

import ballerina/http;
// Pull and use wso2/twitter connector from http://central.ballerina.io
// It has the objects and APIs to make working with Twitter easy
import wso2/twitter;
// this package helps read config files
import ballerina/config;

// Twitter package defines this type of endpoint 
// that incorporates the twitter API.
// We need to initialize it with OAuth data from apps.twitter.com.
// Instead of providing this confidential data in the code
// we read it from a toml file.
endpoint twitter:Client tw {
   clientId: config:getAsString("clientId"),
   clientSecret: config:getAsString("clientSecret"),
   accessToken: config:getAsString("accessToken"),
   accessTokenSecret: config:getAsString("accessTokenSecret"),
   clientConfig: {}   
};

@http:ServiceConfig {
   basePath: "/"
}
service<http:Service> hello bind {port:9090} {
   @http:ResourceConfig {
       path: "/",
       methods: ["POST"]
   }
   hi (endpoint caller, http:Request request) {
       http:Response res;
       string payload = check request.getTextPayload();
       // Use the twitter connector to do the tweet
       twitter:Status st = check tw->tweet(payload);
       // Change the response back
       res.setPayload("Tweeted: " + st.text + "\n");
       _ = caller->respond(res);
   } 
}