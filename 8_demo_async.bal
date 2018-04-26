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
      // start is the keyword to make the call asynchronously
      _ = start doTweet();
      http:Response res;
      // just respond back with the text
      res.setTextPayload("Async call\n");      
      _ = caller->respond(res);
  }
}

// Move the logic of getting the quote and pushing it to twitter 
// into a separate function to be called asynchronously.
function doTweet() {
    // We can remove all the error handling here because we call
    // it asynchronously, don't want to get any output and
    // don't care if it takes too long or fails
    http:Response hResp = check homer->get("/quote");
    string payload = check hResp.getTextPayload();
    if (!payload.contains("#ballerina")){ payload = payload+" #ballerina"; }
    _ = twitter->tweet(payload);
}