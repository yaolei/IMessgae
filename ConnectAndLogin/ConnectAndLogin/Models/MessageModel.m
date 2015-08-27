//
//  MessageModel.m
//  ConnectAndLogin
//
//  Created by wanglongyan on 15/6/17.
//  Copyright (c) 2015年 svs. All rights reserved.
//

#import "MessageModel.h"
#import "StorageModel.h"
#import "NetworkModel.h"
#import "DataModel.h"

@implementation Message

@synthesize fromID = _fromID, toID = _toID, timeStamp = _timeStamp, msgID = _msgID, chatType = _chatType, content = _content, url = _url;

-(id)initWithCoder:(NSCoder *)aDecoder
{
    return nil;
}

-(void)encodeWithCoder:(NSCoder *)aCoder
{
    
}

@end


@interface MessageModel ()
{

    NSMutableArray * _messageList;
    NSMutableArray * _recentList;
    
    BOOL _gettingNew;
    BOOL _gettingOld;
    
    BOOL _checkingNew;
    NSMutableString * _lastCheckNewDate;
}
@end

static MessageModel * msgModelInstance = nil;

@implementation MessageModel

+(instancetype)sharedModel
{
    if (msgModelInstance == nil) {
        msgModelInstance = [[MessageModel alloc] init];
    }
    return msgModelInstance;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _messageList = [[NSMutableArray alloc] init];
        _gettingNew = NO;
        _gettingOld = NO;
        _checkingNew = NO;
        _lastCheckNewDate = [[NSMutableString alloc] init];
        if ([[NSUserDefaults standardUserDefaults] objectForKey:USERDEFAULT_LASTDATE]) {
            [_lastCheckNewDate setString:[[NSUserDefaults standardUserDefaults] objectForKey:USERDEFAULT_LASTDATE]];
        } else {
            [_lastCheckNewDate setString:@""];
        }
        _recentList = [[NSUserDefaults standardUserDefaults] objectForKey:USERDEFAULT_RECENTLIST];
        if (_recentList == nil) {
            _recentList = [[NSMutableArray alloc] init];
        }
    }
    return self;
}

-(void)dealloc
{
    [_messageList release];
    [_lastCheckNewDate release];
    
    [self saveRecentList];
    [_recentList release];
    [super dealloc];
}

-(void)resetData
{
    [_recentList removeAllObjects];
    [_recentList addObjectsFromArray:[[NSUserDefaults standardUserDefaults] objectForKey:USERDEFAULT_RECENTLIST]];
    
    _lastCheckNewDate = [[NSMutableString alloc] init];
    if ([[NSUserDefaults standardUserDefaults] objectForKey:USERDEFAULT_LASTDATE]) {
        [_lastCheckNewDate setString:[[NSUserDefaults standardUserDefaults] objectForKey:USERDEFAULT_LASTDATE]];
    } else {
        [_lastCheckNewDate setString:@""];
    }
}

-(void)addToRecentListWithUserID:(NSString*)userID isNew:(BOOL)isnew
{
    for (int i = 0; i < [_recentList count]; i ++) {
        NSString * user = _recentList[i][USERDEFAULT_DETAIL_ID];
        if ([user isEqualToString:userID]) {
            [_recentList removeObjectAtIndex:i];
            break;
        }
    }
    
    NSString * name = @"";
    NSDictionary * userInfo = [[NSUserDefaults standardUserDefaults] objectForKey:@"userinfo"];
    if (userInfo[userID]) {
        name = userInfo[userID][USERDEFAULT_DETAIL_NAME];
    }

    NSDictionary * dic = @{USERDEFAULT_DETAIL_ID: userID, USERDEFAULT_DETAIL_NAME: name, @"isNew": [NSNumber numberWithBool:isnew]};
    
    [_recentList insertObject:dic atIndex:0];
    
    [self saveRecentList];
    
    [self sendNotification:G_NOTI_RECENT_UPDATED withObject:nil userInfo:nil];
}

