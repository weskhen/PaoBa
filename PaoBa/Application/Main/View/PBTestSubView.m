//
//  PBTestSubView.m
//  PaoBa
//
//  Created by wujian on 2017/3/14.
//  Copyright © 2017年 wujian. All rights reserved.
//

#import "PBTestSubView.h"
#import "NSObject+BaseController.h"
#import "PBMainInteractorProtocol.h"
#import "PBController.h"

@interface PBTestSubView ()

@property (nonatomic, strong) UIButton *testButton;


@end
@implementation PBTestSubView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.testButton];
        _testButton.frame = CGRectMake(20, 20, 280, 80);
        
    }
    return self;
}
#pragma mark - buttonEvent

- (void)testButtonClicked:(id)sender
{
    PBSend(self.baseController.interactor, PBMainInteractorProtocol, gotoSecondController);
}

#pragma mark - setter/getter
- (UIButton *)testButton
{
    if (_testButton == nil) {
        _testButton = [UIButton new];
        _testButton.backgroundColor = [UIColor clearColor];
        [_testButton setTitleColor:[UIColor yellowColor] forState:UIControlStateNormal];
        [_testButton setTitle:@"test" forState:UIControlStateNormal];
        [_testButton addTarget:self action:@selector(testButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _testButton;
}

@end
