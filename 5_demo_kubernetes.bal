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
import ballerinax/kubernetes;

endpoint twitter:Client twitter {
   clientId: config:getAsString("clientId"),
   clientSecret: config:getAsString("clientSecret"),
   accessToken: config:getAsString("accessToken"),
   accessTokenSecret: config:getAsString("accessTokenSecret"),
   clientConfig:{}   
};

@kubernetes:Service {
 serviceType: "NodePort",
 name: "ballerina-demo"  
}
endpoint http:Listener listener {
  port: 9090
};

@kubernetes:Deployment {
 image: "demo/ballerina-demo",
 name: "ballerina-demo"
}
@kubernetes:ConfigMap{
   ballerinaConf: "twitter.toml"
}
@http:ServiceConfig {
  basePath: "/"
}
service<http:Service> hello bind listener {
   @http:ResourceConfig {
       path: "/",
       methods: ["POST"]
   }
   hi (endpoint caller, http:Request request) {
       http:Response res;
       string status = check request.getTextPayload();

       if (!status.contains("#ballerina")){status=status+" #ballerina";}

       twitter:Status st = check twitter->tweet(status);

       json myJson = {
           text: status,
           id: st.id,
           agent: "ballerina"
       };
      
       res.setJsonPayload(myJson);

       _ = caller->respond(res);
   } 
}