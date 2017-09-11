//
//  PBSocketChannelProxyRequest.m
//  PaoBa
//
//  Created by wujian on 2017/3/16.
//  Copyright © 2017年 wujian. All rights reserved.
//

#import "PBSocketChannelProxyRequest.h"
#import "PBRequestEmitter.h"
#import "PBNetworkProtocol.h"

@interface PBSocketChannelProxyRequest ()

@property (nonatomic, weak) id <PBAsyncSocketDelegate> delegate;
@end
@implementation PBSocketChannelProxyRequest

+ (PBSocketChannelProxyRequest *)sharedInstance
{
    static PBSocketChannelProxyRequest *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [PBSocketChannelProxyRequest new];
    });
    return instance;
}


- (void)asyncCallWithMethod:(NSString*)method reqData:(NSData*)reqData timeout:(int)timeoutValue delegate:(id) delegate
{
    self.delegate = delegate;
    
}

- (void)notifyCallWithMethod:(NSString*)method reqData:(NSData*)reqData
{
    
}

@end
