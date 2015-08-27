//
//  NetworkModel.m
//  ConnectAndLogin
//
//  Created by wanglongyan on 15/6/10.
//  Copyright (c) 2015年 svs. All rights reserved.
//

#import "NetworkModel.h"

//#define URL_SERVER @"https://192.168.0.110:8080"
#define URL_SERVER @"http://127.0.0.1:8080"

static NetworkModel * instanceNetworkModel;
@interface NetworkModel ()
{

}
@end

@implementation NetworkModel
+(instancetype)sharedNetworkModel
{
    if (instanceNetworkModel == nil) {
        instanceNetworkModel = [[NetworkModel alloc] init];
    }
    return instanceNetworkModel;
}

- (instancetype)init
{
    self = [super init];
    if (self) {

    }
    return self;
}

-(void)dealloc
{
    [super dealloc];
}

#pragma mark - inner function / interface
-(void)getRequest:(NSString *)url
       parameters:(id)parameters
          success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
          failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    AFHTTPRequestOperationManager * manager = [AFHTTPRequestOperationManager manager];
    [manager.securityPolicy setAllowInvalidCertificates:YES];
    [manager setRequestSerializer:[AFJSONRequestSerializer serializer]];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/html", nil];
    [manager GET:url parameters:parameters success:success failure:failure];
}

-(void)postRequest:(NSString *)url
        parameters:(id)parameters
           success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
           failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    AFHTTPRequestOperationManager * manager = [AFHTTPRequestOperationManager manager];
    [manager.securityPolicy setAllowInvalidCertificates:YES];
    [manager setRequestSerializer:[AFJSONRequestSerializer serializer]];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/html", nil];
    [manager POST:url parameters:parameters success:success failure:failure];
}


#pragma mark - user interface
-(void)requestLoginWithName:(NSString *)name password:(NSString *)pwd suc:(void (^)(id))success fail:(void (^)(NSError *))failure
{
    NSString * url = [URL_SERVER stringByAppendingString:@"/login"];
    [self postRequest:url
           parameters:@{
                        @"name" : name,
                        @"password" : pwd
                        }
             success:^(AFHTTPRequestOperation *operation, id responseObject) {
                 success(responseObject);
             }
             failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                 failure(error);
             }];
}

-(void)requestAddFriend:(NSString *)targetId myID:(NSString *)myID suc:(void (^)(id))success fail:(void (^)(NSError *))failure
{
    NSString * url = [URL_SERVER stringByAppendingString:@"/addFriend"];
    [self postRequest:url
           parameters:@{
                        @"targetID" : targetId,
                        @"myID" : myID
                        }
              success:^(AFHTTPRequestOperation *operation, id responseObject) {
                  success(responseObject);
              }
              failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                  failure(error);
              }];
    
}

-(void)requestSearchFriend:(NSString *)targetId suc:(void (^)(id))success fail:(void (^)(NSError *))failure
{
    NSString * url = [URL_SERVER stringByAppendingString:@"/searchFriend"];
    [self postRequest:url
           parameters:@{
                        @"targetID" : targetId
                        }
              success:^(AFHTTPRequestOperation *operation, id responseObject) {
                  success(responseObject);
              }
              failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                  failure(error);
              }];
}

-(void)requestFriendList:(NSString *)targetId suc:(void (^)(id))success fail:(void (^)(NSError *))failure
{
    NSString * url = [URL_SERVER stringByAppendingString:@"/getMyFriendsList"];
    [self postRequest:url
           parameters:@{
                        @"targetID" : targetId
                        }
              success:^(AFHTTPRequestOperation *operation, id responseObject) {
                  success(responseObject);
              }
              failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                  failure(error);
              }];
}

-(void)requestUserBriefInfo:(id)userIDs suc:(void (^)(id))success fail:(void (^)(NSError *))failure
{
    NSString * url = [URL_SERVER stringByAppendingString:@"/getUserBriefInfo"];
    [self postRequest:url
           parameters:@{
                        @"userIDs" : userIDs
                        }
              success:^(AFHTTPRequestOperation *operation, id responseObject) {
                  success(responseObject);
              }
              failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                  failure(error);
              }];
}

#pragma mark - message interface
-(void)requestSendMessageWithToID:(NSString *)toID formID:(NSString *)fromId messageType:(NSString *)type content:(NSString *)content contentURL:(NSString *)contentUrl suc:(void (^)(id))success fail:(void (^)(NSError *))failure
{
    if (!toID || !fromId || !type || !(content || contentUrl)) {
        return;
    }
    
    if (content == nil) {
        content = @"";
    }
    
    if (contentUrl == nil) {
        contentUrl = @"";
    }
    
    NSString * url = [URL_SERVER stringByAppendingString:@"/sendMsg"];
    [self postRequest:url
           parameters:@{
                        @"msg" : @{
                                @"from" : fromId,
                                @"to" : toID,
                                @"chattype" : type,
                                @"content" : content,
                                @"url" : contentUrl
                                }
                        }
              success:^(AFHTTPRequestOperation *operation, id responseObject) {
                  success(responseObject);
              }
              failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                  failure(error);
              }];
}

-(void)requestLattestMessegesWithearlyTimeStamp:(NSString *)timeStampStringEarly latetimeStamp:(NSString *)timeStampStringLate chattingWith:(NSString *)chatID myId:(NSString *)myId suc:(void (^)(id))success fail:(void (^)(NSError *))failure
{
    NSString * url = [URL_SERVER stringByAppendingString:@"/getLatestMessages"];
    [self postRequest:url
           parameters:@{
                            @"from" : chatID,
                            @"to" : myId,
                            @"early" : timeStampStringEarly,
                            @"late" : timeStampStringLate
                        }
              success:^(AFHTTPRequestOperation *operation, id responseObject) {
                  success(responseObject);
              }
              failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                  failure(error);
              }];
}

-(void)requestCheckNewMessagesWithTimeStamp:(NSString *)timeStamp myID:(NSString *)myID suc:(void (^)(id))success fail:(void (^)(NSError *))failure
{
    NSString * url = [URL_SERVER stringByAppendingString:@"/checkNewMessage"];
    [self postRequest:url
           parameters:@{
                        @"myID" : myID,
                        @"timestamp" : timeStamp
                        }
              success:^(AFHTTPRequestOperation *operation, id responseObject) {
                  success(responseObject);
              }
              failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                  failure(error);
              }];
}
#pragma mark - group interface
@end
