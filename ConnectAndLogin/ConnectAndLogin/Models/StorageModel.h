//
//  StorageModel.h
//  ConnectAndLogin
//
//  Created by wanglongyan on 15/6/17.
//  Copyright (c) 2015年 svs. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface StorageModel : UITableViewCell
+(instancetype)sharedStorageModel;

-(NSString*)getCurrentUserName;
-(void)setCurrentUserName:(NSString*)name;

-(NSString*)getCurrentUserPassword;
-(void)setCurrentUserPassword:(NSString*)pwd;

-(NSArray*)getRecentChatListWithUserID:(NSString*)userid;
-(void)insertRecentCahtListWithItem:(id)item withUserId:(NSString*)userid;

-(NSDictionary*)getUserDetailWithUserID:(NSString*)userid;
-(void)insertUserDetailWIthItem:(id)item;

-(NSArray*)getChatHistoryWityMyUserId:(NSString*)myID targetID:(NSString*)targetID;
-(void)setChatHistoryWithMyUserId:(NSString*)myID targetID:(NSString*)targetID newChatHistory:(NSArray*)history;
-(void)insertLatestMessageIntoChatHistoryWithMyUserId:(NSString*)myID targetID:(NSString*)targetID message:(id)msg;
@end
