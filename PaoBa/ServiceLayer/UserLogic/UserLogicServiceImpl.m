//
//  UserLogicServiceImpl.m
//  PaoBa
//
//  Created by wujian on 4/18/16.
//  Copyright © 2016 wesk痕. All rights reserved.
//

#import "UserLogicServiceImpl.h"
#import "PBGetUserProfileCallBack.h"

@implementation UserLogicServiceImpl

- (void)getUserProfileFromServerWithUserId:(NSNumber *)userId andDelegate:(id)delegate
{
    PBGetUserProfileCallBack *callBack = [PBGetUserProfileCallBack new];
    [callBack getUserProfileFromServerWithUserId:userId andDelegate:self];
}

- (void)modifyUserWithName:(NSString *)name andDelegate:(id)delegate
{
    
}
@end
