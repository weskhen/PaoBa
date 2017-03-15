//
//  PBMainView.m
//  PaoBa
//
//  Created by wujian on 2017/3/14.
//  Copyright © 2017年 wujian. All rights reserved.
//

#import "PBMainView.h"
#import "PBMainViewProtocol.h"
#import "PBMainInteractorProtocol.h"
#import "PBController.h"
#import "PBTestSubView.h"
#import "ServiceFactory.h"

@interface PBMainView ()<PBMainViewProtocol>

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIButton *jumpButton;
@property (nonatomic, strong) PBTestSubView *testSubView;
@end
@implementation PBMainView

#pragma mark - PBMainViewProtocol
- (void)buildView
{
    [self addSubview:self.titleLabel];
    [self addSubview:self.jumpButton];
    _titleLabel.frame = CGRectMake(0, 60, 200, 40);
    _jumpButton.frame = CGRectMake(20, 120, 240, 60);
    
    [self addSubview:self.testSubView];
    _testSubView.frame = CGRectMake(0, 200, 300, 300);
}

- (void)refreshMainView
{
    
}

#pragma mark - buttonEvent
- (void)jumpButtonClicked:(id)sender
{
    [[_Service getSystemPermissionService] judgeSystemAlbumPermissionsSuccess:^{
        
        PBSend(self.baseController.interactor, PBMainInteractorProtocol, gotoSecondController);
    } withFailedHandel:^(BOOL chmod) {
        //do somethiing
        
    }];
}

#pragma mark - setter/getter
- (UILabel *)titleLabel
{
    if (_titleLabel == nil) {
        _titleLabel = [UILabel new];
        _titleLabel.font = [UIFont systemFontOfSize:18];
        _titleLabel.textColor = [UIColor redColor];
        _titleLabel.text = @"Hello PUS";
    }
    return _titleLabel;
}

- (UIButton *)jumpButton
{
    if (_jumpButton == nil) {
        _jumpButton = [UIButton new];
        _jumpButton.backgroundColor = [UIColor clearColor];
        [_jumpButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_jumpButton setTitle:@"jump to next Controller" forState:UIControlStateNormal];
        [_jumpButton addTarget:self action:@selector(jumpButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _jumpButton;
}

- (PBTestSubView *)testSubView
{
    if (_testSubView == nil) {
        _testSubView = [PBTestSubView new];
    }
    return _testSubView;
}
@end
