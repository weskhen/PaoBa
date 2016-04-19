//
//  BBAlertController.h
//  PaoBa
//
//  Created by wujian on 4/14/16.
//  Copyright © 2016 wesk痕. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, BBAlertActionStyle) {
    BBAlertActionStyleDefault = 0,
    BBAlertActionStyleCancel,
    BBAlertActionStyleDestructive
};

typedef NS_ENUM(NSInteger, BBAlertControllerStyle) {
    BBAlertControllerStyleActionSheet = 0,
    BBAlertControllerStyleAlert
};
@class BBAlertAction;

typedef void (^BBAlertActionHandler)(BBAlertAction *action);

typedef void (^BBAlertControllerCompletionBlock)(id sender, NSInteger buttonIndex);

#pragma mark - BBAlertAction

@interface BBAlertAction : NSObject <NSCopying>

+ (instancetype)actionWithTitle:(NSString *)title style:(BBAlertActionStyle)style handler:(BBAlertActionHandler)handler;

@property (nonatomic, readonly) NSString *title;
@property (nonatomic, readonly) BBAlertActionStyle style;
@property (nonatomic, getter=isEnabled) BOOL enabled;

@end

@interface BBAlertController : NSObject

+ (instancetype)alertControllerWithTitle:(NSString *)title message:(NSString *)message preferredStyle:(BBAlertControllerStyle)preferredStyle;

- (void)addAction:(BBAlertAction *)action;
@property (nonatomic, readonly) NSArray *actions;
- (void)addTextFieldWithConfigurationHandler:(void (^)(UITextField *textField))configurationHandler;
@property (nonatomic, readonly) NSArray *textFields;

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *message;

@property (nonatomic, readonly) BBAlertControllerStyle preferredStyle;

@end

#pragma mark - UIViewController (BBAlertController)

@interface UIViewController (BBAlertController)

- (void)presentAlertController:(BBAlertController *)alertController animated:(BOOL)animated completion:(void (^)(void))completion;

@end

