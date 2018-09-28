// Add transformation: #ballerina to input, and JSON to output
// To run it:
// ballerina run demo.bal --config twitter.toml
// To invoke:
// curl -X POST -d "Demo" localhost:9090

import ballerina/http;
import wso2/twitter;
import ballerina/config;

endpoint twitter:Client tw {
   clientId: config:getAsString("clientId"),
   clientSecret: config:getAsString("clientSecret"),
   accessToken: config:getAsString("accessToken"),
   accessTokenSecret: config:getAsString("accessTokenSecret"),
   clientConfig:{}   
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

       // Transformation on the way to the twitter service - add hashtag.
       if (!payload.contains("#ballerina")){payload=payload+" #ballerina";}

       twitter:Status st = check tw->tweet(payload);

       // Transformation on the way out - generate a JSON and pass it back
       // note that json is a first-class citizen
       // and we can construct it from variables, data, and fields.
       json myJson = {
           text: payload,
           id: st.id,
           agent: "ballerina"
       };
       // Pass back JSON instead of text.
       res.setPayload(untaint myJson);

       _ = caller->respond(res);
   } 
}