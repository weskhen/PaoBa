//
//  PBHttpChannelProxyRequest.m
//  PaoBa
//
//  Created by wujian on 2017/3/16.
//  Copyright © 2017年 wujian. All rights reserved.
//

#import "PBHttpChannelProxyRequest.h"
#import "PBRequestEmitter.h"

@implementation PBHttpChannelProxyRequest


- (void)sendAsyncRequestWithMethod:(NSString *)method rpcData:(NSData *)rpcData delegate:(id<PBRequestEmitterDelegate>)delegate
{
    //对网络封装 发送请求
}

- (void)sendSyncRequestWithMethod:(NSString *)method rpcData:(NSData *)rpcData delegate:(id<PBRequestEmitterDelegate>)delegate
{

}
@end
