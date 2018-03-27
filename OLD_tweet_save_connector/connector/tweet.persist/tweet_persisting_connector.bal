package tweet.persist;

import ballerina.util.arrays;
import ballerina.net.http;
import ballerina.net.uri;
import ballerina.util;
import ballerina/data.sql;



struct TweetSaveConfig {
    string name;
    string path;
}

struct TweetSaveEP {

    //http:ClientEndpoint httpClient;
    sql:Client sqlClient;
}

function <TweetSaveEP ep> init (TweetSaveConfig conf) {
    // endpoint http:ClientEndpoint httpEP {targets:[{uri:conf.url}]};
    endpoint  sql:Client dbSQLClient  {
             database:sql:DB.H2_FILE,
             host:conf.path,
             port:10,
             name:conf.name,
             //username:"root",
             //password:"root",
             options:{maximumPoolSize:5}
     };
    sqlClient = dbSQLClient;
}

function <TweetSaveEP ep> getClient () returns (TweetSaveClient) {
    return {clientEP:ep};
}

struct TweetSaveClient {
    TweetSaveEP customerDB;
}



function <TweetSaveClient client> persist (string content, json content) returns boolean |error {

    sql:Parameter[] params = [];
    sql:Parameter para1 = {sqlType : sql:Type.VARCHAR, value : content};
    sql:Parameter para2 = {sqlType : sql:Type.INTEGER, value : content};
    params = [para1, para2];

    int update_row_cnt =? customers_db -> update("INSERT INTO TWEET_STORE (CONTENT, TWEET_ID) VALUES (?,?)", params);

    log:printInfo("Inserted row count:" + update_row_cnt);

    return true;
}