-(void)updateRecentListData
{
    NSDictionary * userInfo = [[NSUserDefaults standardUserDefaults] objectForKey:@"userinfo"];
    
    for (int i = 0; i < [_recentList count]; i ++) {
        NSMutableDictionary * dic = [_recentList[i] mutableCopy];
        if (userInfo[dic[USERDEFAULT_DETAIL_ID]] && [dic[USERDEFAULT_DETAIL_NAME] isEqualToString:@""]) {
            dic[USERDEFAULT_DETAIL_NAME] = userInfo[USERDEFAULT_DETAIL_ID][USERDEFAULT_DETAIL_NAME];
            [_recentList replaceObjectAtIndex:i withObject:dic];
        }
        [dic release];
    }
    
    [self saveRecentList];
}

-(void)saveRecentList
{
    [[NSUserDefaults standardUserDefaults] setObject:_recentList forKey:USERDEFAULT_RECENTLIST];
}

-(void)send:(Message *)sendMsg
{
    [_messageList addObject:sendMsg];
    [self addToRecentListWithUserID:sendMsg.toID isNew:NO];
    [self sendNotification:G_NOTI_MESSAGE_SENDING withObject:_messageList userInfo:nil];
    
    [_sharedNetworkModel requestSendMessageWithToID:sendMsg.toID formID:sendMsg.fromID messageType:sendMsg.chatType content:sendMsg.content contentURL:sendMsg.url suc:^(id responseObject) {
        
        //sent success
        if (responseObject[@"error"] && [responseObject[@"error"] intValue] == 0) {
            //save the sent msg into cache
            [sendMsg setSendStatus:SendMsgCellStatus_Suc];
            [_messageList removeObject:sendMsg];
            [self sendNotification:G_NOTI_MESSAGE_SENT_SUC withObject:_messageList userInfo:nil];
        } else {
            [sendMsg setSendStatus:SendMsgCellStatus_Fail];
            [self sendNotification:G_NOTI_MESSAGE_SENT_FAIL withObject:_messageList userInfo:nil];
        }
    } fail:^(NSError *error) {
        [sendMsg setSendStatus:SendMsgCellStatus_Fail];
        [self sendNotification:G_NOTI_MESSAGE_SENT_FAIL withObject:_messageList userInfo:nil];
    }];
}

-(void)getAllMessages:(NSString *)toID myID:(NSString *)myID
{
    if (_gettingNew || _gettingOld) {
        return;
    }
    
    _gettingNew = YES;
    _gettingOld = YES;
    [_sharedNetworkModel requestLattestMessegesWithearlyTimeStamp:@"" latetimeStamp:@"" chattingWith:toID myId:myID suc:^(id responseObject) {
        
        [self addToRecentListWithUserID:toID isNew:NO];
        
        [_messageList removeAllObjects];
        for(int i = 0; i < [responseObject count]; i ++) {
            Message * msg = [[Message alloc] init];
            NSDictionary * dic = responseObject[i];
            msg.fromID = dic[@"from"];
            msg.toID = dic[@"to"];
            msg.content = dic[@"content"];
            msg.url = dic[@"url"];
            msg.chatType = dic[@"chattype"];
            msg.timeStamp = dic[@"timestamp"];
            msg.msgID = dic[@"_id"];
            msg.sendStatus = SendMsgCellStatus_Suc;
            [_messageList addObject:msg];
            [msg release];
        }
        [self sendNotification:G_NOTI_MESSAGE_LIST_ALL withObject:_messageList userInfo:nil];
        
        _gettingOld = NO;
        _gettingNew = NO;
    } fail:^(NSError *error) {
        _gettingOld = NO;
        _gettingNew = NO;
    }];
}

