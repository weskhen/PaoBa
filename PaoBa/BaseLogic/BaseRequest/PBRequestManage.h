//
//  PBRequestManage.h
//  PaoBa
//
//  Created by wujian on 2017/3/15.
//  Copyright © 2017年 wujian. All rights reserved.
//

#import <Foundation/Foundation.h>

@class PBRequestCommon;
@interface PBRequestManage : NSObject

+ (PBRequestManage *)sharedInstance;

- (int)getNextReqId;
- (void)addReq:(PBRequestCommon *)req withId:(int)seqid;
- (void)removeReq:(PBRequestCommon *)req withId:(int)seqid;

@end
