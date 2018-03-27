package demo.tweet.store;

import ballerina/net.http;
import ballerina/data.sql;
import ballerina/runtime;
import ballerina/log;
import ballerina/io;

struct TweetSaveConfig {
    string name;
    string path;
}

struct TweetSaveEP {
    sql:Client sqlClient;
}

function <TweetSaveEP ep> init (TweetSaveConfig conf) {
    endpoint  sql:Client dbSQLClient  {
        database:sql:DB.H2_FILE,
        host:conf.path,
        name:conf.name,
        options:{maximumPoolSize:5}
    };
    ep.sqlClient = dbSQLClient;
}

function <TweetSaveEP ep> getClient () returns (TweetSaveClient) {
    return {customerDB:ep};
}

struct TweetSaveClient {
    TweetSaveEP customerDB;
}


function <TweetSaveClient client> persist (string content, string tweeterId) returns boolean |error {
    endpoint sql:Client localClient = client.customerDB.sqlClient;
    sql:Parameter[] params = [];
    sql:Parameter para1 = {sqlType : sql:Type.VARCHAR, value : content};
    sql:Parameter para2 = {sqlType : sql:Type.VARCHAR, value : tweeterId};
    params = [para1, para2];
    io:println("persist 1");

    var ret = localClient -> update("INSERT INTO TWEET_STORE (CONTENT, TWEET_ID) VALUES (?,?)", params);

    match ret {
        int rows => {
            io:println("Inserted row count:" + rows);
        }
        sql:SQLConnectorError err => {
            io:println("Insertion  failed:" + err.message);
            return false;
        }
    }
    io:println("persist 2");

    return true;
}

function <TweetSaveClient client> getAllTweets () returns json |error {
    endpoint sql:Client localClient = client.customerDB.sqlClient;

    table dt =? localClient -> select("SELECT * FROM TWEET_STORE", null, null);
    var response = <json>dt;
    return response;
}

