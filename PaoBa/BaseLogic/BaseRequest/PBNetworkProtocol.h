//
//  PBNetworkProtocol.h
//  PaoBa
//
//  Created by wujian on 2017/3/16.
//  Copyright © 2017年 wujian. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol PBHttpResponseDelegate <NSObject>

- (void)httpResponseSuccess:(NSString *)method forReqParam:(NSData *)reqData forRspData:(NSData *)rspData serverRequestsStatus:(PBServerRequestsStatus)requestsStatus networkReachabilityStatus:(PBNetworkReachabilityStatus)reachabilityStatus;

- (void)httpResponseFail:(NSString *)method forReqParam:(NSData *)reqData forError:(NSError *)error serverRequestsStatus:(PBServerRequestsStatus)requestsStatus networkReachabilityStatus:(PBNetworkReachabilityStatus)reachabilityStatus;

- (NSString *)getRequestURL;
@end

@protocol PBAsyncSocketDelegate <NSObject>


- (void)responseSuccess:(NSString *) method forReqParam:(NSData *) reqData forRspData:(NSData *) rspData;
- (void)responseFail:(NSString *) method forReqParam:(NSData *) reqData forError:(NSError *) error;

@end

@protocol PBClientAsyncNotifyServiceDelegate <NSObject>

#pragma mark this function is invoked by app thread but not mainui thread
- (void)notify:(NSString *)method forParam:(NSData *) param;

#pragma verify RSA Pubkey is vali
- (BOOL)verifyRSAPubkey:(NSData *)pubkey;


#pragma mark: following callback function is invoked within mainui thread
- (void)loginSuccess:(NSDictionary *)userInfo;
- (void)loginFail:(NSError *)errInfo;
- (void)forceDisConnected:(NSError *)errInfo;
- (void)reLoginSuccess:(NSDictionary *)userInfo;
- (void)onLogining;

@end
