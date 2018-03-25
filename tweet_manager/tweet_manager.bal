import ballerina/net.http;
import ballerina/io;

endpoint http:ServiceEndpoint listener {
    port:9090
};


// A ClientEndpoint can be used to invoke an external services
//endpoint http:SimpleClientEndpoint twitterStoreEp {
//    url:"http://localhost:6060"
//};


json previousRes;


endpoint http:ClientEndpoint twitterStoreEp {
    circuitBreaker: {
        failureThreshold:0.2,
        resetTimeout:10000,
        httpStatusCodes:[400, 404, 500]
    },
    targets: [{ uri: "http://localhost:6060"}],
    endpointTimeout:2000
};


@http:ServiceConfig {basePath:"/"}
service<http:Service> greeting bind listener {

    @http:ResourceConfig{
        path: "/tweet",  methods: ["POST"]
    }
    tweet (endpoint caller, http:Request request) {

        var reqPayloadVar = request.getStringPayload();
        string callerTweetMsg;
        match reqPayloadVar {
            string reqPayload => {
                callerTweetMsg = reqPayload;
            }
            any | null => {
                io:println("No payload found!");
            }
        }


        // *********
        // Tweeting Logic goes here
        // *********

        // Calling TweetStoring service
        var response = twitterStoreEp -> get("/customer", {});
        match response {
            http:Response res => {
                json customer =? res.getJsonPayload();
                json payload = { From: "Ballerina", time:customer};
                previousRes = payload;
                // Set the created JSON payload as the response message to the caller.
                res.setJsonPayload(payload);
                // Send response back to the caller.
                _ = caller -> forward(res);

            }
            http:HttpConnectorError err1 => {
                http:Response errResponse = {};
                errResponse.statusCode = 500;
                //errResponse.setStringPayload(err1.message);
                json errJ = {status:"Required services are unavailable.", cached_response:previousRes};
                errResponse.setJsonPayload(errJ);
                _ = caller -> respond(errResponse);
            }
        }
    }
}