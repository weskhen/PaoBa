//
//  PBHttpChannelProxyRequest.m
//  PaoBa
//
//  Created by wujian on 2017/3/16.
//  Copyright © 2017年 wujian. All rights reserved.
//

#import "PBHttpChannelProxyRequest.h"
#import "PBRequestEmitter.h"
#import "PBNetworking.h"

@interface PBHttpChannelProxyRequest ()

@property (nonatomic, weak) id <PBRequestEmitterDelegate> delegate;
@end
@implementation PBHttpChannelProxyRequest


- (void)sendAsyncRequestWithMethod:(NSString *)method rpcData:(NSData *)rpcData delegate:(id<PBRequestEmitterDelegate>)delegate
{
    self.delegate = delegate;
    //对网络封装 发送请求
    NSString *baseUrl = [delegate getRequestURL];
    NSArray *methodList = [method componentsSeparatedByString:@"."];
    NSString *methodType = [methodList firstObject];
    NSString *pathString = nil;
    
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:rpcData options:NSJSONReadingMutableContainers error:nil];
    if (methodList.count >= 2) {
        pathString = [methodList objectAtIndex:1];
    }
    if ([methodType isEqualToString:@"GET"]) {
        __weak __typeof(self)weakSelf = self;
        
        NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
        [dic setObject:@"keep-alive" forKey:@"Connection"];
        [dic setObject:@"no-cache" forKey:@"Pragma"];

        [PBNetworking configCommonHttpHeaders:dic];
        [PBNetworking getWithUrl:[NSString stringWithFormat:@"%@/%@",baseUrl,pathString] params:dic success:^(PBServerRequestsStatus status, PBNetworkReachabilityStatus reachability, id response) {
            __strong __typeof(weakSelf)strongSelf = weakSelf;
            if ([response isKindOfClass:[NSDictionary class]]) {
                
            }
            else
            {
                
            }
            
        } fail:^(PBServerRequestsStatus status, PBNetworkReachabilityStatus reachability, id response, NSError *error) {
            __strong __typeof(weakSelf)strongSelf = weakSelf;

        }];
    }
    else if ([methodType isEqualToString:@"POST"])
    {
        __weak __typeof(self)weakSelf = self;
        [PBNetworking postWithUrl:[NSString stringWithFormat:@"%@/%@",baseUrl,pathString] params:dic success:^(PBServerRequestsStatus status, PBNetworkReachabilityStatus reachability, id response) {
            __strong __typeof(weakSelf)strongSelf = weakSelf;
            NSLog(@"responseObject:%@",response);
        } fail:^(PBServerRequestsStatus status, PBNetworkReachabilityStatus reachability, id response, NSError *error) {
            __strong __typeof(weakSelf)strongSelf = weakSelf;

        }];
    }
    else if ([methodType isEqualToString:@"DELETE"])
    {
        
    }
}

- (void)sendSyncRequestWithMethod:(NSString *)method rpcData:(NSData *)rpcData delegate:(id<PBRequestEmitterDelegate>)delegate
{

}
@end
