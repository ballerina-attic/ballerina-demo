# Standard Ballerina Demo

Total time: 30-60 minutes (including slides) depending on whether you type it all or copy from the pre-created script files, how fast you can do it, how many questions you get asked, and so on.

Target audience: technical: meetups, technical customers/partners - this is a dev-level demo

# Prep / requirements

## Slide deck

[Ballerina Overview and Demo.pptx](https://docs.google.com/presentation/d/1yuixfusHrICWn6nxRobDEMjuWaHvn3qMJMzQnjNIkMk/edit?usp=sharing)

## Ballerina

Get the latest download from [ballerina.io](http://ballerina.io)

Currently tested on 0.975.0

Add Ballerina **bin** folder to your $PATH

Check it by opening the terminal window and running:

```
$ ballerina version
Ballerina 0.975.0
```

## VS Code

Install VS Code: [https://code.visualstudio.com/](https://code.visualstudio.com/)

Install Ballerina plug in into VS Code by importing the VSIX file:

![image alt text](img/image_0.png)

Make VS Code fonts larger:

* On Windows/Linux - File > Preferences > Settings
* On macOS - Code > Preferences > Settings

You are provided with a list of Default Settings. Copy any setting that you want to change to the appropriate settings.json file. The following are recommended (the SDK path will be different on your computer) - obviously the font size is whatever works best on your particular screen in your particular room with your particular audience:

```
{
   "window.zoomLevel": 0,
   "editor.fontSize": 24,
   "terminal.integrated.fontSize": 24,
   "ballerina.home": "/Users/DSotnikov/Ballerina/distro/"
}
```

![image alt text](img/image_1.png)

**IMPORTANT**:

* It is highly recommended that you set **Auto Save** in VS Code. It is very easy to forget to save the file before building and then wonder why your code is not working as expected.
![image alt text](img/image_2.png) 

## Docker

Install Docker with Kubernetes (this requires Edge edition with Kubernetes enabled): [https://blog.docker.com/2018/01/docker-mac-kubernetes/](https://blog.docker.com/2018/01/docker-mac-kubernetes/) 

Demo tested on:

![image alt text](img/image_3.png)

## Twitter

The demo is using Twitter account to send tweets.

If you know Dmitry and want to re-use his account [https://twitter.com/B7aDemo](https://twitter.com/B7aDemo) - get the corresponding twitter.toml config file from him.

Before starting your demo, delete all the old tweets - manually or by using **twitter_cleanup.bal** script that ships with the demo:

```
ballerina run twitter_cleanup.bal --config twitter.toml

curl -X DELETE localhost:9090/B7aDemo/0
```

![image alt text](img/image_4.png)

For your own Twitter account:

1. Set up the account (need to have a verified phone number in order to be used programmatically),
2. Go to [https://apps.twitter.com/](https://apps.twitter.com/)
3. Click the **Create New App** button and provide the info: ![image alt text](img/image_5.png)
4. In the app, go to the **Keys and Access Tokens** tab:
![image alt text](img/image_6.png)
5. Generate keys and tokens if you have not done that so.
6. In your demo folder, create file **twitter.toml** and put the keys and tokens that you get from the twitter apps UI:

```
# Ballerina demo config file
clientId = ""
clientSecret = ""
accessToken = ""
accessTokenSecret = ""
```

## Curl

Download from: [https://curl.haxx.se/download.html](https://curl.haxx.se/download.html) 

## Folders & Files

The structure described below is currently required by the VS Code plug-in to properly work. It makes it think that demo.bal is in the demo package. If you have multiple other files with different names or from other folders, you might lose code completion.

Create a new empty folder: e.g. Meetup-May-02-2018:

* Create two folders in it: .ballerina and demo (this is needed for VS Code tab completion to work properly, the latter folder should have the same name as the .bal file that you will be using),
* In the demo folder:
    * create demo.bal
    * Copy twitter.toml (see the Twitter section above),
    
Your folder structure should look like:

```
$ tree -a
.
├── .ballerina
└── demo
    ├── demo.bal
    └── twitter.toml
```

In the terminal window and in the VS Code terminal window go to your newly created folder and verify that you have the files:

```
$ cd demo
$ ls
demo.bal
twitter.toml
```

## Screens

Screen 1: Slides

Screen 2: VS Code: with two Terminal windows side by side: one to do build & run, and the other one to curl:

![image alt text](img/image_7.png)

Screen 3: browser with twitter (empty feed) & [http://www.simpsonquotes.xyz/quote](http://www.simpsonquotes.xyz/quote) 

## Before you start

**IMPORTANT: Before you start:**

* **Is the twitter feed empty?** Twitter may return an error if you try to tweet a message that it already has in the feed (e.g. from your previous demo).

* **Is twitter.toml file in your demo folder?** You will need it.

* **Is your Docker (& Kubernetes) running?**

* **Are there old artifacts from earlier demos in Kubernetes?** You should be getting:

```
  $ kubectl get pods
  No resources found.
```

# Intro slides

Stay close to the following text (the text is also in slides’ presenter notes):

### Slide 1 

Crazy customer demand has led to the rise of companies like Google, Uber, and Amazon. They have had to build complex systems to meet customer demand.  If you look at how those companies have evolved, they have increasingly disaggregated their architectures in order to scale. 

This is a continuation of a trend that we have seen over five decades. Massively disaggregated approaches like microservices, serverless, and APIs are becoming the norm for us all.

### Slide 2 (picture explains dealing with multiple endpoints is integration)
Integration in a disaggregate world

We have seen these disaggregated components become network accessible. We call them endpoints. Whether it is data, apps, APIs, microservices, or serverless functions, everything is becoming a programmable endpoint. The number of endpoints is exploding. 

### Slide 3 (Integration challenges)

The apps we will write increasingly depend on these endpoints. Integration is the discipline of resilient communication between endpoints. It isn’t easy. The challenges include compensation, transactions, events, circuit breakers, discovery, and protocol handling, and mediation. These are all hard problems. 

### Slide 4 part 1 (ESBs etc on the left)

There have been two ways to handle integration. 

One approach to scale integration has used integration products based on configuration, not code. We’ve created EAI, ESBs, XML configurations and DSLs, Business process workflow servers and many more.

### Slide 4 part 2 (box them with "not agile")

There’s only one problem. These approaches aren’t **agile. **They disrupt the edit, build, run, test cycle. And that isn’t the experience we desire as developers.

### Slide 4 part 3 (add the agile technologies)

The other way to do integration is with general purpose programming languages. These have developed to provide agility and to enhance developer workflow. 

### Slide 4 part 4 (box agile with "not integration simple")

With these programming languages, developers have to take responsibility for solving the hard problems of integration. They do this by writing their own integration logic or by using complex bolt-on frameworks. This approach is agile, but not **integration simple. **

### Slide 4 part 5 (integration gap)

That leads to our fundamental problem - you can have integration simple or agile, but not both. This is the **integration gap.** 

Our team has worked on thousands of integration projects over two decades. We’ve seen and used almost every integration technique out there.. Those projects have always ended up on one side or the other of the integration gap.

### Slide 5 - Ballerina

Three years ago, we set out to overcome this problem. The result is Ballerina. Ballerina is a programming language and a platform. We co-designed the runtime and language together: and we believe that this has created a new approach that is both agile and integration simple. Let’s take a look and see what that looks like.

# Demo

Each section has a bumper slide and a sequence diagram illustrating what you are going to implement in the demo. Use these to help the audience understand what to expect.

## Hello World

In the terminal pane of VS Code (or in the terminal window), inside the Demo folder, open the empty demo.bal that you created:

$ code demo.bal

This is the code that you need to type (or grab from 1_demo_hello.bal) and explanations for each line:

```ballerina
// The simplest hello world REST API
// To run it:
// ballerina run demo.bal
// To invoke:
// curl localhost:9090/hello/hi
// Ballerina has packages that can be imported
// This one adds services, endpoints, objects, and
// annotations for HTTP

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
```

In VS Code’s Terminal pane run:

```
$ ballerina run demo.bal
ballerina: initiating service(s) in 'demo.bal'
ballerina: started HTTP/WS endpoint 0.0.0.0:9090
```

Now you can invoke the service in the Terminal window:

```
$ curl localhost:9090/hello/hi
Hello World!
```

Side-by-side split view of the terminal pane makes it easier to do the demo:

![image alt text](img/image_8.png)

You now have a Hello World REST service running and listening on port 9090.

Go back to VS Code terminal pane and kill the service by pressing Ctrl-C.

Show the bumper slide of the next section.

## Annotations

Now, let’s tidy things up:

We want the service to just be there at the root path / - so let’s add ServiceConfig to overwrite the default base path (which is the service name). Add the following annotation right before the service:

```ballerina
@http:ServiceConfig {
   basePath: "/"
}
```

Make the resource available at the root as well and change methods to POST - we will pass some parameters!  

```ballerina
   @http:ResourceConfig {
       methods: ["POST"],
       path: "/"
   }
```

In the hello function, get the payload as string (filter out possible errors):

```ballerina
       string payload = check req.getTextPayload();
```

Then add the name into the output string:

```ballerina
      response.setPayload("Hello " + payload + "!\n");
```

Your final code should be (see comments for the new lines that you add at this stage):

```ballerina
// Add annotations for @ServiceConfig & @ResourceConfig
// to provide custom path and limit to POST
// Get payload from the POST request
// To run it:
// ballerina run demo.bal
// To invoke:
// curl -X POST -d "Demo" localhost:9090

import ballerina/http;

// Add this annotation to the service to change the base path
@http:ServiceConfig {
  basePath: "/"
}

service<http:Service> hello bind {port:9090} {

  // Add this annotation to the resource to change its path
  // and to limit the calls to POST only
  @http:ResourceConfig {
      path: "/",
      methods: ["POST"]
  }

  hi (endpoint caller, http:Request request) {

      // extract the payload from the request
      // getTextPayload actually returns a union of string | error
      // we will show how to handle the error later in the demo
      // for now, just use check that "removes" the error
      // (in reality, if there is error it will pass it up the caller stack)
      string payload = check request.getTextPayload();
      
      http:Response res;

      // use it in the response
      res.setPayload("Hello "+payload+"!\n");

      _ = caller->respond(res);
  }
}
```

Run it again and invoke this time as POST:

```
$ curl -X POST -d "Ballerina" localhost:9090
Hello Ballerina!
```

Summarize:

* Annotations are native and built-in - this is not some artificial add-on things but integral part of the language that lets you meaningfully tweak behavior and provide parameters,
* Full language helps you intuitively handle any required transformation (like handling the empty string in our case),
* Code completion and strong types help you easily locate the methods you need (such as getTextPayload) and use them,
* The whole power of HTTP, REST, WebSockets, gRPC, etc. is at your power.
* The edit / run / test iterations work great and keep us productive.

## Connectors

So far we have demoed the richness of creating web services, but there was no real integration. We’ve been in the integration space for a long time and we know that connectors are key to productivity allowing developers to work with various systems in a unified way with minimal learning curve.

Ballerina Central is the place where the Ballerina community is sharing those. WSO2 is one of the contributors. Let’s work with Twitter with the help of the WSO2/twitter package. Search for the package:

```
$ ballerina search twitter
```

Pull it so we start getting code completion (pulls also happen automatically on application build):

```
$ ballerina pull wso2/twitter
```

Explain, that if you do not do this and just import the package in the code, this is also fine (will be pulled on the first compilation) but we want to do this before we do coding so we get the richness of the code completion.

In the code, add:

```ballerina
import wso2/twitter;
```

Now, let’s create a twitter endpoint and initialize it. Twitter requires OAuth credentials that you can get from apps.twitter.com but placing them right into your code is a bad idea  (hint: so no one finds them on github!) so we’d rather read them from a configuration file. 

Import config so we can read from the config file:

```ballerina
import ballerina/config;
```

This code would be right below the import:

```ballerina
endpoint twitter:Client tw {
   clientId: config:getAsString("clientId"),
   clientSecret: config:getAsString("clientSecret"),
   accessToken: config:getAsString("accessToken"),
   accessTokenSecret: config:getAsString("accessTokenSecret"),
   clientConfig:{}   
};
```

Now we have the twitter endpoint in our hands, let’s go ahead and tweet!

Now, we can get our response from Twitter by just calling its tweet method. The check keyword means - I understand that this may return an error. I do not want to handle it hear - pass it further away (to the caller function, or if this is a top-level function - generate a runtime failure).

```ballerina
twitter:Status st = check tw->tweet(payload);
```

Your code will now look like this:

```ballerina
// Add twitter connector: import, create endpoint,
// create a new resource that invoke it
// To find it:
// ballerina search twitter
// To get it for tab completion:
// ballerina pull wso2/twitter
// To run it:
// ballerina run demo.bal --config twitter.toml
// To invoke:
// curl -X POST -d "Demo" localhost:9090

import ballerina/http;

// Pull and use wso2/twitter connector from http://central.ballerina.io
// It has the objects and APIs to make working with Twitter easy
import wso2/twitter;

// this package helps read config files
import ballerina/config;

// twitter package defines this type of endpoint
// that incorporates the twitter API.
// We need to initialize it with OAuth data from apps.twitter.com.
// Instead of providing this confidential data in the code
// we read it from a toml file
endpoint twitter:Client tw {
  clientId: config:getAsString("clientId"),
  clientSecret: config:getAsString("clientSecret"),
  accessToken: config:getAsString("accessToken"),
  accessTokenSecret: config:getAsString("accessTokenSecret"),
  clientConfig: {}  
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

      // Use the twitter connector to do the tweet
      twitter:Status st = check tw->tweet(payload);

      // Change the response back
      res.setPayload("Tweeted: " + st.text);

      _ = caller->respond(res);
  }
}
```

Go ahead and run it and this time pass the config file:

```
$ ballerina run demo.bal --config twitter.toml
```

Demo the empty twitter timeline:

![image alt text](img/image_9.png)

Now go to the terminal window and pass a tweet:

```
$ curl -X POST -d "Ballerina" localhost:9090
Tweeted: Ballerina
```

Let’s go ahead and check out the feed:

![image alt text](img/image_10.png)

Very cool. In just a few lines of code our twitter integration started working!

Now let’s go back to code and make it even more cool by adding transformation logic. This is a very frequent task in integration apps because the format that your backend exposes and returns is often different from what the application or other services need.

We will add transformation logic both on the way to the twitter service and back from the remote service to the caller.

On the way to Twitter, if the string lacks #ballerina hashtag - let’s add it. With the full Turing-complete language and string functions this is as easy as:

```ballerina
if (!payload.contains("#ballerina")){payload=payload+" #ballerina";}
```

And obviously it makes sense to return not just a string but a meaningful JSON with the id of the tweet, etc. This is easy with Ballerina’s native json type:

```ballerina
      json myJson = {
          text: payload,
          id: st.id,
          agent: "ballerina"
      };

      res.setPayload(myJson);
```

Go ahead and run it:

```
$ ballerina run demo.bal --config twitter.toml
ballerina: initiating service(s) in 'demo.bal'
ballerina: started HTTP/WS endpoint 0.0.0.0:9090
```

Now we got a much nicer JSON:

```
$ curl -d "My new tweet" -X POST localhost:9090
{"text":"My new tweet #ballerina","id":978399924428550145,"agent":"ballerina"}
```

![image alt text](img/image_11.png)

Now your code will look like:

```ballerina
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

      // transformation on the way to the twitter service - add hashtag
      if (!payload.contains("#ballerina")){payload=payload+" #ballerina";}

      twitter:Status st = check tw->tweet(payload);

      // transformation on the way out - generate a JSON and pass it back
      // note that json is a first-class citizen
      // and we can construct it from variables, data, fields
      json myJson = {
          text: payload,
          id: st.id,
          agent: "ballerina"
      };

      // pass back JSON instead of text
      res.setPayload(myJson);

      _ = caller->respond(res);
  }
}
```

To summarize:
* Using a connector made interaction with an external service a breeze,
* Native json is superpowerful - any other languages having all the modern web formats and protocols built in? ;)
* Full language makes it really easy to handle logic branching, data transformation and so on.

## Kubernetes

Now, what kind of cloud-native programming language would it be without native support for the modern microservices platforms? Ballerina has native built-in support for both docker and Kubernetes.

We will just add a few annotations and get it running in the Kubernetes!

First, as usual add the corresponding package:

```ballerina
import ballerinax/kubernetes;
```

Add generation of Kubernetes artifacts to the **service**:

```ballerina
@kubernetes:Deployment {
   image: "demo/ballerina-demo",
   name: "ballerina-demo"
}
```

<table>
  <tr>
    <td>Special Note for minikube users on ubuntu: You need to add the minikube host and certs path under "Deployment" annotation.

```ballerina
@kubernetes:Deployment {
    image: "demo/ballerina-demo",
    name: "ballerina-demo",
    dockerHost:"tcp://192.168.99.100:2376", 
    dockerCertPath:"/home/chanaka/.minikube/certs"
}
```
       
     </td>
  </tr>
</table>


Right under that annotation, add another one to pass our config (the one with the Twitter keys):

```ballerina
@kubernetes:ConfigMap{
   ballerinaConf:"twitter.toml"
}
```

This creates a docker image and a deployment into which it puts it.

And we also need to create an http listener and tell Kubernetes to expose it externally:

```ballerina
@kubernetes:Service {
  serviceType: "NodePort",
  name: "ballerina-demo"   
}

endpoint http:Listener listener {
   port : 9090
};
```

Obviously, the service now needs to be bound to that listener and not just inline anonymous declaration:

```ballerina
service<http:Service> hello bind listener {
```

Your code should now look like this:

```ballerina
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

endpoint twitter:Client tw {
  clientId: config:getAsString("clientId"),
  clientSecret: config:getAsString("clientSecret"),
  accessToken: config:getAsString("accessToken"),
  accessTokenSecret: config:getAsString("accessTokenSecret"),
  clientConfig:{}  
};

// Now instead of inline {port:9090} bind we create a separate endpoint
// We need this so we can add Kubernetes notation to it and tell the compiler
// to generate a Kubernetes services (expose it to the outside world)
@kubernetes:Service {
  serviceType: "NodePort",
  name: "ballerina-demo" 
}
endpoint http:Listener listener {
  port: 9090
};

// Instruct the compiler to generate Kubernetes deployment artifacts
// and a docker image out of this Ballerina service
@kubernetes:Deployment {
  image: "demo/ballerina-demo",
  name: "ballerina-demo"
}

// Pass our config file into the image
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
      string payload = check request.getTextPayload();
      if (!payload.contains("#ballerina")){payload=payload+" #ballerina";}
      
      twitter:Status st = check tw->tweet(payload);

      json myJson = {
          text: payload,
          id: st.id,
          agent: "ballerina"
      };

      res.setPayload(myJson);
      _ = caller->respond(res);
  }
}
```

That is it - let’s go ahead and build it:

```
$ ballerina build demo.bal
@kubernetes:Service                      - complete 1/1
@kubernetes:ConfigMap                    - complete 1/1
@kubernetes:Docker                       - complete 3/3
@kubernetes:Deployment                   - complete 1/1
```

Run following command to deploy kubernetes artifacts:

```
kubectl apply -f /Users/DSotnikov/Ballerina/Projects/apr-23/demo/kubernetes/
```

You can see that it created a folder called kubernetes and put the deployment artifacts and the docker image in there:

```
$ tree
.
├── demo.bal
├── demo.balx
├── kubernetes
│   ├── demo_config_map.yaml
│   ├── demo_deployment.yaml
│   ├── demo_svc.yaml
│   └── docker
│       └── Dockerfile
└── twitter.toml
```

And you can deploy it to Kubernetes:

```
$ kubectl apply -f kubernetes/
configmap "hello-ballerina-conf-config-map" created
deployment "ballerina-demo" created
service "ballerina-demo" created
```

Let’s see if it is running:

```
$ kubectl get pods
NAME                              READY     STATUS    RESTARTS   AGE
ballerina-demo-74b6fb687c-mbrq2   1/1       Running   0          10s

$ kubectl get svc
NAME             TYPE        CLUSTER-IP    EXTERNAL-IP   PORT(S)  AGE
ballerina-demo   NodePort    10.98.238.0   <none>        9090:**31977**/TCP  24s
kubernetes       ClusterIP   10.96.0.1     <none>        443/TCP  2d
```

We can now go ahead and invoke the service - I am using local Kubernetes but the same behavior would happen in the cloud one. Using the port 31977 that Kubernetes gave me:

```
$ curl -d "Tweet from Kubernetes" -X POST  http://localhost:**31977**
{"text":"Tweet from Kubernetes #ballerina", "id":978399924428550145, "agent":"Ballerina"}
```
 
<table>
  <tr>
    <td>If you are running on minikube with ubuntu, you need to use the minikube ip to send the curl request.

```
$ curl -d "Tweet from Kubernetes" -X POST  http://192.168.99.100:31977
{"text":"Tweet from Kubernetes #ballerina", "id":978399924428550145, "agent":"Ballerina"}
```

</td>
  </tr>
</table>


Now delete the Kubernetes deployment:

```
$ kubectl delete -f kubernetes/
deployment "ballerina-demo" deleted
service "ballerina-demo" deleted
```

Summary:
* With built in Kubernetes and Docker support, the corresponding images and artifacts simply get generated as part of the build process!

## Observability

Just talk to the slides about how observability: monitoring, metrics, tracing, logs - is built-in. You just add some configuration and can use tools like Jaeger, Prometheus/Grafana, ElasticSearch/LogStash/Kibana with Ballerina.

## Circuit Breaker

For the remainder of the demo, we will do copying and pasting from slide notes to make things go faster.

To demonstrate more advanced integration logic, let’s take it a step further and use an external public web API to integrate with Twitter.

How about instead of tweeting ourselves, we will just pass a quote from Homer Simpson?

We will use [http://www.simpsonquotes.xyz/quote](http://www.simpsonquotes.xyz/quote) to do that!

For ease (and speed) of the demo, we base the changes on the pre-Kubernetes code and make the demos local (to cut time on regenerating and redeploying the images).

We have added an endpoint to represent the external service:

```ballerina
endpoint http:Client homer {
 url: "http://www.simpsonquotes.xyz"
};
```

And we use that endpoint (and not the payload) to get the status for our tweet:

```ballerina
     http:Response hResp = check homer->get("/quote");
     string payload = check hResp.getTextPayload();
```

Your code will now look like:

```ballerina
// Add another external web service endpoint
// to compensate for slowness use circuit breaker
// To run it:
// ballerina run demo.bal --config twitter.toml
// To invoke:
// curl -X POST localhost:9090
// Invoke a few times to show that it is often slow

import ballerina/http;
import wso2/twitter;
import ballerina/config;

// create an endpoint for the external web service to use
endpoint http:Client homer {
 url: "http://www.simpsonquotes.xyz"
};

endpoint twitter:Client tw {
 clientId: config:getAsString("clientId"),
 clientSecret: config:getAsString("clientSecret"),
 accessToken: config:getAsString("accessToken"),
 accessTokenSecret: config:getAsString("accessTokenSecret"),
 clientConfig: {} 
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

// Call the remote service and get the payload from it and not the request
     http:Response hResp = check homer->get("/quote");
     string payload = check hResp.getTextPayload();

     if (!payload.contains("#ballerina")){payload=payload+" #ballerina";}

     twitter:Status st = check tw->tweet(payload);

     json myJson = {
         text: payload,
         id: st.id,
         agent: "ballerina"
     };

     res.setPayload(myJson);
     _ = caller->respond(res);
 }
}
```

Now we can quote Homer on Twitter:

```
$ curl -X POST localhost:9090
{"text":"It’s not easy to juggle a pregnant wife and a troubled child, but somehow I managed to fit in eight hours of TV a day.","id":978405287928348672,"agent":"Ballerina"} 
$ curl -X POST localhost:9090
{"text":"Just because I don’t care doesn’t mean that I don’t understand.","id":978405308232957952,"agent":"Ballerina"}
```

Now you may notice that roughly half of the time this is taking a long time. This is because we have implemented that remote simpson quote service to be not reliable and take about 5 seconds to respond in half of the invocations.

This simulates typical situation when you rely upon an external service but it is not reliable.

When an external service gets overly busy and unresponsive, one popular strategy to handle that is not to wait till it responds but just drop the call, provide default handling, and suspend using the endpoint until it recovers.

This pattern is called Circuit Breaker - and Ballerina has it built in natively - not need to use external frameworks, service ashes, etc.:
* If certain percentage of failures occur, the system stops invoking the remote endpoint and instead invokes its "plan B" logic for some time (allowing the remote endpoint to recover in case it is overloaded),
* There is a time period during which only that "Plan B" logic is used,
* After that time period, Circuit Breaker sends a new request to the remote endpoint to check whether or not it has recovered.

That Simpson service that we use is sometimes very slow. Let’s put a Circuit Breaker around it.

We make the endpoint initialization include circuit breaker logic:

```ballerina
endpoint http:Client homer {
 url: "http://www.simpsonquotes.xyz",
 circuitBreaker: {
     failureThreshold: 0,
     resetTimeMillis: 3000,
     statusCodes: [500, 501, 502]
 },
 timeoutMillis: 500
};
```

And the handling changes to:

```ballerina
var v = homer->get("/quote");

match v {
   http:Response hResp => {
       string payload = check hResp.getTextPayload();
       if (!payload.contains("#ballerina")){payload=payload+" #ballerina";}
       twitter:Status st = check tw->tweet(payload);

       json myJson = {
           text: payload,
           id: st.id,
           agent: "ballerina"
       };
       res.setPayload(myJson);
   }
   error err => {
       res.setPayload("Circuit is open. Invoking default behavior.\n");
   }
}
```

Notice how match provides us with the ability to have error handling and define the behavior both for the happy path and for the failure.

Also, in our case the failure path will get invoked not only when the actual failure or 0.5 second timeout occurs but also for 3 seconds after that - while the Circuit Breaker is in the Open state.

Full code:

```ballerina
// To compensate for slowness use circuit breaker
// To run it:
// ballerina run demo_circuitbreaker.bal --config twitter.toml
// To invoke:
// curl -X POST localhost:9090
// Invoke many times to show how circuit breaker works

import ballerina/http;
import wso2/twitter;
import ballerina/config;

// Change the endpoint initialization to add timeout (half-send)
// and circuit breaker logic
endpoint http:Client homer {
 url: "http://www.simpsonquotes.xyz",
 circuitBreaker: {
     failureThreshold: 0,
     resetTimeMillis: 3000,
     statusCodes: [500, 501, 502]
 },
 timeoutMillis: 500
};

endpoint twitter:Client tw {
 clientId: config:getAsString("clientId"),
 clientSecret: config:getAsString("clientSecret"),
 accessToken: config:getAsString("accessToken"),
 accessTokenSecret: config:getAsString("accessTokenSecret"),
 clientConfig: {} 
};

@http:ServiceConfig {
 basePath: "/"
}
service<http:Service> hello bind {port: 9090} {

 @http:ResourceConfig {
     path: "/",
     methods: ["POST"]
 }
 hi (endpoint caller, http:Request request) {
     http:Response res;
     
     // use var as a shorthand for http:Response | error union type
     // Compiler is smart enough to use the actual type
     var v = homer->get("/quote");

     // match is the way to provide different handling of error vs normal output
     match v {
         http:Response hResp => {

             // if proper http response use our old code
             string payload = check hResp.getTextPayload();
             if (!payload.contains("#ballerina")){payload=payload+" #ballerina";}
             twitter:Status st = check tw->tweet(payload);
             json myJson = {
                 text: payload,
                 id: st.id,
                 agent: "ballerina"
             };
             res.setPayload(myJson);
         }
         error err => {
             // this block gets invoked if there is error or if circuit breaker is Open
             res.setPayload("Circuit is open. Invoking default behavior.\n");
         }
     }
     _ = caller->respond(res);
 }
}
```

 Let’s go ahead and invoke. Notice how not only an error/timeout leads to our default handler ("Circuit is open. Invoking default behavior.") - but how the next few calls after it (next 3 seconds in our case) are automatically using that path without invoking the backend:

```
$ curl -X POST localhost:9090
{"text":"Marge, don't discourage the boy! Weaseling out of things is important to learn. It's what separates us from the animals! Except the weasel. #ballerina","id":986740441532936192,"agent":"ballerina"}

$ curl -X POST localhost:9090
Circuit is open. Invoking default behavior.

$ curl -X POST localhost:9090
Circuit is open. Invoking default behavior.

$ curl -X POST localhost:9090
{"text":"Marge, don't discourage the boy! Weaseling out of things is important to learn. It's what separates us from the animals! Except the weasel. #ballerina","id":986740441532936192,"agent":"ballerina"}
```

Summary:
* Ballerina has all the integration and resiliency patterns built in: message broker, asynchronous calls, distributed transactions, automated retries, and so on,
* We have used just one of these patterns - Circuit Breaker and this was a matter of just adding some annotations,
* Unlike external frameworks and meshes, having these mechanisms built in is a huge advantage because you can - right in the code! - properly handle the failures and provide the required logic. External frameworks have no visibility into what your code is trying to accomplish.

## Asynchronous Execution

Circuit Breaker is not the only way to deal with slow or unreliable endpoints. Ballerina also has built-in retries, compensation logic, distributed transactions, and asynchronous execution.

In this particular case, the remote endpoint is often very slow, so why not just call it asynchronously and let the actual execution take as long as it needs to.

We move all the logic to a function (can leave it as it was or simplify by removing all the error handling and constructing and passing the response - this will be an asynchronous call so we do not care about the response):

```ballerina
function doTweet() {
   http:Response hResp = check homer->get("/quote");
   string payload = check hResp.getTextPayload();
   if (!payload.contains("#ballerina")){ payload = payload+" #ballerina";}
   _ = tw->tweet(payload);
}
```

Our endpoint no longer needs circuit breaker:

```ballerina
endpoint http:Client homer {
   url:"http://www.simpsonquotes.xyz"
};
```

And we use the start keyword to invoke the function in a separate thread asynchronously:

```ballerina
 hi (endpoint caller, http:Request request) {
     _ = start doTweet();
     http:Response res;
     res.setPayload("Async call\n");     
     _ = caller->respond(res);
 }
 ```

Your full code now looks like:

```ballerina
// Move all the invocation and tweeting functionality to another function
// call it asynchronously
// To run it:
// ballerina run demo_async.bal --config twitter.toml
// To invoke:
// curl -X POST localhost:9090
// Invoke many times to show how quickly the function returns
// then go to the browser and refresh a few times to see how gradually new tweets appear

import ballerina/http;
import wso2/twitter;
import ballerina/config;

endpoint twitter:Client tw {
 clientId: config:getAsString("clientId"),
 clientSecret: config:getAsString("clientSecret"),
 accessToken: config:getAsString("accessToken"),
 accessTokenSecret: config:getAsString("accessTokenSecret"),
 clientConfig: {} 
};

endpoint http:Client homer {
 url: "http://www.simpsonquotes.xyz"
};

@http:ServiceConfig {
 basePath: "/"
}
service<http:Service> hello bind {port: 9090} {

 @http:ResourceConfig {
     path: "/",
     methods: ["POST"]
 }

 hi (endpoint caller, http:Request request) {
 
     // start is the keyword to make the call asynchronously
     _ = start doTweet();

     http:Response res;

     // just respond back with the text
     res.setPayload("Async call\n");     

     _ = caller->respond(res);
 }
}

// Move the logic of getting the quote and pushing it to twitter
// into a separate function to be called asynchronously.
function doTweet() {
   // We can remove all the error handling here because we call
   // it asynchronously, don't want to get any output and
   // don't care if it takes too long or fails
   http:Response hResp = check homer->get("/quote");
   string payload = check hResp.getTextPayload();
   if (!payload.contains("#ballerina")){ payload = payload+" #ballerina"; }
   _ = tw->tweet(payload);
}
```

Now we can just quickly call it 10 times in a row:

```
$ curl -X POST localhost:9090
Async call
$ curl -X POST localhost:9090
Async call
$ curl -X POST localhost:9090
Async call
$ curl -X POST localhost:9090
Async call
$ curl -X POST localhost:9090
Async call
$ curl -X POST localhost:9090
Async call
$ curl -X POST localhost:9090
Async call
$ curl -X POST localhost:9090
Async call
```

And then go to the twitter browser window, keep refreshing it and seeing new tweets still coming.

## Swagger

API management is an important part of modern architectures and comes standard with Ballerina.

It includes ability to use external API gateways or built-in microgateway with security policies such as basic authentication, OAuth, and scopes.

It also knows Swagger - can generate services based on Swagger and export interfaces as Swagger.

To generate Swagger definition of our service simply run:

```
$ ballerina swagger export demo.bal
successfully generated swagger definition for input file - demo.bal

$ ls
ballerina-internal.log  demo.swagger.yaml
demo.bal                kubernetes
demo.balx               twitter.toml
```

Now open the yaml and observe the service and two resources:

```
$ code demo.swagger.yaml
```


## Sequence Diagrammatic

Sequence diagrams have proven to be the best way to document integration projects (remember how we have been using them to illustrate each and every stage of this demo in the slide deck?) 

Ballerina’s syntax is designed around sequence diagrams, and subsequently the way a developer thinks when writing Ballerina code encourages strong interaction best practices.

Ballerina tooling is making understanding the projects easier by automatically generating sequence diagrams for your code. In VS Code, click the **Ballerina: Show Diagram** button at the top right: ![Ballerina Show Diagram button](img/image_12.png)

Here's the automated diagram that Ballerina generated for the doTweet function that we just used:

![Integration project sequence diagram generayed by Ballerina](img/image_13.png)


# Exit slides

* Summarize what we have seen, 
* If appropriate, talk about the differences from Spring in case of the integration scenarios,
* Talk about the place of Ballerina in the overall stack, mention transactions, Ballerina bridge, etc.
* Talk about the features that we didn’t have time to demo and give a call to action.


