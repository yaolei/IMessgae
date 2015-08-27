//
//  SendMsgCell.h
//  XMPPIOS
//
//  Created by wanglongyan on 15/6/3.
//  Copyright (c) 2015年 Dawn_wdf. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DataModel.h"

#define SendMsgCellIdentifier   @"send_msg_cell"
@interface SendMsgCell : UITableViewCell
-(void)sentSuccess:(SendMsgCellStatus)success;
-(void)updateUI;
@property (nonatomic, retain) Message * message;
@end
