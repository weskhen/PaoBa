//
//  PBMainInteractor.m
//  PaoBao
//
//  Created by wujian on 2017/3/14.
//  Copyright © 2017年 wujian. All rights reserved.
//

#import "PBMainInteractor.h"
#import "PBMainInteractorProtocol.h"
#import "PBSecondController.h"

@interface PBMainInteractor ()<PBMainInteractorProtocol>


@end

@implementation PBMainInteractor

#pragma mark - PBMainInteractorProtocol
- (void)gotoSecondController
{
    PBSecondController *second = [PBSecondController new];
    [self.baseController.navigationController pushViewController:second animated:YES];
}

@end
