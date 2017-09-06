//
//  PBController.h
//  PaoBa
//
//  Created by wujian on 2017/3/14.
//  Copyright © 2017年 wujian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PBPresenter.h"
#import "PBInteractor.h"
#import "PBView.h"

@interface PBController : UIViewController

@property (nonatomic, strong, readonly) PBPresenter *presenter;
@property (nonatomic, strong, readonly) PBInteractor *interactor;
@property (nonatomic, strong, readonly) PBView *cView;


//基于VIP模式
- (void)configVIPWithVCPrefix:(NSString *)name;

- (void)updateNavTitle:(NSString *)title;

@end
