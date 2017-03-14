//
//  PBSecondPresenter.m
//  PaoBao
//
//  Created by wujian on 2017/3/14.
//  Copyright © 2017年 wujian. All rights reserved.
//

#import "PBSecondPresenter.h"
#import "PBSecondPresenterProtocol.h"
#import "PBController.h"

@interface PBSecondPresenter ()<PBSecondPresenterProtocol>

@end
@implementation PBSecondPresenter

#pragma mark - PBSecondPresenterProtocol
- (NSArray *)getSecondTableDataArray
{
    return nil;
}

#pragma mark - PrivateMethod
- (void)detectJump
{

}

@end
