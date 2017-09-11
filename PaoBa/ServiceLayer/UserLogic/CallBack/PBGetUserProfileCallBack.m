//
//  PBGetUserProfileCallBack.m
//  PaoBa
//
//  Created by wujian on 2017/3/15.
//  Copyright © 2017年 wujian. All rights reserved.
//

#import "PBGetUserProfileCallBack.h"

@interface PBGetUserProfileCallBack ()

@property (nonatomic, copy) CallBackSuccessBlock successBlock;
@property (nonatomic, copy) CallBackFailedBlock  failedBlock;

@property (nonatomic, weak) id<PBGetUserProfileCallBackDelegate> delegate;
@end

@implementation PBGetUserProfileCallBack

- (void)getUserProfileFromServerWithUserId:(NSNumber *)userId
                               andDelegate:(id)delegate
{

    self.delegate = delegate;
    [self getUserProfileFromServerWithUserId:userId];
}

- (void)getUserProfileFromServerWithUserId:(NSNumber *)userId
                              successBlock:(CallBackSuccessBlock)successBlock
                                 failBlock:(CallBackFailedBlock)failBlock
{
    self.successBlock = successBlock;
    self.failedBlock = failBlock;
    [self getUserProfileFromServerWithUserId:userId];
}

- (void)getUserProfileFromServerWithUserId:(NSNumber *)userId
{
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    [dic setObject:@(0) forKey:@"codeType"];
    [dic setObject:@"18768177617" forKey:@"mobile"];
    
    NSData *reqData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:nil];
    [PBRequestEmitter asyncRequestWithMethod:@"POST.verification/get" reqData:reqData delegate:self];
}

- (void)onCallSuccess:(NSDictionary *)rspDictionary
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(onGetUserProfileSuccess:)]) {
        [self.delegate onGetUserProfileSuccess:nil];
    }
    
    if (self.successBlock)
    {
        self.successBlock();
    }
}

- (void)onCallFail:(NSError *)error networkReachabilityStatus:(PBNetworkReachabilityStatus)reachabilityStatus
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(onGetUserProfileFail:)]) {
        [self.delegate onGetUserProfileFail:error];
    }
    
    if (self.failedBlock) {
        self.failedBlock(error);
    }
}

- (NSString *)getRequestURL
{
    return @"http://10.0.0.4:8081";
}
@end
