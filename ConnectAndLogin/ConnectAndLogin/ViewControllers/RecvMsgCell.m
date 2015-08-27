//
//  RecvMsgCell.m
//  XMPPIOS
//
//  Created by wanglongyan on 15/6/3.
//  Copyright (c) 2015年 Dawn_wdf. All rights reserved.
//

#import "RecvMsgCell.h"

@implementation RecvMsgCell
- (instancetype)init
{
    self = [super init];
    if (self) {

    }
    return self;
}

-(void)updateUI
{
    [self.textLabel setTextAlignment:NSTextAlignmentLeft];
    [self setBackgroundColor:[UIColor greenColor]];
    [self.textLabel setTextColor:[UIColor whiteColor]];
    [self.textLabel setText:self.message.content];
}
@end
