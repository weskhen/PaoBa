//
//  PBRequestCallBack.h
//  PaoBa
//
//  Created by wujian on 2017/3/16.
//  Copyright © 2017年 wujian. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PBRequestEmitter.h"

@interface PBRequestCallBack : NSObject<PBRequestEmitterDelegate>

typedef void (^CallBackFailedBlock)(NSError *error);
typedef void (^CallBackSuccessBlock)();

/**
 *  @brif 第一次就使用http通道
 **/
@property (nonatomic, assign)  BOOL useSocketOnFirstTry;
/**
 * @brif 第一次使用socket通道，失败后再尝试http通道
 **/
@property (nonatomic, assign)  BOOL useHttpOnFirstFail;

/**
 * @brif 第一次使用http通道，失败后再尝试socket通道
 **/
@property (nonatomic, assign)  BOOL useSocketOnFirstFail;

/**
 * @brif 请求超时时间
 **/
@property (nonatomic, assign)  int  timeoutValue;

/**
 * @brif 接口请求失败重试次数
 **/
@property (nonatomic, assign)  int  reqFailRetryCount;

@end
