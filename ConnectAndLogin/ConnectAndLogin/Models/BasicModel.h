//
//  BasicModel.h
//  ConnectAndLogin
//
//  Created by wanglongyan on 15/6/29.
//  Copyright (c) 2015年 svs. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "StorageModel.h"
#import "NetworkModel.h"
#import "Utilities.h"
#import "PublicDefine.h"

@interface BasicModel : NSObject
{
    @public
    NetworkModel * _sharedNetworkModel;
    StorageModel * _sharedStorageModel;
}
+(instancetype)sharedModel;
-(void)sendNotification:(NSString*)name withObject:(id)object userInfo:(NSDictionary *)aUserInfo;
@end
