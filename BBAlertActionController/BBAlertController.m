//
//  BBAlertController.m
//  PaoBa
//
//  Created by wujian on 4/14/16.
//  Copyright © 2016 wesk痕. All rights reserved.
//

#import "BBAlertController.h"
#import "BBActionSheet.h"
#import "BBAlertView.h"

#pragma mark - BBAlertAction

@interface BBAlertAction ()

@property (nonatomic, copy) BBAlertActionHandler handler;

@end

@implementation BBAlertAction

+ (instancetype)actionWithTitle:(NSString *)title style:(BBAlertActionStyle)style handler:(BBAlertActionHandler)handler
{
    return [[self alloc] initWithTitle:title style:style handler:handler];
}

- (instancetype)initWithTitle:(NSString *)title style:(BBAlertActionStyle)style handler:(BBAlertActionHandler)handler
{
    self = [super init];
    if (self) {
        _title = title;
        _style = style;
        _handler = handler;
    }
    return self;
}

#pragma mark - NSCopying

- (instancetype)copyWithZone:(NSZone *)zone
{
    return [[BBAlertAction allocWithZone:zone] initWithTitle:self.title.copy style:self.style handler:self.handler];
}


@end


#pragma mark - BBAlertController

@interface BBAlertController ()

@property (nonatomic, strong) NSMutableArray *mutableActions;
@property (nonatomic, strong) NSMutableArray *mutableTextFields;

@property (nonatomic, strong) NSMutableDictionary *configurationHandlers;

@end

@implementation BBAlertController

+ (instancetype)alertControllerWithTitle:(NSString *)title message:(NSString *)message preferredStyle:(BBAlertControllerStyle)preferredStyle;
{
    return [[self alloc] initWithTitle:title message:message preferredStyle:preferredStyle];
}

- (instancetype)initWithTitle:(NSString *)title message:(NSString *)message preferredStyle:(BBAlertControllerStyle)preferredStyle;
{
    if (self = [super init]) {
        _title = title;
        _message = message;
        _preferredStyle = preferredStyle;
        
        _mutableActions = [NSMutableArray array];
        _mutableTextFields = [NSMutableArray array];
        
        _configurationHandlers = [NSMutableDictionary dictionary];
    }
    return self;
}

#pragma mark -

- (NSArray *)actions
{
    return self.mutableActions.copy;
}

- (NSArray *)textFields
{
    return self.mutableTextFields.copy;
}

#pragma mark -

- (void)addAction:(BBAlertAction *)action;
{
    [self.mutableActions addObject:action];
}

- (void)addTextFieldWithConfigurationHandler:(void (^)(UITextField *textField))configurationHandler;
{
    UITextField *textField = [UITextField new];
    if (configurationHandler)
        configurationHandler(textField);
    [self.mutableTextFields addObject:textField];
    
    if (configurationHandler)
        self.configurationHandlers[[NSValue valueWithNonretainedObject:textField]] = configurationHandler;
}

#pragma mark - NSCopying

- (instancetype)copyWithZone:(NSZone *)zone
{
    BBAlertController *alertController = [[BBAlertController allocWithZone:zone] initWithTitle:self.title.copy message:self.message.copy preferredStyle:self.preferredStyle];
    
    for (BBAlertAction *action in self.actions) {
        [alertController addAction:action.copy];
    }
    
    for (UITextField *textField in self.textFields) {
        [alertController addTextFieldWithConfigurationHandler:self.configurationHandlers[[NSValue valueWithNonretainedObject:textField]]];
    }
    
    return alertController;
}

@end

#pragma mark - UIViewController (BBAlertController)

@implementation UIViewController (BBAlertController)

