// To compensate for slowness use circuit breaker
// To run it:
// ballerina run 7_demo_circuit_breaker.bal --b7a.config.file=twitter.toml
// To invoke:
// curl -X POST localhost:9090
// Invoke many times to show how circuit breaker works

import ballerina/config;
import ballerina/http;
import ballerina/stringutils;
import wso2/twitter;

http:Client homer = new ("http://quotes.rest", config = {
    circuitBreaker: {
        failureThreshold: 0.0,
        resetTimeInMillis: 3000,
        statusCodes: [500, 501, 502]
    },
    timeoutInMillis: 900
});

twitter:Client tw = new ({
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
    resource function hi(http:Caller caller, http:Request request) returns error? {
        http:Response res = new;

        var hResp = homer->get("/qod.json");
        if (hResp is http:Response) {
            json payload = check hResp.getJsonPayload();
            json[] quotes = <json[]>(payload.contents.quotes);
            string status = quotes[0].quote.toString();
            if (!stringutils:contains(status, "#ballerina")) {
                status = status + " #ballerina";
            }
            var st = check tw->tweet(status);
            json myJson = {
                text: payload,
                id: st.id,
                agent: "ballerina"
            };
            res.setPayload(<@untainted>myJson);
        } else {
            res.setPayload("Circuit is open. Invoking default behavior.\n");
        }

        _ = check caller->respond(res);
        return;
    }
}
