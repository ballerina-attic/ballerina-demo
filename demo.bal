import ballerina/net.http;
import wso2/twitter;
import ballerina/config;
import ballerina/time;

twitter:TwitterConnector twitter = {};

string foo = init();
function init() returns (string) {
    twitter.init(
           deNull(config:getAsString("consumerKey")),
           deNull(config:getAsString("consumerSecret")),
           deNull(config:getAsString("accessToken")),
           deNull(config:getAsString("accessTokenSecret"))
           );
    return "";
}

endpoint http:ServiceEndpoint listener {
    port:9090
};

@http:ServiceConfig {
    basePath: "/"
}
service<http:Service> demo bind listener {
    @http:ResourceConfig {
        methods: ["POST"],
        path: "/"
    }
    hello (endpoint caller, http:Request req) {

        string name = deNull( req.getStringPayload() );
        if ( name == "" ) { name = "World"; }

        http:Response response = {};
        response.setStringPayload("Hello " + name + "!");
        _ = caller -> respond(response);
    }

    @http:ResourceConfig {
        methods: ["POST"],
        path: "/tweet"
    }
    tweet (endpoint caller, http:Request req) {

        string status = deNull( req.getStringPayload() );

        if ( !status.contains("#ballerina")) { status = status + " #ballerina"; }

        http:Response response =? twitter.tweet(status);

        if ( response.statusCode == 200 ) {
            json jsonResponse =? response.getJsonPayload();
            json newJSON = {
                               "tweet" : jsonResponse.text,
                               "id" : jsonResponse.id,
                               "tweeterer" : "Ballerina"
                           };
            response.setJsonPayload(newJSON);
        }

        _ = caller -> respond(response);
    }


    @http:ResourceConfig {
        methods: ["POST"],
        path: "/quote"
    }
    quote (endpoint caller, http:Request req) {

        endpoint http:SimpleClientEndpoint homer {
            url:"http://www.simpsonquotes.xyz/"};

        http:Response res =? homer->get("/quote",{});

        string status = deNull( res.getStringPayload() );

        status=time:currentTime().format("hh:mm:ss: ")+status;

        http:Response response =? twitter.tweet(status);

        if ( response.statusCode == 200 ) {
            json jsonResponse =? response.getJsonPayload();
            json newJSON = {
                               "tweet" : jsonResponse.text,
                               "id" : jsonResponse.id,
                               "tweeterer" : "Ballerina"
                           };
            response.setJsonPayload(newJSON);
        }

        _ = caller -> respond(response);
    }


    @http:ResourceConfig {
        methods: ["POST"],
        path: "/quotefast"
    }
    quotefast (endpoint caller, http:Request req) {

        endpoint http:ClientEndpoint homer {
            circuitBreaker: {
                                failureThreshold:0,
                                resetTimeout:5000,
                                httpStatusCodes:[400, 404, 500]
                            },
            targets : [ {uri:"http://www.simpsonquotes.xyz/"}],
            endpointTimeout:1000
        };

        string status;

        var responseHomer = homer->get("/quote",{});

        match responseHomer {
            http:Response res => {
                status = deNull( res.getStringPayload() );
            }
            error err => {
                status = "Homer is speechless today!";
            }
        }

        status=time:currentTime().format("hh:mm:ss: ")+status;

        http:Response response =? twitter.tweet(status);

        if ( response.statusCode == 200 ) {
            json jsonResponse =? response.getJsonPayload();
            json newJSON = {
                               "tweet" : jsonResponse.text,
                               "id" : jsonResponse.id,
                               "tweeterer" : "Ballerina"
                           };
            response.setJsonPayload(newJSON);
        }

        _ = caller -> respond(response);
    }




}

function deNull (string | null | error input) returns (string) {
    match input {
        string sReturn => { return sReturn;}
        null | error => { return "Parameter not found";}
    }
}