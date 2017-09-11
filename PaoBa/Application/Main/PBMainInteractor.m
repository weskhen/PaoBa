//
//  PBMainInteractor.m
//  PaoBa
//
//  Created by wujian on 2017/3/14.
//  Copyright © 2017年 wujian. All rights reserved.
//

#import "PBMainInteractor.h"
#import "PBMainInteractorProtocol.h"
#import "PBSecondController.h"
#import "PBTalkController.h"
#import "PBTalkControllerProtocol.h"
#import "PBDetailUser.h"
#import "ServiceFactory.h"

@interface PBMainInteractor ()<PBMainInteractorProtocol>


@end

@implementation PBMainInteractor

#pragma mark - PBMainInteractorProtocol
- (void)gotoSecondController
{
    [[_Service getUserLogicService] getUserProfileFromServerWithUserId:@(12) andDelegate:self];

//    PBTalkController *talk = [PBTalkController new];
//    PBDetailUser *user = [PBDetailUser new];
//    user.userId = @(120000);
//    user.name = @"test1001";
//    user.avatarUrl = @"https://b-ssl.duitang.com/uploads/item/201305/03/20130503102908_fhhGN.thumb.700_0.jpeg";
//    user.isFollowing = @(0);
//    PBSend(talk, PBTalkControllerProtocol, setControllerFromSource:PBTalkControllerFrom_None talkUser:user);
//    [self.baseController.navigationController pushViewController:talk animated:YES];
//    PBSecondController *second = [PBSecondController new];
//    [self.baseController.navigationController pushViewController:second animated:YES];
}

@end
