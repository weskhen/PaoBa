//
//  PBRequestManage.h
//  PaoBa
//
//  Created by wujian on 2017/3/15.
//  Copyright © 2017年 wujian. All rights reserved.
//

#import <Foundation/Foundation.h>

@class PBRequestConfig;

/** 管理请求的类 **/
@interface PBRequestManage : NSObject

+ (PBRequestManage *)sharedInstance;

- (int)getNextReqId;
- (void)addReqConfig:(PBRequestConfig *)req withId:(int)seqid;
- (void)removeReqConfig:(PBRequestConfig *)req withId:(int)seqid;

@end