-(void)getNewMessages:(NSString *)toId myID:(NSString *)myID
{
    if ([_messageList count] == 0) {
        [self getAllMessages:toId myID:myID];
        return;
    }
    
    if (_gettingNew) {
        return;
    }
    
    _gettingNew = YES;
    
    Message * m = [_messageList objectAtIndex:([_messageList count]-1)];
    [_sharedNetworkModel requestLattestMessegesWithearlyTimeStamp:m.timeStamp latetimeStamp:@"" chattingWith:toId myId:myID suc:^(id responseObject) {
        
        [self addToRecentListWithUserID:toId isNew:NO];
        
        for(int i = 0; i < [responseObject count]; i ++) {
            Message * msg = [[Message alloc] init];
            NSDictionary * dic = responseObject[i];
            msg.fromID = dic[@"from"];
            msg.toID = dic[@"to"];
            msg.content = dic[@"content"];
            msg.url = dic[@"url"];
            msg.chatType = dic[@"chattype"];
            msg.timeStamp = dic[@"timestamp"];
            msg.msgID = dic[@"_id"];
            msg.sendStatus = SendMsgCellStatus_Suc;
            [_messageList addObject:msg];
            [msg release];
        }
        [self sendNotification:G_NOTI_MESSAGE_LIST_NEW withObject:_messageList userInfo:nil];
        _gettingNew = NO;
    } fail:^(NSError *error) {
        _gettingNew = NO;
    }];
}

-(void)getOldMessages:(NSString *)toID myID:(NSString *)myID
{
    if ([_messageList count] == 0) {
        [self getAllMessages:toID myID:myID];
        return;
    }
    
    if (_gettingOld) {
        return;
    }
    
    Message * m = [_messageList objectAtIndex:0];
    
    [_sharedNetworkModel requestLattestMessegesWithearlyTimeStamp:@"" latetimeStamp:m.timeStamp chattingWith:toID myId:myID suc:^(id responseObject) {
        
        [self addToRecentListWithUserID:toID isNew:NO];
        
        for(NSInteger i = [responseObject count] - 1; i >= 0; i --) {
            Message * msg = [[Message alloc] init];
            NSDictionary * dic = responseObject[i];
            msg.fromID = dic[@"from"];
            msg.toID = dic[@"to"];
            msg.content = dic[@"content"];
            msg.url = dic[@"url"];
            msg.chatType = dic[@"chattype"];
            msg.timeStamp = dic[@"timestamp"];
            msg.msgID = dic[@"_id"];
            msg.sendStatus = SendMsgCellStatus_Suc;
            [_messageList insertObject:msg atIndex:0];
            [msg release];
        }
        [self sendNotification:G_NOTI_MESSAGE_LIST_OLD withObject:_messageList userInfo:nil];
        _gettingOld = NO;
    } fail:^(NSError *error) {
        _gettingOld = NO;
    }];
}

-(void)checkNewMessages:(NSString *)myID
{
    if (_checkingNew) {
        return;
    }
    if (myID == nil || [myID isEqualToString:@""]) {
        return;
    }
    
//    if ([_messageList count]) {
//        Message * m = [_messageList objectAtIndex:([_messageList count]-1)];
//        [_lastCheckNewDate setString:m.timeStamp];
//    }
    _checkingNew = YES;
    [_sharedNetworkModel requestCheckNewMessagesWithTimeStamp:_lastCheckNewDate myID:myID suc:^(id responseObject) {
        _checkingNew = NO;
        if (!responseObject[@"error"]) {
            for (NSInteger i = [responseObject[@"data"] count] - 1; i >= 0 ; i --) {
                [self addToRecentListWithUserID:responseObject[@"data"][i] isNew:YES];
            }
            [self sendNotification:G_NOTI_MESSAGE_HAVE_NEW withObject:responseObject[@"data"] userInfo:nil];
            [_lastCheckNewDate setString:responseObject[@"time"]];
            [[NSUserDefaults standardUserDefaults] setObject:_lastCheckNewDate forKey:USERDEFAULT_LASTDATE];
        }
    } fail:^(NSError *error) {
        _checkingNew = NO;
    }];
}
@end
