//
//  MessageModel.h
//  ConnectAndLogin
//
//  Created by wanglongyan on 15/6/17.
//  Copyright (c) 2015年 svs. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BasicModel.h"

@interface Message  : NSObject <NSCoding>
@property (nonatomic, copy) NSString * fromID;
@property (nonatomic, copy) NSString * toID;
@property (nonatomic, copy) NSString * timeStamp;
@property (nonatomic, copy) NSString * msgID;
@property (nonatomic, copy) NSString * chatType;//ONE, GROUP
@property (nonatomic, copy) NSString * content;
@property (nonatomic, copy) NSString * url;
@property (nonatomic, assign) SendMsgCellStatus sendStatus;
@end

@interface MessageModel : BasicModel
-(void)resetData;
-(void)send:(Message *)sendMsg;
-(void)updateRecentListData;
-(void)getAllMessages:(NSString*)toID myID:(NSString*)myID;
-(void)getOldMessages:(NSString*)toID myID:(NSString*)myID;
-(void)getNewMessages:(NSString*)toId myID:(NSString*)myID;
-(void)checkNewMessages:(NSString*)myID;
@end
