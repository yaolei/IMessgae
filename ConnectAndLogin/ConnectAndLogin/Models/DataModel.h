//
//  DataModel.h
//  ConnectAndLogin
//
//  Created by wanglongyan on 15/6/10.
//  Copyright (c) 2015年 svs. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MessageModel.h"
#import "BasicModel.h"
#import "PersonModel.h"

@interface DataModel : BasicModel

#pragma mark - loop or notification handler
-(void)loopForNewMesseage;

-(void)resetData;

#pragma mark - login interface
-(void)loginWithUsername:(NSString*)username AndPassword:(NSString*)pwd;
-(BOOL)isLoginUserInfoCached;
-(void)loginWithCachedUsernameAndPassword;

-(BOOL)isCurrentUser:(NSString*)userid;

#pragma mark - recent & history interface
-(NSArray*)getRecentChatListData;
-(void)setRecentHaveRead:(NSString*)userID;
-(NSArray*)getChatHistoryWithUser:(NSString*)userId;

#pragma mark - message
-(void)sendTextMessage:(NSString*)msgContent toUser:(NSString*)toID;
-(void)getAllMessages:(NSString*)toID;
-(void)getOldMessages:(NSString*)toID;
-(void)getNewMessages:(NSString*)toID;

#pragma mark - user
-(void)searchUserList:(NSString*)target;
-(void)addFriend:(NSString*)targetID;
-(void)getFriendList;
-(void)getUserBriefInfo:(NSString*)userID;
@end
