// Add another external web service endpoint
// to compensate for slowness use circuit breaker

// To run it:
// ballerina run --config twitter.toml demo.bal
// To invoke:
// curl -X POST localhost:9090
// Invoke a few times to show that it is often slow

import ballerina/config;
import ballerina/http;
import wso2/twitter;

http:Client homer = new("http://www.simpsonquotes.xyz");

twitter:Client tw = new({
  clientId: config:getAsString("clientId"),
  clientSecret: config:getAsString("clientSecret"),
  accessToken: config:getAsString("accessToken"),
  accessTokenSecret: config:getAsString("accessTokenSecret"),
  clientConfig: {}  
});

@http:ServiceConfig {
  basePath: "/"
}
service hello on new http:Listener(9090) {
    @http:ResourceConfig {
      path: "/",
      methods: ["POST"]
    }
    resource function hi (http:Caller caller, http:Request request) returns error? {

        var hResp = check homer->get("/quote");
        var status = check hResp.getTextPayload();
        if (!status.contains("#ballerina")) {
            status = status + " #ballerina";
        }

        var st = check tw->tweet(status);

        json myJson = {
            text: status,
            id: st.id,
            agent: "ballerina"
        };
        http:Response res = new;
        res.setPayload(untaint myJson);

        _ = check caller->respond(res);
        return;
    }
}
