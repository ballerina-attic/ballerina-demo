# Ballerina - Demo Sample


## Hello Service 

Sample request: 

``` 
curl -v -X POST -d 'Ballerina' "http://localhost:9090/hello"

``` 


## Demo Script

### Hello World 
- Create Hello Service and implement the logic inside the resource '/hello'. 


### Tweeting 
- Extend the service to anther resource called '/tweet'. 
- Import Twitter connector and completing the tweeting use case. 


### Saving Tweets to a DB
- Use pre-built twitter-save DB connector to save Tweets to a database. 
- Can glance through the twitter-save DB connector and use it inside our code. 


### Deploy on Docker/K8s 

- Deploy the service on K8s


 