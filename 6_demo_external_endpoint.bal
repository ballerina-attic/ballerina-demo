// Add another external web service endpoint
// to compensate for slowness use circuit breaker

// To run it:
// ballerina run demo.bal --config twitter.toml
// To invoke:
// curl -X POST localhost:9090
// Invoke a few times to show that it is often slow

import ballerina/http;
import wso2/twitter;
import ballerina/config;

endpoint http:Client homer {
  url: "http://www.simpsonquotes.xyz"
};

endpoint twitter:Client twitter {
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

      http:Response hResp = check homer->get("/quote");
      string status = check hResp.getTextPayload();

      if (!status.contains("#ballerina")){status=status+" #ballerina";}

      twitter:Status st = check twitter->tweet(status);

      json myJson = {
          text: status,
          id: st.id,
          agent: "ballerina"
      };
      res.setJsonPayload(myJson);

      _ = caller->respond(res);
  }
}