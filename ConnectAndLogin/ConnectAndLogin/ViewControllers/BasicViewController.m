//
//  BasicViewController.m
//  XMPPIOS
//
//  Created by wanglongyan on 15/6/1.
//  Copyright (c) 2015年 Dawn_wdf. All rights reserved.
//

#import "BasicViewController.h"

@implementation BasicViewController

@synthesize dataArray = _dataArray;
- (instancetype)init
{
    self = [super init];
    if (self) {
        _sharedDataModel = [DataModel sharedModel];
        
        _notificationNames = [[NSMutableArray alloc] init];
        
        _dataArray = [[NSMutableArray alloc] init];
        
        [self initNotifications];
    }
    return self;
}

-(void)viewDidLoad
{
    _tableView = [[RTPullTableView alloc] initWithFrame:self.view.frame];
    [self.view addSubview:_tableView];
    [_tableView setDelegate:self];
    [_tableView setDataSource:self];
    [_tableView setPullDelegate:self];
    [_tableView release];
}

-(void)dealloc
{
    [self removeAllObservers];
    
    [_notificationNames removeAllObjects];
    
    [_dataArray removeAllObjects];
    [_dataArray release];
    
    [super dealloc];
}

-(void)removeAllObservers
{
    for (NSString * name in _notificationNames) {
        NSNotificationCenter * nc = [NSNotificationCenter defaultCenter];
        [nc removeObserver:self name:name object:nil];
    }
}

#pragma mark - notifications for all view controllers
-(void)initNotificationsForAllSubclass
{
    
}

-(void)registerNotificationForAllSubclass:(NSString *)notificationName
{
    if (notificationName) {
        NSNotificationCenter * nc = [NSNotificationCenter defaultCenter];
        [nc addObserver:self selector:@selector(notificationHandlerForAllSubclassWithNotification:) name:notificationName object:nil];
        [_notificationNames addObject:notificationName];
    }
}

-(void)notificationHandlerForAllSubclassWithNotification:(NSNotification *)notification
{
    
}

#pragma mark - interface to over ride
-(void)initNotifications
{
    
}

-(void)registerNotificationObserverWithName:(NSString *)notificationName
{
    if (notificationName) {
        NSNotificationCenter * nc = [NSNotificationCenter defaultCenter];
        [nc addObserver:self selector:@selector(notificationHandlerWithNotification:) name:notificationName object:nil];
        [_notificationNames addObject:notificationName];
    }
}

-(void)notificationHandlerWithNotification:(NSNotification *)notification
{
    
}

-(void)getAllNewData
{
    
}

-(void)getMoreUpData
{
    [_tableView RTPullTableViewDidFinishLoad];
}
-(void)getMoreDownData
{
    [_tableView RTPullTableViewDidFinishLoad];
}

#pragma mark - table view delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_dataArray count];;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return nil;
}

- (void)RTPullTableViewDidTriggerRefresh:(RTPullTableView *)RTTableView
{
    [self getMoreUpData];
}
- (void)RTPullTableViewDidTriggerMore:(RTPullTableView *)RTTableView
{
    [self getMoreDownData];
}
@end
