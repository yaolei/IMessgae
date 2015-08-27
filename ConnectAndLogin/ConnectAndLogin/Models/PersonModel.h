//
//  PersonModel.h
//  ConnectAndLogin
//
//  Created by wanglongyan on 15/7/21.
//  Copyright (c) 2015年 svs. All rights reserved.
//

#import "BasicModel.h"

@interface Person : NSObject <NSCoding>
@property (nonatomic, copy) NSString * pid;
@property (nonatomic, copy) NSString * name;

@end

@interface PersonModel : BasicModel
-(void)addFriend:(NSString*)friendID myID:(NSString*)myID;
-(void)searchFriendList:(NSString*)targetID;
-(void)getFriendList:(NSString*)myID;
-(void)getUserBriefInfo:(NSString*)userId;
@end
