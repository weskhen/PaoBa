//
//  BBAlertView.m
//  PaoBa
//
//  Created by wujian on 4/14/16.
//  Copyright © 2016 wesk痕. All rights reserved.
//

#import "BBAlertView.h"
#import <objc/runtime.h>

static char BBAlertViewDelegateKey;

static char BBAlertViewDidPresentBlockKey;
static char BBAlertViewClickedButtonBlockKey;

@interface BBAlertView ()<UIAlertViewDelegate>

@end

@implementation BBAlertView

- (instancetype)init
{
    self = [super init];
    if (self) {

    }
    return self;
}

- (void)checkDelegate
{
    if (self.delegate != self) {
        objc_setAssociatedObject(self, &BBAlertViewDelegateKey, self.delegate, OBJC_ASSOCIATION_ASSIGN);
        self.delegate = self;
    }
}

- (id<UIActionSheetDelegate>)originalDelegate
{
    return objc_getAssociatedObject(self, &BBAlertViewDelegateKey);
}

#pragma mark -

- (BBAlertViewBlock)didPresentBlock
{
    return objc_getAssociatedObject(self, &BBAlertViewDidPresentBlockKey);
}

- (void)setDidPresentBlock:(BBAlertViewBlock)didPresentBlock
{
    [self checkDelegate];
    objc_setAssociatedObject(self, &BBAlertViewDidPresentBlockKey, didPresentBlock, OBJC_ASSOCIATION_COPY);
}

- (BBAlertViewCompletionBlock)clickedButtonBlock
{
    return objc_getAssociatedObject(self, &BBAlertViewClickedButtonBlockKey);
}

- (void)setClickedButtonBlock:(BBAlertViewCompletionBlock)clickedButtonBlock
{
    [self checkDelegate];
    objc_setAssociatedObject(self, &BBAlertViewClickedButtonBlockKey, clickedButtonBlock, OBJC_ASSOCIATION_COPY);
}

#pragma mark - UIAlertViewDelegate

- (void)didPresentAlertView:(UIAlertView *)alertView
{
    BBAlertViewBlock block = self.didPresentBlock;
    if (block)
        block(alertView);
    
    id originalDelegate = [self originalDelegate];
    if ([originalDelegate respondsToSelector:@selector(didPresentAlertView:)])
        [originalDelegate didPresentAlertView:alertView];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    BBAlertViewCompletionBlock block = self.clickedButtonBlock;
    if (block)
        block(alertView, buttonIndex);
    
    id originalDelegate = [self originalDelegate];
    if ([originalDelegate respondsToSelector:@selector(alertView:clickedButtonAtIndex:)])
        [originalDelegate alertView:alertView clickedButtonAtIndex:buttonIndex];
}

@end
