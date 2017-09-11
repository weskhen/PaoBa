//
//  PBRequestCallBack.m
//  PaoBa
//
//  Created by wujian on 2017/3/16.
//  Copyright © 2017年 wujian. All rights reserved.
//

#import "PBRequestCallBack.h"
#import "PBRequestConfig.h"

@implementation PBRequestCallBack


- (instancetype)init
{
    self = [super init];
    if (self) {
        self.reqFailRetryCount = 0;
        self.timeoutValue = PBKCallTimeout;
    }
    return self;
}

- (id)parseFormPesponseData:(id)responseData
{
    if ([responseData isKindOfClass:[NSData class]]) {
        // 尝试解析成JSON
        if (responseData == nil) {
            return responseData;
        } else {
            NSError *error = nil;
            NSDictionary *response = [NSJSONSerialization JSONObjectWithData:responseData
                                                                     options:NSJSONReadingMutableContainers
                                                                       error:&error];
            
            if (error != nil) {
                return responseData;
            } else {
                return response;
            }
        }
    }
    else {
        return responseData;
    }
}

#pragma mark - PBRequestEmitterDelegate
- (void)onCallSuccess:(NSDictionary *)rspDictionary
{
    
}

- (void)onCallFail:(NSError *)error networkReachabilityStatus:(PBNetworkReachabilityStatus)reachabilityStatus
{

}

#pragma mark - RequestEmitterDelegate
- (void)onCallSuccess:(NSData *)rspData serverRequestsStatus:(PBServerRequestsStatus)requestsStatus networkReachabilityStatus:(PBNetworkReachabilityStatus)reachabilityStatus
{
    id responseData = [self parseFormPesponseData:rspData];
    if ([responseData isKindOfClass:[NSDictionary class]]) {
        NSDictionary *errorDic = [responseData objectForKey:@"error"];
        if (errorDic && [[errorDic objectForKey:@"code"] intValue] == 0) {
            //返回正常数据
            [self onCallSuccess:responseData];
        }
        else
        {
            NSError *error = [NSError errorWithDomain:@"PBCustomDomain" code:-999 userInfo:errorDic];
            [self onCallFail:error networkReachabilityStatus:reachabilityStatus];
        }
    }
    else
    {
        NSLog(@"server 返回的数据格式有问题！！！！！");
    }
}

- (void)onCallFail:(NSError *)errorInfo serverRequestsStatus:(PBServerRequestsStatus)requestsStatus networkReachabilityStatus:(PBNetworkReachabilityStatus)reachabilityStatus
{
    [self onCallFail:errorInfo networkReachabilityStatus:reachabilityStatus];
}

//第一次请求是否切换到Socket通道
- (BOOL)switchToSocketChannel
{
    return self.useSocketOnFirstTry;
}

// socket通道请求失败后尝试http通道
- (BOOL)shouldTryHttpChannelOnFail
{
    return self.useHttpOnFirstFail;
}

//http通道请求失败后尝试socket通道
- (BOOL)shouldTrySocketChannelOnFail
{
    return self.useSocketOnFirstFail;
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
    return self.reqFailRetryCount;
}
@end
