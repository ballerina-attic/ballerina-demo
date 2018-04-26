// Add transformation: #ballerina to input, and JSON to output
// To run it:
// ballerina run demo.bal --config twitter.toml
// To invoke:
// curl -X POST -d "Demo" localhost:9090

import ballerina/http;
import wso2/twitter;
import ballerina/config;

endpoint twitter:Client twitter {
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

       // transformation on the way to the twitter service - add hashtag 
       if (!payload.contains("#ballerina")){payload=payload+" #ballerina";}

       twitter:Status st = check twitter->tweet(payload);

       // transformation on the way out - generate a JSON and pass it back
       // note that json is a first-class citizen
       // and we can construct it from variables, data, fields
       json myJson = {
           text: payload,
           id: st.id,
           agent: "ballerina"
       };
       // pass back JSON instead of text
       res.setJsonPayload(myJson);

       _ = caller->respond(res);
   } 
}