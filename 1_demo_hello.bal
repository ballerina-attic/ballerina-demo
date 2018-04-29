// The simplest hello world REST API
// To run it:
// ballerina run demo.bal
// To invoke:
// curl localhost:9090/hello/hi

import ballerina/http;

service<http:Service> hello bind {port:9090} {
   hi (endpoint caller, http:Request request) {
       http:Response res;
       res.setPayload("Hello World!\n");
       _ = caller->respond(res);
   }
}