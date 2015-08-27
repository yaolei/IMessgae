//
//  BasicViewController.h
//  XMPPIOS
//
//  Created by wanglongyan on 15/6/1.
//  Copyright (c) 2015年 Dawn_wdf. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DataModel.h"
#import "RTPullTableView.h"

@interface BasicViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, RTPullTableViewDelegate>
{
    @public
    DataModel * _sharedDataModel;
    RTPullTableView * _tableView;
    
    @private
    NSMutableArray * _notificationNames;
}

@property (nonatomic, assign) NSMutableArray * dataArray;

-(void)initNotifications;
-(void)registerNotificationObserverWithName:(NSString*)notificationName;
-(void)notificationHandlerWithNotification:(NSNotification*)notification;

-(void)getAllNewData;
-(void)getMoreUpData;
-(void)getMoreDownData;
@end
