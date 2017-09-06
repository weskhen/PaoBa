//
//  PBController.m
//  PaoBa
//
//  Created by wujian on 2017/3/14.
//  Copyright © 2017年 wujian. All rights reserved.
//

#import "PBController.h"

@interface PBController ()

@property (nonatomic, assign) BOOL vipEnable;

@end

@implementation PBController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    if (self.vipEnable) {
        _cView.frame = self.view.frame;
        self.view = _cView;
    }
    self.view.backgroundColor = [UIColor whiteColor];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//基于VIP模式
- (void)configVIPWithVCPrefix:(NSString *)name
{
    self.vipEnable = YES;
    //presentor
    Class presenterClass = NSClassFromString([NSString stringWithFormat:@"PB%@Presenter", name]);
    if (presenterClass != NULL) {
        PBPresenter *presenter = (PBPresenter *)[presenterClass new];
        presenter.baseController = self;
        _presenter = presenter;
    }
    
    //interactor
    Class interactorClass = NSClassFromString([NSString stringWithFormat:@"PB%@Interactor", name]);
    if (interactorClass != NULL) {
        PBInteractor *interactor = (PBInteractor *)[interactorClass new];
        interactor.baseController = self;
        _interactor = interactor;
    }
    
    //view
    Class viewClass = NSClassFromString([NSString stringWithFormat:@"PB%@View", name]);
    if (viewClass != NULL) {
        PBView *cView = (PBView *)[viewClass new];
        cView.baseController = self;
        _cView = cView;
    }
    
}


- (void)updateNavTitle:(NSString *)title
{
    self.navigationItem.title = title;
}

@end
