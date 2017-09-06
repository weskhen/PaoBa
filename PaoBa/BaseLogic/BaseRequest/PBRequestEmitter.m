//
//  PBRequestEmitter.m
//  PaoBa
//
//  Created by wujian on 2017/3/16.
//  Copyright © 2017年 wujian. All rights reserved.
//

#import "PBRequestEmitter.h"
#import "PBHttpChannelProxyRequest.h"
#import "PBSocketChannelProxyRequest.h"
#import "PBRequestManage.h"
#import "PBRequestConfig.h"

@interface PBRequestEmitter ()

@property (nonatomic, weak) id <PBRequestEmitterDelegate> delegate;

@end

@implementation PBRequestEmitter

+ (void)asyncRequestWithMethod:(NSString *)method reqData:(NSData *)reqData delegate:(id<PBRequestEmitterDelegate>)delegate
{
    int timeoutValue = PBKCallTimeout;
    if (delegate && [delegate respondsToSelector:@selector(getCustomTimeoutValue)]) {
        timeoutValue = [delegate getCustomTimeoutValue];
    }
    
    BOOL switchToSocket = false; //默认是Http请求
    if (delegate && [delegate respondsToSelector:@selector(switchToSocketChannel)]) {
        switchToSocket = [delegate switchToSocketChannel];
    }
    
    PBRequestConfig *requestConfig = [PBRequestConfig new];
    requestConfig.reqId = [[PBRequestManage sharedInstance] getNextReqId];
    requestConfig.timeoutValue = timeoutValue;
    requestConfig.isEncrypt = false;
    [[PBRequestManage sharedInstance] addReqConfig:requestConfig withId:requestConfig.reqId];

    if (switchToSocket) {
        requestConfig.requestType = RequestType_SOCKET_TCP;
        //socket 失败后需要检查是否走http通道重试
        [[PBSocketChannelProxyRequest sharedInstance] asyncCallWithMethod:method reqData:reqData timeout:timeoutValue delegate:(id <PBAsyncSocketDelegate>)requestConfig];
    }
    else
    {
        requestConfig.requestType = RequestType_HTTP;
        PBHttpChannelProxyRequest *httpRequest = [PBHttpChannelProxyRequest new];
        [httpRequest sendAsyncRequestWithMethod:method rpcData:reqData delegate:delegate];
    }
}

+ (void)notifyCallWithMethod:(NSString *)method reqData:(NSData *)reqData
{
    [[PBSocketChannelProxyRequest sharedInstance] notifyCallWithMethod:method reqData:reqData];
}

@end
