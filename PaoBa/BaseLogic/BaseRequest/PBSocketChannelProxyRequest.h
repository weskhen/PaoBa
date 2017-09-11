//
//  PBSocketChannelProxyRequest.h
//  PaoBa
//
//  Created by wujian on 2017/3/16.
//  Copyright © 2017年 wujian. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PBNetworkProtocol.h"

@class PBRequestConfig;
@interface PBSocketChannelProxyRequest : NSObject

+ (PBSocketChannelProxyRequest *)sharedInstance;


//socket(TCP) 请求
-(void)asyncCallWithMethod:(NSString*)method reqData:(NSData*)reqData timeout:(int)timeoutValue delegate:(id) delegate;

//socket(UDP) 请求
-(void)notifyCallWithMethod:(NSString*)method reqData:(NSData*)reqData;

@end
