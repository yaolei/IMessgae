//
//  NetworkModel.h
//  ConnectAndLogin
//
//  Created by wanglongyan on 15/6/10.
//  Copyright (c) 2015年 svs. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"
#import "PublicDefine.h"

@interface NetworkModel : NSObject
+(instancetype)sharedNetworkModel;

#pragma mark - user interface
-(void)requestLoginWithName:(NSString *)name password:(NSString *)pwd suc:(void (^)(id responseObject))success fail:(void (^)(NSError * error))failure;
-(void)requestAddFriend:(NSString*)targetId myID:(NSString*)myID suc:(void (^)(id responseObject))success fail:(void (^)(NSError * error))failure;
-(void)requestSearchFriend:(NSString*)targetId suc:(void (^)(id responseObject))success fail:(void (^)(NSError * error))failure;
-(void)requestFriendList:(NSString *)targetId suc:(void (^)(id responseObject))success fail:(void (^)(NSError * error))failure;
-(void)requestUserBriefInfo:(id)userIDs suc:(void (^)(id responseObject))success fail:(void (^)(NSError * error))failure;
#pragma mark - message interface
-(void)requestSendMessageWithToID:(NSString *)toID formID:(NSString*)fromId messageType:(NSString*)type content:(NSString*)content contentURL:(NSString*)contentUrl suc:(void (^)(id responseObject))success fail:(void (^)(NSError * error))failure;

-(void)requestLattestMessegesWithearlyTimeStamp:(NSString*)timeStampStringEarly latetimeStamp:(NSString*)timeStampStringLate chattingWith:(NSString*)chatID myId:(NSString*)myId suc:(void (^)(id responseObject))success fail:(void (^)(NSError * error))failure;
-(void)requestCheckNewMessagesWithTimeStamp:(NSString*)timeStamp myID:(NSString*)myID suc:(void (^)(id responseObject))success fail:(void (^)(NSError * error))failure;
#pragma mark - group interface




@end
