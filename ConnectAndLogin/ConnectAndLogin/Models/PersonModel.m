//
//  PersonModel.m
//  ConnectAndLogin
//
//  Created by wanglongyan on 15/7/21.
//  Copyright (c) 2015年 svs. All rights reserved.
//

#import "PersonModel.h"

@implementation Person
-(id)initWithCoder:(NSCoder *)aDecoder
{
    return nil;
}

-(void)encodeWithCoder:(NSCoder *)aCoder
{
    
}
@end

static PersonModel * ModelInstance = nil;
@interface PersonModel ()
{
    
}
@end
@implementation PersonModel
+(instancetype)sharedModel
{
    if (ModelInstance == nil) {
        ModelInstance = [[PersonModel alloc] init];
    }
    return ModelInstance;
}

-(void)addFriend:(NSString *)friendID myID:(NSString *)myID
{
    [_sharedNetworkModel requestAddFriend:friendID myID:myID suc:^(id responseObject) {
        if (!responseObject[@"error"]) {
            [self sendNotification:G_NOTI_FRIEND_ASK_SENT withObject:nil userInfo:nil];
        } else {
            [self sendNotification:G_NOTI_FRIEND_ASK_SENT_FAIL withObject:responseObject[@"error"] userInfo:nil];
        }
    } fail:^(NSError *error) {
        
    }];
}

-(void)searchFriendList:(NSString *)targetID
{
    [_sharedNetworkModel requestSearchFriend:targetID suc:^(id responseObject) {
        if (!responseObject[@"error"]) {
            //cache the id-name value in user default
            NSMutableDictionary * def = [[[NSUserDefaults standardUserDefaults] objectForKey:@"userinfo"] mutableCopy];
            if (def == nil) {
                def = [[NSMutableDictionary alloc] init];
            }
            for (NSDictionary * dic in responseObject[@"data"]) {
                NSDictionary * info = @{USERDEFAULT_DETAIL_NAME: dic[@"name"],
                                        USERDEFAULT_DETAIL_ID: dic[@"_id"]};
                [def setValue:info forKey:dic[@"_id"]];
            }
            [[NSUserDefaults standardUserDefaults] setValue:def forKey:@"userinfo"];
            [def release];
            
            [self sendNotification:G_NOTI_FRIEND_SEARCH_RESULT withObject:responseObject[@"data"] userInfo:nil];
        }
    } fail:^(NSError *error) {
        
    }];
}

-(void)getFriendList:(NSString *)myID
{
    [_sharedNetworkModel requestFriendList:myID suc:^(id responseObject) {
        if (!responseObject[@"error"]) {
            
            NSMutableDictionary * def = [[[NSUserDefaults standardUserDefaults] objectForKey:@"userinfo"] mutableCopy];
            if (def == nil) {
                def = [[NSMutableDictionary alloc] init];
            }
            for (NSDictionary * dic in responseObject[@"data"]) {
                NSDictionary * info = @{USERDEFAULT_DETAIL_NAME: dic[@"name"],
                                        USERDEFAULT_DETAIL_ID: dic[@"toID"]};
                [def setValue:info forKey:dic[@"toID"]];
            }
            [[NSUserDefaults standardUserDefaults] setValue:def forKey:@"userinfo"];
            [def release];
            
            [self sendNotification:G_NOTI_FRIEND_LIST_RECEIVED withObject:responseObject[@"data"] userInfo:nil];
        }
    } fail:^(NSError *error) {
        
    }];
}

-(void)getUserBriefInfo:(NSString *)userId
{
    [_sharedNetworkModel requestUserBriefInfo:@[userId] suc:^(id responseObject) {
        NSMutableDictionary * def = [[[NSUserDefaults standardUserDefaults] objectForKey:@"userinfo"] mutableCopy];
        if (def == nil) {
            def = [[NSMutableDictionary alloc] init];
        }
        for (NSDictionary * dic in responseObject[@"data"]) {
            NSDictionary * info = @{USERDEFAULT_DETAIL_NAME: dic[@"name"],
                                    USERDEFAULT_DETAIL_ID: dic[@"_id"]};
            [def setValue:info forKey:dic[@"_id"]];
        }
        [[NSUserDefaults standardUserDefaults] setValue:def forKey:@"userinfo"];
        [def release];
        
        [self sendNotification:G_NOTI_USER_BRIEF_INFO withObject:nil userInfo:nil];
    } fail:^(NSError *error) {
        
    }];
}
@end