- (void)presentAlertController:(BBAlertController *)alertController animated:(BOOL)animated completion:(void (^)(void))completion;
{
    if ([UIAlertController class]) {
        UIAlertController *newAlertController = [UIAlertController alertControllerWithTitle:alertController.title message:alertController.message preferredStyle:(UIAlertControllerStyle)alertController.preferredStyle];
        
        for (BBAlertAction *action in alertController.actions) {
            UIAlertAction *newAction = [UIAlertAction actionWithTitle:action.title style:(UIAlertActionStyle)action.style handler:^(UIAlertAction *newAction) {
                if (action.handler)
                    action.handler(action);
            }];
            [newAlertController addAction:newAction];
        }
        
        for (UITextField *textField in alertController.textFields) {
            [newAlertController addTextFieldWithConfigurationHandler:^(UITextField *newTextField) {
                void (^handler)(UITextField *textField) = alertController.configurationHandlers[[NSValue valueWithNonretainedObject:textField]];
                if (handler)
                    handler(newTextField);
            }];
        }
        
        [self presentViewController:newAlertController animated:animated completion:completion];
    } else {
        if (alertController.preferredStyle == BBAlertControllerStyleAlert) {
            BBAlertView *alertView = [[BBAlertView alloc] initWithTitle:alertController.title message:alertController.message delegate:nil cancelButtonTitle:nil otherButtonTitles:nil];
            
            for (BBAlertAction *action in alertController.actions) {
                [alertView addButtonWithTitle:action.title];
                
                if (alertView.cancelButtonIndex == -1 && action.style == BBAlertActionStyleCancel)
                    alertView.cancelButtonIndex = alertView.numberOfButtons - 1;
                
                action.enabled = YES;
            }
            
            if (alertController.textFields.count) {
                if (alertController.textFields.count == 1) {
                    alertView.alertViewStyle = UIAlertViewStylePlainTextInput;
                    
                    UITextField *textField = [alertView textFieldAtIndex:0];
                    alertController.mutableTextFields = [NSMutableArray arrayWithObject:textField];
                } else {
                    alertView.alertViewStyle = UIAlertViewStyleLoginAndPasswordInput;
                    
                    UITextField *firstTextField = [alertView textFieldAtIndex:0];
                    UITextField *secondTextField = [alertView textFieldAtIndex:1];
                    alertController.mutableTextFields = [NSMutableArray arrayWithObjects:firstTextField, secondTextField, nil];
                }
            }
            
            alertView.didPresentBlock = ^(UIAlertView *alertView){
                if (completion)
                    completion();
            };
            
            alertView.clickedButtonBlock = ^(UIAlertView *alertView, NSInteger buttonIndex){
                BBAlertAction *action = alertController.actions[buttonIndex];
                if (action.handler)
                    action.handler(action);
            };
            
            [alertView show];
        } else {
            BBActionSheet *actionSheet = [[BBActionSheet alloc] initWithTitle:alertController.title delegate:nil cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:nil, nil];
            
            for (BBAlertAction *action in alertController.actions) {
                [actionSheet addButtonWithTitle:action.title];
                
                if (actionSheet.cancelButtonIndex == -1 && action.style == BBAlertActionStyleCancel)
                    actionSheet.cancelButtonIndex = actionSheet.numberOfButtons - 1;
                
                if (actionSheet.destructiveButtonIndex == -1 && action.style == BBAlertActionStyleDestructive)
                    actionSheet.destructiveButtonIndex = actionSheet.numberOfButtons - 1;
                
                action.enabled = YES;
            }
            
            actionSheet.didPresentBlock = ^(UIActionSheet *actionSheet){
                if (completion)
                    completion();
            };
            
            actionSheet.clickedButtonBlock = ^(UIActionSheet *actionSheet, NSInteger buttonIndex){
                BBAlertAction *action = alertController.actions[buttonIndex];
                if (action.handler)
                    action.handler(action);
            };
            
            [actionSheet showInView:[[UIApplication sharedApplication] keyWindow]];
            CCLog(@"actionSheet::pre:%@",NSStringFromCGRect(actionSheet.frame));
            actionSheet.frame = CGRectMake(0, [UIScreen mainScreen].bounds.size.height-
                                           actionSheet.frame.size.height, [UIScreen mainScreen].bounds.size.width,
                                           actionSheet.frame.size.height);

        }
    }
}

@end
