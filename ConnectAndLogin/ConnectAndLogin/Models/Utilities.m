//
//  Utulities.m
//  ConnectAndLogin
//
//  Created by wanglongyan on 15/6/16.
//  Copyright (c) 2015年 svs. All rights reserved.
//

#import "Utilities.h"

#import <CommonCrypto/CommonDigest.h>

#define CC_MD5_DIGEST_LENGTH 16

@implementation Utilities
+ (NSString *)md5HexDigest:(NSString*)input
{
    const char* str = [input UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(str, (CC_LONG)strlen(str), result);
    NSMutableString *ret = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH];
    
    for(int i = 0; i<CC_MD5_DIGEST_LENGTH; i++) {
        [ret appendFormat:@"%02x",result[i]];
    }
    return ret;
}
@end
