//
//  PBTalkInputBar.h
//  PaoBa
//
//  Created by wujian on 2017/8/18.
//  Copyright © 2017年 wujian. All rights reserved.
//

#import <UIKit/UIKit.h>

#define PBTalkInputBarHeight 49.0f

@class PBTalkInputBar;
@protocol PBTalkInputBarDelegate <NSObject>

- (void)inputBar:(PBTalkInputBar *)inputBar didSendText:(NSString *)text;

- (void)inputBar:(PBTalkInputBar *)inputBar keyboardWillShow:(CGRect)keyboardRect animationTime:(NSTimeInterval)time;

- (void)inputBar:(PBTalkInputBar *)inputBar keyboardWillHideAnimationTime:(NSTimeInterval)time;

- (void)changeInputBarHeight:(CGFloat)height;

- (void)functionButtonClicked;
@end
@interface PBTalkInputBar : UIView

@property (nonatomic, weak) id<PBTalkInputBarDelegate> delegate;

/** 清除输入框内容 **/
- (void)clearInputText;

- (void)reloadInputTextViews;
@end
