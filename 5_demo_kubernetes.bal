// Add kubernetes package and annotations
// To build kubernetes artifacts:
// ballerina build demo.bal
// To run it:
// kubectl apply -f kubernetes/
// To see the pod:
// kubectl get pods
// To see the service:
// kubectl get svc
// To invoke:
// curl -X POST -d "Hello from K8S" localhost:<put the port that you get from kubectl get svc>
// To clean up:
// kubectl delete -f kubernetes/

import ballerina/http;
import wso2/twitter;
import ballerina/config;
// Add kubernetes package
import ballerinax/kubernetes;

twitter:Client tw = new({
        clientId: config:getAsString("clientId"),
        clientSecret: config:getAsString("clientSecret"),
        accessToken: config:getAsString("accessToken"),
        accessTokenSecret: config:getAsString("accessTokenSecret"),
        clientConfig:{}
    });

// Now instead of inline {port:9090} bind we create a separate endpoint.
// We need this so we can add Kubernetes notation to it and tell the compiler
// to generate a Kubernetes services (expose it to the outside world).
@kubernetes:Service {
    serviceType: "NodePort",
    name: "ballerina-demo"
}
listener http:Listener cmdListener = new(9090);

// Instruct the compiler to generate Kubernetes deployment artifacts
// and a docker image out of this Ballerina service.
@kubernetes:Deployment {
    image: "demo/ballerina-demo",
    name: "ballerina-demo"
}
// Pass our config file into the image.
@kubernetes:ConfigMap{
    ballerinaConf: "twitter.toml"
}
@http:ServiceConfig {
    basePath: "/"
}
service hello on cmdListener {
    @http:ResourceConfig {
        path: "/",
        methods: ["POST"]
    }
    resource function hi (http:Caller caller, http:Request request) {
        var payload = request.getTextPayload();
        if (payload is string) {
            if (!payload.contains("#ballerina")) {
                payload = payload + " #ballerina";
            }

            var st = tw->tweet(payload);
            if (st is twitter:Status) {
                json myJson = {
                    text: payload,
                    id: st.id,
                    agent: "ballerina"
                };

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