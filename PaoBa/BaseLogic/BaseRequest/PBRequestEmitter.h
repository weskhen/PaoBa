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
/**
 * @brif 请求成功
 **/
- (void)onCallSuccess:(NSData*)rspData;

/**
 * @brif 请求失败
 **/
- (void)onCallFail:(NSError*)errorInfo;

@optional

/**
 * @brif 当前请求失败 count 第几次重试
 **/
- (void)onCallFailRequest:(NSError *)errorInfo retryCount:(int)count;

/**
 * @brif 第一次请求是否切换到Socket通道
 **/
- (BOOL)switchToSocketChannel;


/**
 * @brif socket通道请求失败后尝试http通道
 **/
- (BOOL)shouldTryHttpChannelOnFail;


/**
 * @brif http通道请求失败后尝试socket通道
 **/
- (BOOL)shouldTrySocketChannelOnFail;

/**
 * @brif 获取自定义的请求超时时间
 **/
- (int)getCustomTimeoutValue;

/**
 * @brif 获取请求的URL
 **/
- (NSString*)getRequestURL;

/**
 * @brif 获取请求失败重试次数
 **/
- (int)getRequestFailRetryCount;

@end

//请求发射器 app 请求通过这个类去分发实现
@interface PBRequestEmitter : NSObject

/** 
 * @brif http/tcp请求 
 **/
+ (void)asyncRequestWithMethod:(NSString *)method reqData:(NSData *)reqData delegate:(id<PBRequestEmitterDelegate>)delegate;

/** 
 * @brif udp请求
 **/
+ (void)notifyCallWithMethod:(NSString *)method reqData:(NSData *)reqData;

@end
