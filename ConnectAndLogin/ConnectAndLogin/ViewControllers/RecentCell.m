//
//  RecentCell.m
//  ConnectAndLogin
//
//  Created by wanglongyan on 15/6/16.
//  Copyright (c) 2015年 svs. All rights reserved.
//

#import "RecentCell.h"
#import "PublicDefine.h"

@implementation RecentCell

-(void)updateUIWithData:(id)data
{
    NSString * name = data[USERDEFAULT_DETAIL_NAME];
    if (!name || [name isEqualToString:@""]) {
        name = data[USERDEFAULT_DETAIL_ID];
    }
    [self.textLabel setText:name];
    if ([data[@"isNew"] boolValue]) {
        [self.textLabel setTextColor:[UIColor redColor]];
    } else {
        [self.textLabel setTextColor:[UIColor blackColor]];
    }
}
@end
