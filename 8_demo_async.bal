// Move all the invocation and tweeting functionality to another function
// call it asynchronously

// To run it:
// ballerina run demo_async.bal --config twitter.toml
// To invoke:
// curl -X POST localhost:9090
// Invoke many times to show how quickly the function returns
// then go to the browser and refresh a few times to see how gradually new tweets appear

import ballerina/http;
import wso2/twitter;
import ballerina/config;

endpoint twitter:Client twitter {
  clientId: config:getAsString("clientId"),
  clientSecret: config:getAsString("clientSecret"),
  accessToken: config:getAsString("accessToken"),
  accessTokenSecret: config:getAsString("accessTokenSecret"),
  clientConfig: {}  
};

endpoint http:Client homer {
  url: "http://www.simpsonquotes.xyz"
};

@http:ServiceConfig {
  basePath: "/"
}
service<http:Service> hello bind {port: 9090} {
  @http:ResourceConfig {
      path: "/",
      methods: ["POST"]
  }
  hi (endpoint caller, http:Request request) {
      var v = start doTweet();
      http:Response res;
      res.setTextPayload("Async call\n");      
      _ = caller->respond(res);
  }
}

function doTweet() {
    http:Response hResp = check homer->get("/quote");
    string status = check hResp.getTextPayload();
    if (!status.contains("#ballerina")){ status = status+" #ballerina"; }
    _ = twitter->tweet(status);
}