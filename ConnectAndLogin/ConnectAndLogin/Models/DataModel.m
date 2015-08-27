//
//  DataModel.m
//  ConnectAndLogin
//
//  Created by wanglongyan on 15/6/10.
//  Copyright (c) 2015年 svs. All rights reserved.
//

#import "DataModel.h"

static DataModel * instanceDataModel;
@interface DataModel ()
{
    NSMutableString * _currentUserId;
}
@end

@implementation DataModel
+(instancetype)sharedModel
{
    if (instanceDataModel == nil) {
        instanceDataModel = [[DataModel alloc] init];
    }
    return instanceDataModel;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _currentUserId = [[NSMutableString alloc] init];
        
        [self testData];
        
        [self loopForNewMesseage];
    }
    return self;
}

-(void)dealloc
{
    [_currentUserId release];
    
    [super dealloc];
}

-(void)testData
{

}

-(void)resetData
{
    MessageModel * msg = [MessageModel sharedModel];
    [msg resetData];
}

#pragma mark - inner funtion

#pragma mark - loop or notification handler
-(void)loopForNewMesseage
{
    MessageModel * msgModel = [MessageModel sharedModel];
    [msgModel checkNewMessages:_currentUserId];
    
    [self performSelector:@selector(loopForNewMesseage) withObject:nil afterDelay:1];
}

#pragma mark - login interface
-(BOOL)isLoginUserInfoCached
{
    NSString * name = [_sharedStorageModel getCurrentUserName];
    NSString * pwd = [_sharedStorageModel getCurrentUserPassword];
    if (name && pwd) {
        return YES;
    }
    return NO;
}

-(void)loginWithUsername:(NSString*)username AndPassword:(NSString*)pwd
{
    if (username == nil || pwd == nil) {
        return;
    }
    
    [_sharedStorageModel setCurrentUserName:username];
    [_sharedStorageModel setCurrentUserPassword:[Utilities md5HexDigest:pwd]];
    
    [self doLogin];
}

-(void)loginWithCachedUsernameAndPassword
{
    [self doLogin];
}

-(void)doLogin
{
    NSString * name = [_sharedStorageModel getCurrentUserName];
    NSString * pwd = [_sharedStorageModel getCurrentUserPassword];
    [_sharedNetworkModel requestLoginWithName:name password:pwd suc:^(id responseObject) {
        
        if ([[_sharedStorageModel getCurrentUserName] isEqualToString:responseObject[@"name"]]) {
            //login suc
            [_currentUserId setString:responseObject[@"id"]];
            if ([[NSUserDefaults standardUserDefaults] objectForKey:USERDEFAULT_USERNAME]) {
                if (![responseObject[@"id"] isEqualToString:[[NSUserDefaults standardUserDefaults] objectForKey:USERDEFAULT_USERNAME]]) {
                    //clear cache data
                    [[NSUserDefaults standardUserDefaults] removeObjectForKey:USERDEFAULT_RECENTLIST];
                    [[NSUserDefaults standardUserDefaults] removeObjectForKey:USERDEFAULT_LASTDATE];
                    [self resetData];
                }
                [[NSUserDefaults standardUserDefaults] setObject:_currentUserId forKey:USERDEFAULT_USERNAME];
            }
//            [_userDefault setValue:@{
//                                     USERDEFAULT_RECENTLIST : @[],
//                                     USERDEFAULT_CHATRECORD : @[]
//                                     } forKey:_currentUserId];
            
            [self sendNotification:G_NOTI_LOGIN_SUC withObject:nil userInfo:nil];
        } else {
            [self sendNotification:G_NOTI_LOGIN_FAIL withObject:nil userInfo:nil];
        }
    } fail:^(NSError *error) {
        [self sendNotification:G_NOTI_LOGIN_FAIL withObject:error userInfo:nil];
    }];
}

-(BOOL)isCurrentUser:(NSString *)userid
{
    if ([_currentUserId isEqualToString:userid]) {
        return YES;
    }
    return NO;
}

