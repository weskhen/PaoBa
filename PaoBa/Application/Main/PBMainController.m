//
//  PBMainController.m
//  PaoBa
//
//  Created by wujian on 2017/3/14.
//  Copyright © 2017年 wujian. All rights reserved.
//

#import "PBMainController.h"
#import "PBMainControllerProtocol.h"
#import "PBMainInteractor.h"
#import "PBMainPresenter.h"
#import "PBMainView.h"
#import "PBMainViewProtocol.h"

@interface PBMainController ()<PBMainControllerProtocol>


@end

@implementation PBMainController


- (instancetype)init
{
    self = [super init];
    if (self) {
        [self configVIPWithVCPrefix:@"Main"];
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    PBSend(self.cView, PBMainViewProtocol, buildView);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - PBMainControllerProtocol
- (void)setControllerFromSource:(PBMainControllFrom)source
{
    
}


@end
