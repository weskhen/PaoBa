//
//  NSObject+BaseController.m
//  ResponderBaseController
//
//  Created by wujian on 6/28/16.
//  Copyright © 2016 wesk痕. All rights reserved.
//

#import "NSObject+BaseController.h"
#import <objc/runtime.h>
#import <UIKit/UIKit.h>
#import "PBController.h"

@implementation NSObject (BaseController)

- (void)setBaseController:(UIViewController *)baseController
{
    objc_setAssociatedObject(self, @selector(baseController), baseController, OBJC_ASSOCIATION_ASSIGN);
}

- (PBController *)baseController
{
    id curController = objc_getAssociatedObject(self, @selector(baseController));
    if (curController == nil && [self isKindOfClass:[UIResponder class]]) {
        curController = self;
        while (![curController isKindOfClass:[PBController class]]) {
            if ([curController nextResponder]) {
                curController = [curController nextResponder];
            }
            else
            {
                curController = nil;
                break;
            }
        }
    }
    return curController;
}

@end
