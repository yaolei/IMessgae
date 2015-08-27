//
//  BasicModel.m
//  ConnectAndLogin
//
//  Created by wanglongyan on 15/6/29.
//  Copyright (c) 2015年 svs. All rights reserved.
//

#import "BasicModel.h"

@implementation BasicModel
+(instancetype)sharedModel
{
    return nil;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _sharedNetworkModel = [NetworkModel sharedNetworkModel];
        _sharedStorageModel = [StorageModel sharedStorageModel];
    }
    return self;
}

-(void)sendNotification:(NSString*)name withObject:(id)object userInfo:(NSDictionary *)aUserInfo;
{
    if (name) {
        NSLog(@"send notification : %@", name);
        NSNotificationCenter * nc = [NSNotificationCenter defaultCenter];
        [nc postNotificationName:name object:object userInfo:aUserInfo];
    }
}
@end
