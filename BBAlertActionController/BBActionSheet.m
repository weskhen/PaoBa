//
//  BBActionSheet.m
//  PaoBa
//
//  Created by wujian on 4/14/16.
//  Copyright © 2016 wesk痕. All rights reserved.
//

#import "BBActionSheet.h"
#import <objc/runtime.h>

static char BBActionSheetDelegateKey;
static char BBActionSheetDidPresentBlockKey;
static char BBActionSheetClickedButtonBlockKey;

@interface BBActionSheet () <UIActionSheetDelegate>

@end

@implementation BBActionSheet

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
        objc_setAssociatedObject(self, &BBActionSheetDelegateKey, self.delegate, OBJC_ASSOCIATION_ASSIGN);
        self.delegate = self;
    }
}

- (id<UIActionSheetDelegate>)originalDelegate
{
    return objc_getAssociatedObject(self, &BBActionSheetDelegateKey);
}

#pragma mark -

- (BBActionSheetBlock)didPresentBlock
{
    return objc_getAssociatedObject(self, &BBActionSheetDidPresentBlockKey);
}

- (void)setDidPresentBlock:(BBActionSheetBlock)didPresentBlock
{
    [self checkDelegate];
    objc_setAssociatedObject(self, &BBActionSheetDidPresentBlockKey, didPresentBlock, OBJC_ASSOCIATION_COPY);
}

- (BBActionSheetCompletionBlock)clickedButtonBlock
{
    return objc_getAssociatedObject(self, &BBActionSheetClickedButtonBlockKey);
}

- (void)setClickedButtonBlock:(BBActionSheetCompletionBlock)clickedButtonBlock
{
    [self checkDelegate];
    objc_setAssociatedObject(self, &BBActionSheetClickedButtonBlockKey, clickedButtonBlock, OBJC_ASSOCIATION_COPY);
}

#pragma mark - UIActionSheetDelegate

- (void)didPresentActionSheet:(UIActionSheet *)actionSheet
{
    BBActionSheetBlock block = self.didPresentBlock;
    if (block)
        block(actionSheet);
    
    id originalDelegate = [self originalDelegate];
    if ([originalDelegate respondsToSelector:@selector(didPresentActionSheet:)])
        [originalDelegate didPresentActionSheet:actionSheet];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    BBActionSheetCompletionBlock block = self.clickedButtonBlock;
    if (block)
        block(actionSheet, buttonIndex);
    
    id originalDelegate = [self originalDelegate];
    if ([originalDelegate respondsToSelector:@selector(actionSheet:clickedButtonAtIndex:)])
        [originalDelegate actionSheet:actionSheet clickedButtonAtIndex:buttonIndex];
}



@end
