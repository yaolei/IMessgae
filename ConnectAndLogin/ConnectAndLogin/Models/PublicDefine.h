//
//  Header.h
//  ConnectAndLogin
//
//  Created by wanglongyan on 15/6/15.
//  Copyright (c) 2015年 svs. All rights reserved.
//

#ifndef ConnectAndLogin_Header_h
#define ConnectAndLogin_Header_h

#define USERDEFAULT_USERNAME    @"USER"
#define USERDEFAULT_PASSWORD    @"PWD"

#define USERDEFAULT_DETAIL      @"DETAIL"
#define USERDEFAULT_DETAIL_ID   @"ID"
#define USERDEFAULT_DETAIL_NAME @"NAME"
#define USERDEFAULT_DETAIL_MEMBER   @"MEMBER"

#define USERDEFAULT_RECENTLIST  @"RECENT"
#define USERDEFAULT_CHATRECORD  @"CHATRECORD"

#define USERDEFAULT_LASTDATE    @"LASTDATE"

#define G_NOTI_LOGIN_SUC          @"LOGIN_SUCC"
#define G_NOTI_LOGIN_FAIL         @"LOGIN_FAIL"

#define G_NOTI_REGISTER_SUC       @"REG_SUCC"
#define G_NOTI_REGISTER_FAIL      @"REG_FAIL"

#define G_NOTI_MESSAGE_SENDING    @"MSG_SENDING"
#define G_NOTI_MESSAGE_SENT_SUC   @"MSG_SENT_SUC"
#define G_NOTI_MESSAGE_SENT_FAIL    @"MSG_SENDT_FAIL"
#define G_NOTI_MESSAGE_RECEIVE    @"MSG_RECEIVE"

#define G_NOTI_FRIEND_ASK_SENT      @"FRI_ASK_SENT"
#define G_NOTI_FRIEND_ASK_SENT_FAIL @"FRI_ASK_SENT_FAIL"
#define G_NOTI_FRIEND_LIST_RECEIVED @"FRI_LIST_RECEIVED"
#define G_NOTI_FRIEND_SEARCH_RESULT @"FRI_SEARCH"
#define G_NOTI_USER_BRIEF_INFO      @"USER_BRIEF_INFO"

#define G_NOTI_RECENT_UPDATED       @"RECENT_UPDATE"

#define G_NOTI_MESSAGE_LIST_UPDATE  @"MSG_LIST_UPDATE"
#define G_NOTI_MESSAGE_LIST_ALL     @"MSG_LIST_ALL"
#define G_NOTI_MESSAGE_LIST_OLD     @"MSG_LIST_OLD"
#define G_NOTI_MESSAGE_LIST_NEW     @"MSG_LIST_NEW"
#define G_NOTI_MESSAGE_HAVE_NEW     @"MSG_LIST_HAVE_NEW"

typedef enum : NSUInteger {
    SendMsgCellStatus_Sending,
    SendMsgCellStatus_Suc,
    SendMsgCellStatus_Fail
} SendMsgCellStatus;

#endif
