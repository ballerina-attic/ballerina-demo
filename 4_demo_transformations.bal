// Add twitter connector: import, create endpoint,
// create a new resource that invoke it
// To find it:
// ballerina search twitter
// To get it for tab completion:
// ballerina pull wso2/twitter
// To run it:
// ballerina run --config twitter.toml demo.bal
// To invoke:
// curl -X POST -d "Demo" localhost:9090

// this package helps read config files
import ballerina/config;
import ballerina/http;
// Pull and use wso2/twitter connector from http://central.ballerina.io
// It has the objects and APIs to make working with Twitter easy
import wso2/twitter;


// Twitter package defines this type of endpoint
// that incorporates the twitter API.
// We need to initialize it with OAuth data from apps.twitter.com.
// Instead of providing this confidential data in the code
// we read it from a toml file.
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
        http:Response res = new;
        // Pass back JSON instead of text.
        res.setPayload(untaint myJson);

        _ = check caller->respond(res);
        return;
    }
}
