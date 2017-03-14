//
//  PBMainPresenter.m
//  PaoBao
//
//  Created by wujian on 2017/3/14.
//  Copyright © 2017年 wujian. All rights reserved.
//

#import "PBMainPresenter.h"
#import "PBMainPresenterProtocol.h"
#import "PBController.h"
#import "PBMainInteractorProtocol.h"

@interface PBMainPresenter ()<PBMainPresenterProtocol>

@end
@implementation PBMainPresenter

#pragma mark - PBMainPresenterProtocol
- (NSArray *)getMainTableDataArray
{
    return nil;
}

#pragma mark - PrivateMethod
- (void)detectJump
{
    PBSend(self.baseController.interactor, PBMainInteractorProtocol, gotoSecondController);
}

@end
