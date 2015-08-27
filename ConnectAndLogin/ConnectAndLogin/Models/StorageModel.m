//
//  StorageModel.m
//  ConnectAndLogin
//
//  Created by wanglongyan on 15/6/17.
//  Copyright (c) 2015年 svs. All rights reserved.
//

#import "StorageModel.h"
#import "PublicDefine.h"

@interface StorageModel ()
{
    NSUserDefaults * _userdefault;
}

@end

/*
 USERDEFAULT_USERNAME   string -  current user name
 USERDEFAULT_PASSWORD   string - hashed password
 USERDEFAULT_DETAIL     dictionary - user info details. inner key is userid
     [user id] key      USERDEFAULT_DETAIL_ID   string - user id
                        USERDEFAULT_DETAIL_NAME string - user name
                        USERDEFAULT_DETAIL_MEMBER array - group member...if just an user, not group, this will be mil.
 [current userid] dictionary - record info according to current user name
    USERDEFAULT_RECENTLIST array - whom recent chat with current user
    USERDEFAULT_CHATRECORD dictionary - chat content history record
        [target usersid] array - history between current user & target user
 */
static StorageModel * instance;
@implementation StorageModel
+(instancetype)sharedStorageModel
{
    if (instance == nil) {
        instance = [[StorageModel alloc] init];
    }
    return instance;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _userdefault = [NSUserDefaults standardUserDefaults];
//        [self testData];
    }
    return self;
}

-(void)testData
{
    
//    NSMutableDictionary * detail = [@{
//                              @"557ed491b2f8875111a3c22b" : @{
//                                      USERDEFAULT_DETAIL_ID : @"557ed491b2f8875111a3c22b",
//                                      USERDEFAULT_DETAIL_NAME : @"user100"
//                                      },
//                              @"557ed491b2f8875111a3c22c" : @{
//                                      USERDEFAULT_DETAIL_ID : @"557ed491b2f8875111a3c22c",
//                                      USERDEFAULT_DETAIL_NAME : @"user101"
//                                      },
//                              } mutableCopy];
//    [_userdefault setValue:detail forKey:USERDEFAULT_DETAIL];
//    
//    detail = [@{
//               USERDEFAULT_RECENTLIST : [@[@"557ed491b2f8875111a3c22c"] mutableCopy],
//               USERDEFAULT_CHATRECORD : [@{} mutableCopy]
//               } mutableCopy];
//    [_userdefault setValue:detail forKey:@"557ed491b2f8875111a3c22b"];
}

#pragma mark - interface

-(NSString *)getCurrentUserName
{
     return [_userdefault objectForKey:USERDEFAULT_USERNAME];
}

-(void)setCurrentUserName:(NSString *)name
{
    if (name) {
        [_userdefault setObject:name forKey:USERDEFAULT_USERNAME];
    } else {
        [_userdefault removeObjectForKey:USERDEFAULT_USERNAME];
    }
    
}

-(NSString *)getCurrentUserPassword
{
     return [_userdefault objectForKey:USERDEFAULT_PASSWORD];
}

-(void)setCurrentUserPassword:(NSString *)pwd
{
    if (pwd) {
        [_userdefault setValue:pwd forKey:USERDEFAULT_PASSWORD];
    } else {
        [_userdefault removeObjectForKey:USERDEFAULT_PASSWORD];
    }
}

-(NSArray *)getRecentChatListWithUserID:(NSString *)userid
{
    return [[_userdefault objectForKey:userid] objectForKey:USERDEFAULT_RECENTLIST];
}

-(void)insertRecentCahtListWithItem:(id)item withUserId:(NSString *)userid
{
    if (item == nil) {
        return;
    }
    
    NSMutableArray * arr = [[self getRecentChatListWithUserID:userid] mutableCopy];
    [arr insertObject:item atIndex:0];
    [[_userdefault objectForKey:userid] setObject:arr forKey:USERDEFAULT_RECENTLIST];
}

-(NSDictionary *)getUserDetailWithUserID:(NSString *)userid
{
    return [_userdefault objectForKey:USERDEFAULT_DETAIL][userid];
}

-(void)insertUserDetailWIthItem:(id)item
{
    if (item == nil && item[USERDEFAULT_DETAIL_ID]) {
        return;
    }
    
    NSMutableDictionary * dic = [[_userdefault objectForKey:USERDEFAULT_DETAIL] mutableCopy];
    [dic setValue:item[USERDEFAULT_DETAIL_ID] forKey:item];
    [_userdefault setObject:dic forKey:USERDEFAULT_DETAIL];
}

-(NSArray *)getChatHistoryWityMyUserId:(NSString *)myID targetID:(NSString *)targetID
{
    return [_userdefault objectForKey:myID][USERDEFAULT_CHATRECORD][targetID];
}

-(void)setChatHistoryWithMyUserId:(NSString *)myID targetID:(NSString *)targetID newChatHistory:(NSArray *)history
{
    return;
    [[[_userdefault objectForKey:myID] objectForKey:USERDEFAULT_CHATRECORD] setObject:history forKey:targetID];
}

-(void)insertLatestMessageIntoChatHistoryWithMyUserId:(NSString *)myID targetID:(NSString *)targetID message:(id)msg
{
    return;
    NSMutableArray * arr = [[self getChatHistoryWityMyUserId:myID targetID:targetID] mutableCopy];
    
    if (arr == nil) {
        arr = [NSMutableArray array];
    }
    
    [arr addObject:msg];

    [self setChatHistoryWithMyUserId:myID targetID:targetID newChatHistory:arr];
}

@end
