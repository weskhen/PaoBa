//
//  PBSecondController.m
//  PaoBao
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

@property (nonatomic, strong) PBSecondPresenter *currentPresenter;
@property (nonatomic, strong) PBSecondInteractor *currentInteractor;
@property (nonatomic, strong) PBSecondView    *currentView;

@end

@implementation PBSecondController
@synthesize presenter = _presenter;
@synthesize interactor = _interactor;
@synthesize cView = _cView;

- (instancetype)init
{
    self = [super init];
    if (self) {
        if (_presenter == nil) {
            _presenter = self.currentPresenter;
        }
        if (_interactor == nil) {
            _interactor = self.currentInteractor;
        }
        if (_currentView == nil) {
            _cView = self.currentView;
        }
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


#pragma mark - setter/getter
- (PBSecondPresenter *)currentPresenter
{
    if (_currentPresenter == nil) {
        _currentPresenter = [PBSecondPresenter new];
        _currentPresenter.baseController = self;
    }
    return _currentPresenter;
}

- (PBSecondInteractor *)currentInteractor
{
    if (_currentInteractor == nil) {
        _currentInteractor = [PBSecondInteractor new];
        _currentInteractor.baseController = self;
    }
    return _currentInteractor;
}
- (PBSecondView *)currentView
{
    if (_currentView == nil) {
        _currentView = [PBSecondView new];
        _currentView.baseController = self;
    }
    return _currentView;
}

@end
