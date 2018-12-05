// Add transformation: #ballerina to input, and JSON to output
// To run it:
// ballerina run --config twitter.toml demo.bal
// To invoke:
// curl -X POST -d "Demo" localhost:9090

import ballerina/http;
import wso2/twitter;
import ballerina/config;

twitter:Client tw = new({
    clientId: config:getAsString("clientId"),
    clientSecret: config:getAsString("clientSecret"),
    accessToken: config:getAsString("accessToken"),
    accessTokenSecret: config:getAsString("accessTokenSecret"),
    clientConfig:{}
});

@http:ServiceConfig {
    basePath: "/"
}
service hello on new http:Listener(9090) {
    @http:ResourceConfig {
        path: "/",
        methods: ["POST"]
    }
    resource function hi (endpoint caller, http:Request request) {
        var payload = request.getTextPayload();
        if (payload is string) {
            // Transformation on the way to the twitter service - add hashtag.
            if (!payload.contains("#ballerina"))
            {
                payload = payload + " #ballerina";
            }

            var st = tw->tweet(payload);
            if (st is twitter:Status) {
                // Transformation on the way out - generate a JSON and pass it back
                // note that json is a first-class citizen
                // and we can construct it from variables, data, and fields.
                json myJson = {
                    text: payload,
                    id: st.id,
                    agent: "ballerina"
                };
                // Pass back JSON instead of text.
                http:Response res = new;
                res.setPayload(untaint myJson);
                _ = caller->respond(res);
            } else {
                panic st;
            }
        } else {
            panic payload;
        }
    }
}