#pragma mark - recent & history interface
-(NSArray *)getRecentChatListData
{
    MessageModel * m = [MessageModel sharedModel];
    [m updateRecentListData];
    return [[NSUserDefaults standardUserDefaults] objectForKey:USERDEFAULT_RECENTLIST];
//    
//    NSArray * recentArr = [_sharedStorageModel getRecentChatListWithUserID:_currentUserId];
//    
//    NSMutableArray * realDataArray = [[[NSMutableArray alloc] init] autorelease];
//    for (int i = 0; i < [recentArr count]; i ++) {
//        NSString * userid = recentArr[i];
//        id userdetail = [_sharedStorageModel getUserDetailWithUserID:userid];
//        if (userdetail == nil) {
//            userdetail[USERDEFAULT_DETAIL_NAME] = @"";
//        }
//        [realDataArray addObject:userdetail];
//    }
//    
//    return realDataArray;
}

-(void)setRecentHaveRead:(NSString *)userID
{
    NSMutableArray * arr = [[[NSUserDefaults standardUserDefaults] objectForKey:USERDEFAULT_RECENTLIST] mutableCopy];
    for (int i = 0; i < [arr count]; i ++) {
        NSDictionary * dic = arr[i];
        if ([dic[USERDEFAULT_DETAIL_ID] isEqualToString:userID]) {
            NSMutableDictionary * newDic = [dic mutableCopy];
            newDic[@"isNew"] = [NSNumber numberWithBool:NO];
            [arr replaceObjectAtIndex:i withObject:newDic];
        }
    }
}

-(NSArray *)getChatHistoryWithUser:(NSString *)userId
{
    NSArray * historyArr = [_sharedStorageModel getChatHistoryWityMyUserId:_currentUserId targetID:userId];
    
    if ([historyArr count] == 0) {
        historyArr = [NSArray array];
    }
    
    return historyArr;
}

#pragma mark - message
-(void)sendTextMessage:(NSString*)msgContent toUser:(NSString*)toID
{
    Message * sendMsg = [[Message alloc] init];
    sendMsg.sendStatus = SendMsgCellStatus_Sending;
    sendMsg.fromID = _currentUserId;
    sendMsg.toID = toID;
    sendMsg.content = msgContent;
    
    BOOL isGroup = false;
    id memberOfgroup = [_sharedStorageModel getUserDetailWithUserID:sendMsg.toID][USERDEFAULT_DETAIL_MEMBER];
    if ([memberOfgroup count] > 0) {
        isGroup = YES;
    }
    if (isGroup) {//group chat
        sendMsg.chatType = @"GROUP";
    } else {
        sendMsg.chatType = @"ONE";
    }
    
    MessageModel * model = [MessageModel sharedModel];
    
    [model send:sendMsg];
    
    [sendMsg release];
}

-(void)getAllMessages:(NSString *)toID
{
    MessageModel * m = [MessageModel sharedModel];
    [m getAllMessages:toID myID:_currentUserId];
}

-(void)getNewMessages:(NSString *)toID
{
    MessageModel * m = [MessageModel sharedModel];
    [m getNewMessages:toID myID:_currentUserId];
}

-(void)getOldMessages:(NSString *)toID
{
    MessageModel * m = [MessageModel sharedModel];
    [m getOldMessages:toID myID:_currentUserId];
}

#pragma mark - user
-(void)searchUserList:(NSString*)target
{
    PersonModel * model = [PersonModel sharedModel];
    [model searchFriendList:target];
}
-(void)addFriend:(NSString*)targetID
{
    PersonModel * model = [PersonModel sharedModel];
    [model addFriend:targetID myID:_currentUserId];
}

-(void)getFriendList
{
    PersonModel * model = [PersonModel sharedModel];
    [model getFriendList:_currentUserId];
}

-(void)getUserBriefInfo:(NSString *)userID
{
    PersonModel * m = [PersonModel sharedModel];
    [m getUserBriefInfo:userID];
}
@end
