// The simplest hello world REST API
// To run it:
// ballerina run demo.bal
// To invoke:
// curl localhost:9090/hello/hi

import ballerina/http;

// Services, endpoint, resources are built into the language
// This one is HTTP (other options include WebSockets, Protobuf, gRPC, etc)
// We bind it to port 9090
service<http:Service> hello bind {port:9090} {

  // The service exposes one resource (hi)
  // It gets the endpoint that called it - so we can pass response back
  // and the request struct to extract payload, etc.
   hi (endpoint caller, http:Request request) {
        // Create the Response object
        http:Response res;
        // Put the data into it
        res.setPayload("Hello World!\n");
        // Send it back. -> means remote call (. means local)
        // _ means ignore the value that the call returns
        _ = caller->respond(res);
   }
}