//
//  PBRequestCommon.h
//  PaoBa
//
//  Created by wujian on 2017/3/15.
//  Copyright © 2017年 wujian. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PBRequestEmitter.h"

static int PBKCallTimeout = 30; //30 秒

typedef enum : NSUInteger {
    RequestType_HTTP = 0,
    RequestType_SOCKET_TCP = 1,
    RequestType_SOCKET_UDP,
} RequestType;
//请求的一些信息
@interface PBRequestCommon : NSObject

@property (nonatomic, assign) int reqId;
@property (nonatomic, assign) int timeoutValue;
@property (nonatomic, assign) BOOL isEncrypt;

@property (nonatomic, assign) RequestType requestType; //0 http 1 socket

@property (nonatomic, weak) id <PBRequestEmitterDelegate> delegate;
- (BOOL)isTimeouted;

- (void)setRequestFailRetryCount:(int)retryCount;
@end
