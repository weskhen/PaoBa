//
//  PBRequestConfig.m
//  PaoBa
//
//  Created by wujian on 2017/3/15.
//  Copyright © 2017年 wujian. All rights reserved.
//

#import "PBRequestConfig.h"
#import "PBSocketProtocol.h"
#import "PBRequestManage.h"
#import "PBHttpChannelProxyRequest.h"

@interface PBRequestConfig ()<PBAsyncSocketDelegate>

@property (nonatomic, assign) time_t startTime;
@property (nonatomic, assign) int currentRetryCount;

@property (nonatomic, assign) int reqFailedCount;
@end

@implementation PBRequestConfig

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.currentRetryCount = 0;
        self.reqFailedCount = 0;
        self.startTime = time(0);

    }
    return self;
}

- (void)dealloc
{
    NSLog(@"PBRequestConfig dealloc");
}

#pragma mark - privateMethod
- (void)setRequestFailRetryCount:(int)retryCount
{
    self.currentRetryCount = retryCount;
}

- (BOOL)isTimeouted
{
    time_t nowT = time(0);
    if (nowT - self.startTime >= self.timeoutValue) {
        return YES;
    }
    return NO;
}


#pragma mark - PBAsyncSocketDelegate

- (void)responseSuccess:(NSString *)method forReqParam:(NSData *)reqData forRspData:(NSData *)rspData
{
    int temSeqId = self.reqId;
    if (self.delegate && [self.delegate respondsToSelector:@selector(onCallSuccess:)]) {
        [self.delegate onCallSuccess:rspData];
    }
    //移除协议 防止多次进去
    self.delegate = nil;
    [[PBRequestManage sharedInstance] removeReqConfig:self withId:temSeqId];
}

- (void)responseFail:(NSString *)method forReqParam:(NSData *)reqData forError:(NSError *)error
{
    int temSeqId = self.reqId;
    BOOL tryHttpOnFail = false;
    if ([self.delegate respondsToSelector:@selector(shouldTryHttpChannelOnFail)]) {
        tryHttpOnFail = [self.delegate shouldTryHttpChannelOnFail];
    }
    
    BOOL stopRequest = NO; //是否结束请求
    if (self.currentRetryCount <= self.reqFailedCount) {
        stopRequest = YES;
    }
    else
    {
        self.reqFailedCount ++;
        if (self.delegate && [self.delegate respondsToSelector:@selector(onCallFailRequest:retryCount:)]) {
            [self.delegate onCallFailRequest:error retryCount:self.reqFailedCount];
        }
    }

    if (stopRequest) {
        //移除协议 防止多次进去
        self.delegate = nil;
        [[PBRequestManage sharedInstance] removeReqConfig:self withId:temSeqId];
    }
    else
    {
        if (tryHttpOnFail) {
            self.requestType = RequestType_HTTP;
            PBHttpChannelProxyRequest *httpRequest = [PBHttpChannelProxyRequest new];
            [httpRequest sendAsyncRequestWithMethod:method rpcData:reqData delegate:self.delegate];
        }
        else
        {
            if (self.delegate && [self.delegate respondsToSelector:@selector(onCallFail:)]) {
                [self.delegate onCallFail:error];
            }
        }
    }
}

@end
