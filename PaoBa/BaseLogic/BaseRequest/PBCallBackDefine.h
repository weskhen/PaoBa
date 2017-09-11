//
//  PBCallBackDefine.h
//  PaoBa
//
//  Created by wujian on 2017/9/11.
//  Copyright © 2017年 wujian. All rights reserved.
//

#ifndef PBCallBackDefine_h
#define PBCallBackDefine_h
#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, PBNetworkReachabilityStatus) {
    PBNetworkReachabilityStatusUnkonw             = -1,   // 未知网络
    PBNetworkReachabilityStatusNotReachable       = 0,    // 网络无法链接
    PBNetworkReachabilityStatusReachableViaWWAN   = 1,    // 2，3，4G
    PBNetworkReachabilityStatusReachableViaWiFi   = 2     // WIFI
};


typedef NS_ENUM(NSUInteger, PBServerRequestsStatus) {
    PBServerRequestsStatusFail              = 0,        // 请求失败
    PBServerRequestsStatusSuccess           = 1,        // 请求成功
    PBServerRequestsStatusNotConnected      = 2,        // 无法连接
    PBServerRequestsStatusconnectedTimeOut  = 3         // 请求超时
};


#endif /* PBCallBackDefine_h */
