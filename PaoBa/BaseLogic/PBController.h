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
#import "PBCView.h"

@interface PBController : UIViewController

@property (nonatomic, weak, readonly) PBPresenter *presenter;
@property (nonatomic, weak, readonly) PBInteractor *interactor;
@property (nonatomic, weak, readonly) PBCView *cView;

@end
