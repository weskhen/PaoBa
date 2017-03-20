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

@property (nonatomic, assign)  BOOL useSocketOnFirstTry; //第一次就使用http通道
@property (nonatomic, assign)  BOOL useHttpOnFirstFail; //第一次使用socket通道，失败后再尝试http通道
@property (nonatomic, assign)  int  timeoutValue;

@property (nonatomic, assign)  int  ReqFailRetryCount;

@end
