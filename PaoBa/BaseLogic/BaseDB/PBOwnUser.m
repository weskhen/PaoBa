//
//  PBOwnUser.m
//  PaoBa
//
//  Created by wujian on 2017/8/18.
//  Copyright © 2017年 wujian. All rights reserved.
//

#import "PBOwnUser.h"
#import "PBDetailUser.h"

@implementation PBOwnUser

+ (PBOwnUser *)sharedInstance
{
    static PBOwnUser *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [PBOwnUser new];
    });
    return instance;
}


- (PBDetailUser *)getCurrentOwner
{
    PBDetailUser *user = [PBDetailUser new];
    user.userId = @(100001);
    user.name = @"我自己哦";
    user.avatarUrl = @"http://diy.qqjay.com/u/files/2012/0407/f4c7258692c1482833803ffcf452b932.jpg";
    return user;
}


@end
