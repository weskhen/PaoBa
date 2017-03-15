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

@property (nonatomic, strong) PBMainPresenter *currentPresenter;
@property (nonatomic, strong) PBMainInteractor *currentInteractor;
@property (nonatomic, strong) PBMainView    *currentView;
@end

@implementation PBMainController
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
    
    self.view = _cView;
    PBSend(_cView, PBMainViewProtocol, buildView);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - PBMainControllerProtocol
- (void)setControllerFromSource:(PBMainControllFrom)source
{
    
}

#pragma mark - setter/getter
- (PBMainPresenter *)currentPresenter
{
    if (_currentPresenter == nil) {
        _currentPresenter = [PBMainPresenter new];
        _currentPresenter.baseController = self;
    }
    return _currentPresenter;
}

- (PBMainInteractor *)currentInteractor
{
    if (_currentInteractor == nil) {
        _currentInteractor = [PBMainInteractor new];
        _currentInteractor.baseController = self;
    }
    return _currentInteractor;
}

- (PBMainView *)currentView
{
    if (_currentView == nil) {
        _currentView = [PBMainView new];
        _currentView.baseController = self;
    }
    return _currentView;
}
@end
