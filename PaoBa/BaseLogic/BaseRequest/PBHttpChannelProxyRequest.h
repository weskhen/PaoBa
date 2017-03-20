//
//  PBHttpChannelProxyRequest.h
//  PaoBa
//
//  Created by wujian on 2017/3/16.
//  Copyright © 2017年 wujian. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PBHttpChannelProxyRequest : NSObject

//发送异步请求
- (void)sendAsyncRequestWithMethod:(NSString *)method rpcData:(NSData *)rpcData delegate:(id)delegate;

//发送同步请求
- (void)sendSyncRequestWithMethod:(NSString *)method rpcData:(NSData *)rpcData delegate:(id)delegate;

@end
