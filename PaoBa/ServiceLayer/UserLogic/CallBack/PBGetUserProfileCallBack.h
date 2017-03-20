//
//  PBGetUserProfileCallBack.h
//  PaoBa
//
//  Created by wujian on 2017/3/15.
//  Copyright © 2017年 wujian. All rights reserved.
//

#import "PBRequestCallBack.h"

@protocol PBGetUserProfileCallBackDelegate <NSObject>

- (void)onGetUserProfileSuccess:(id)result;
- (void)onGetUserProfileFail:(NSError *)error;

@end
@interface PBGetUserProfileCallBack : PBRequestCallBack

- (void)getUserProfileFromServerWithUserId:(NSNumber *)userId
                               andDelegate:(id)delegate;

- (void)getUserProfileFromServerWithUserId:(NSNumber *)userId
                              successBlock:(CallBackSuccessBlock)successBlock
                                 failBlock:(CallBackFailedBlock)failBlock;
@end
