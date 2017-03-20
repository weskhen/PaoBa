//
//  PBRequestEmitter.h
//  PaoBa
//
//  Created by wujian on 2017/3/16.
//  Copyright © 2017年 wujian. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol PBRequestEmitterDelegate <NSObject>

@required
- (void)onCallSuccess:(NSData*)rspData;
- (void)onCallFail:(NSError*)errorInfo;

@optional
//第一次请求是否切换到Socket通道
- (BOOL)switchToSocketChannel;

//第一次请求失败后尝试http通道
- (BOOL)shouldTryHttpChannelOnFail;

//获取自定义的请求超时时间
- (int)getCustomTimeoutValue;

- (NSString*)getRequestURL;

- (int)getRequestFailRetryCount;
@end

//请求发射器 app 请求通过这个类去分发实现
@interface PBRequestEmitter : NSObject

/** http/tcp请求 **/
+ (void)asyncRequestWithMethod:(NSString *)method reqData:(NSData *)reqData delegate:(id<PBRequestEmitterDelegate>)delegate;

/** udp请求 **/
+ (void)notifyCallWithMethod:(NSString *)method reqData:(NSData *)reqData;

@end
