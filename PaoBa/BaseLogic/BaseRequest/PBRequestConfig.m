//
//  PBRequestConfig.m
//  PaoBa
//
//  Created by wujian on 2017/3/15.
//  Copyright © 2017年 wujian. All rights reserved.
//

#import "PBRequestConfig.h"
#import "PBNetworkProtocol.h"
#import "PBRequestManage.h"
#import "PBHttpChannelProxyRequest.h"
#import "PBNetworking.h"

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
    if (self.delegate && [self.delegate respondsToSelector:@selector(onCallSuccess:serverRequestsStatus:networkReachabilityStatus:)]) {
        [self.delegate onCallSuccess:rspData serverRequestsStatus:PBServerRequestsStatusSuccess networkReachabilityStatus:[PBNetworking appNetworkReachabilityStatus]];
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
        if (self.delegate && [self.delegate respondsToSelector:@selector(onCallFail:serverRequestsStatus:networkReachabilityStatus:)]) {
            [self.delegate onCallFail:error serverRequestsStatus:PBServerRequestsStatusFail networkReachabilityStatus:[PBNetworking appNetworkReachabilityStatus]];
        }
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
            //TCP
            self.requestType = RequestType_SOCKET_TCP;

        }
    }
}


#pragma mark - PBHttpResponseDelegate
- (void)httpResponseSuccess:(NSString *)method forReqParam:(NSData *)reqData forRspData:(NSData *)rspData serverRequestsStatus:(PBServerRequestsStatus)requestsStatus networkReachabilityStatus:(PBNetworkReachabilityStatus)reachabilityStatus
{
    int temSeqId = self.reqId;
    if (self.delegate && [self.delegate respondsToSelector:@selector(onCallSuccess:serverRequestsStatus:networkReachabilityStatus:)]) {
        [self.delegate onCallSuccess:rspData serverRequestsStatus:requestsStatus networkReachabilityStatus:reachabilityStatus];
    }
    //移除协议 防止多次进去
    self.delegate = nil;
    [[PBRequestManage sharedInstance] removeReqConfig:self withId:temSeqId];
}

- (void)httpResponseFail:(NSString *)method forReqParam:(NSData *)reqData forError:(NSError *)error serverRequestsStatus:(PBServerRequestsStatus)requestsStatus networkReachabilityStatus:(PBNetworkReachabilityStatus)reachabilityStatus
{
    int temSeqId = self.reqId;
    BOOL trySocketOnFail = false;
    if ([self.delegate respondsToSelector:@selector(shouldTrySocketChannelOnFail)]) {
        trySocketOnFail = [self.delegate shouldTrySocketChannelOnFail];
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
        if (self.delegate && [self.delegate respondsToSelector:@selector(onCallFail:serverRequestsStatus:networkReachabilityStatus:)]) {
            [self.delegate onCallFail:error serverRequestsStatus:requestsStatus networkReachabilityStatus:reachabilityStatus];
        }
        //移除协议 防止多次进去
        self.delegate = nil;
        [[PBRequestManage sharedInstance] removeReqConfig:self withId:temSeqId];
    }
    else
    {
        if (trySocketOnFail) {
            self.requestType = RequestType_SOCKET_TCP;
            //TCP
            
        }
        else
        {
            self.requestType = RequestType_HTTP;
            PBHttpChannelProxyRequest *httpRequest = [PBHttpChannelProxyRequest new];
            [httpRequest sendAsyncRequestWithMethod:method rpcData:reqData delegate:self];
        }
    }
}

- (NSString *)getRequestURL
{
    return self.baseUrl;
}

@end
