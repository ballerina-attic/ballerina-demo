// To compensate for slowness use circuit breaker
// To run it:
// ballerina run demo_circuitbreaker.bal --config twitter.toml
// To invoke:
// curl -X POST localhost:9090
// Invoke many times to show how circuit breaker works

import ballerina/http;
import wso2/twitter;
import ballerina/config;

endpoint http:Client homer {
  url: "http://www.simpsonquotes.xyz",
  circuitBreaker: {
      failureThreshold: 0,
      resetTimeMillis: 3000,
      statusCodes: [500, 501, 502]
  },
  timeoutMillis: 500
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
service<http:Service> hello bind {port: 9090} {
  @http:ResourceConfig {
      path: "/",
      methods: ["POST"]
  }
  hi (endpoint caller, http:Request request) {
      http:Response res;

      var v = homer->get("/quote");

      match v {
          http:Response hResp => {
              string status = check hResp.getTextPayload();

              if (!status.contains("#ballerina")){status=status+" #ballerina";}
              twitter:Status st = check twitter->tweet(status);
              json myJson = {
                  text: status,
                  id: st.id,
                  agent: "ballerina"
              };
              res.setJsonPayload(myJson);
          }
          error err => {
              res.setTextPayload("Circuit is open. Invoking default behavior.\n");
          }
      }

      _ = caller->respond(res);
  }
}