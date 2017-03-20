//
//  PBRequestCallBack.m
//  PaoBa
//
//  Created by wujian on 2017/3/16.
//  Copyright © 2017年 wujian. All rights reserved.
//

#import "PBRequestCallBack.h"
#import "PBRequestCommon.h"

@implementation PBRequestCallBack


- (instancetype)init
{
    self = [super init];
    if (self) {
        self.ReqFailRetryCount = 0;
        self.timeoutValue = PBKCallTimeout;
    }
    return self;
}

#pragma mark - PBRequestEmitterDelegate
- (void)onCallSuccess:(NSData *)rspData
{
    
}

- (void)onCallFail:(NSError *)errorInfo
{
    
}

//第一次请求是否切换到Socket通道
- (BOOL)switchToSocketChannel
{
    return self.useSocketOnFirstTry;
}

//第一次请求失败后尝试http通道
- (BOOL)shouldTryHttpChannelOnFail
{
    return self.shouldTryHttpChannelOnFail;
}

//获取自定义的请求超时时间
- (int)getCustomTimeoutValue
{
    return self.timeoutValue;
}

- (NSString*)getRequestURL
{
    return nil;
}

- (int)getRequestFailRetryCount
{
    return self.ReqFailRetryCount;
}
@end
