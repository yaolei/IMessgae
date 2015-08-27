//
//  SendMsgCell.m
//  XMPPIOS
//
//  Created by wanglongyan on 15/6/3.
//  Copyright (c) 2015年 Dawn_wdf. All rights reserved.
//

#import "SendMsgCell.h"


@implementation SendMsgCell
- (instancetype)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

-(void)updateUI
{
    [self.textLabel setTextAlignment:NSTextAlignmentRight];
    [self setBackgroundColor:[UIColor whiteColor]];
    
    switch (self.message.sendStatus) {
        case SendMsgCellStatus_Suc:
            [self.textLabel setTextColor:[UIColor blackColor]];
            break;
        case SendMsgCellStatus_Fail:
            [self.textLabel setTextColor:[UIColor redColor]];
            break;
        case SendMsgCellStatus_Sending:
        default:
            [self.textLabel setTextColor:[UIColor lightGrayColor]];
            break;
    }
    
    [self.textLabel setText:self.message.content];
}
@end
