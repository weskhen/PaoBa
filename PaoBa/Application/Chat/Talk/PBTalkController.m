//
//  PBTalkController.m
//  PaoBa
//
//  Created by wujian on 2017/3/14.
//  Copyright © 2017年 wujian. All rights reserved.
//

#import "PBTalkController.h"
#import "PBTalkControllerProtocol.h"
#import "PBTalkInteractor.h"
#import "PBTalkPresenter.h"
#import "PBTalkView.h"
#import "PBTalkViewProtocol.h"
#import "PBTalkPresenterProtocol.h"
#import "PBDetailUser.h"

@interface PBTalkController ()<PBTalkControllerProtocol>

@property (nonatomic, assign) PBTalkControllerFrom fromSource;
@end

@implementation PBTalkController

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self configVIPWithVCPrefix:@"Talk"];
    }
    return self;
}

- (void)dealloc
{
    TraceS(@"PBTalkController dealloc");
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    if ([self respondsToSelector:@selector(setEdgesForExtendedLayout:)]){
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    self.automaticallyAdjustsScrollViewInsets = NO;

    PBSend(self.cView, PBTalkViewProtocol, buildView);
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (self.fromSource == PBTalkControllerFrom_None) {
        self.navigationController.navigationBarHidden = NO;
    }
    else{
        self.navigationController.navigationBarHidden = YES;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - PBTalkControllerProtocol
- (void)setControllerFromSource:(PBTalkControllerFrom )source talkUser:(PBDetailUser *)dstUser
{
    self.fromSource = source;
    [self updateNavTitle:dstUser.name];
    PBSend(self.presenter, PBTalkPresenterProtocol, setTalkUser:dstUser);
}

#pragma mark - setter/getter
@end
