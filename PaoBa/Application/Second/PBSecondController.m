//
//  PBSecondController.m
//  PaoBa
//
//  Created by wujian on 2017/3/14.
//  Copyright © 2017年 wujian. All rights reserved.
//

#import "PBSecondController.h"
#import "PBSecondControllerProtocol.h"
#import "PBSecondInteractor.h"
#import "PBSecondPresenter.h"
#import "PBSecondView.h"

@interface PBSecondController ()<PBSecondControllerProtocol>



@end

@implementation PBSecondController

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self configVIPWithVCPrefix:@"Second"];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
}

- (void)dealloc
{
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - PBSecondControllerProtocol


@end
