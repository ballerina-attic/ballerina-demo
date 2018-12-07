// To compensate for slowness use circuit breaker
// To run it:
// ballerina run --config twitter.toml demo_circuitbreaker.bal
// To invoke:
// curl -X POST localhost:9090
// Invoke many times to show how circuit breaker works

import ballerina/config;
import ballerina/http;
import wso2/twitter;

http:Client homer = new("http://www.simpsonquotes.xyz", config={
        circuitBreaker: {
            failureThreshold: 0.0,
            resetTimeMillis: 3000,
            statusCodes: [500, 501, 502]
        },
        timeoutMillis: 900
    });

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
        http:Response res = new;

        var v = homer->get("/quote");
        if (v is http:Response) {
            var payload = check v.getTextPayload();
            if (!payload.contains("#ballerina")){
                payload=payload+" #ballerina";
            }
            var st = check tw->tweet(payload);
            json myJson = {
                text: payload,
                id: st.id,
                agent: "ballerina"
            };
            res.setPayload(untaint myJson);
        } else {
            res.setPayload("Circuit is open. Invoking default behavior.\n");
        }

        _ = check caller->respond(res);
        return;
    }
}
