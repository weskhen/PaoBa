//
//  PBTalkInputBar.m
//  PaoBa
//
//  Created by wujian on 2017/8/18.
//  Copyright © 2017年 wujian. All rights reserved.
//

#import "PBTalkInputBar.h"
#import "PBTalkTextView.h"
#import "UIColor+PB.h"
#import "Masonry.h"

@interface PBTalkInputBar ()<UITextViewDelegate>

@property (nonatomic, strong)  UIView *lineView;
@property (nonatomic, strong)  PBTalkTextView *textView;
@property (nonatomic, strong)  UIButton *functionButton;

@property (nonatomic, assign)  CGFloat lastInputBarHeight;
@end

@implementation PBTalkInputBar

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self initValue];
    }
    return self;
}

- (void)initValue
{
    self.backgroundColor = [UIColor whiteColor];
    [self addSubview:self.textView];
    [self addSubview:self.functionButton];
    [self addSubview:self.lineView];
    
    [_textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self).offset(12);
        make.top.equalTo(self).offset(7);
        make.bottom.equalTo(self).offset(-7);
        make.trailing.equalTo(self).offset(-54);
    }];
    [_functionButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(_textView.mas_trailing).offset(12);
        make.size.mas_equalTo(CGSizeMake(30, 30));
        make.top.equalTo(self).offset(10);
    }];
    
    [_lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.top.trailing.equalTo(self);
        make.height.mas_equalTo(1.0/SCREEN_SCALE);
    }];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    
    [_textView addObserver:self forKeyPath:@"contentSize" options:NSKeyValueObservingOptionNew context:@"PBTalkInputBar"];
}

- (void)dealloc
{
    [_textView removeObserver:self forKeyPath:@"contentSize" context:@"PBTalkInputBar"];
    _textView.delegate = nil;
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    TraceS(@"PBTalkInputBar dealloc");
}

- (void)textChange:(UITextView *)textView
{
    CGSize size = [textView sizeThatFits:CGSizeMake(SCREEN_WIDTH-66, MAXFLOAT)];
    CGFloat inputBarHeight = MAX(size.height+14, PBTalkInputBarHeight);
    inputBarHeight = MIN(100, inputBarHeight);
    if (self.lastInputBarHeight != inputBarHeight) {
        self.lastInputBarHeight = inputBarHeight;
        if ([_delegate respondsToSelector:@selector(changeInputBarHeight:)]) {
            [_delegate changeInputBarHeight:inputBarHeight];
        }
    }
}
#pragma mark - privateMethod
- (void)clearInputText
{
    _textView.text = @"";
    [self textChange:_textView];
}

- (void)reloadInputTextViews
{

}

#pragma mark - Notification
- (void)keyboardWillShow:(NSNotification *)aNotification
{
    NSDictionary *userInfo = [aNotification userInfo];
    CGRect keyboardRect = [[userInfo objectForKey:UIKeyboardFrameEndUserInfoKey]
                           CGRectValue];
    NSTimeInterval animationDuration = [[userInfo
                                         objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    if ([_delegate respondsToSelector:@selector(inputBar:keyboardWillShow:animationTime:)]) {
        [_delegate inputBar:self keyboardWillShow:keyboardRect animationTime:animationDuration];
    }
}


- (void)keyboardWillHide:(NSNotification *)aNotification
{
    NSDictionary *userInfo = [aNotification userInfo];
    NSTimeInterval animationDuration = [[userInfo
                                         objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    if ([_delegate respondsToSelector:@selector(inputBar:keyboardWillHideAnimationTime:)]) {
        [_delegate inputBar:self keyboardWillHideAnimationTime:animationDuration];
    }
}

#pragma mark - KVO
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    UITextView * textView =(UITextView *)object;
    if ([keyPath isEqualToString:@"contentSize"]) {
        [self textChange:textView];
    }
    else{
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

#pragma mark - UITextViewDelegate

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"]) {
        //发送
        if ([_delegate respondsToSelector:@selector(inputBar:didSendText:)]) {
            [_delegate inputBar:self didSendText:_textView.text];
        }
        return NO;
        
    }
    return YES;
}

#pragma mark - buttonEvent
- (void)functionButtonClicked:(id)sender
{
    if ([_delegate respondsToSelector:@selector(functionButtonClicked)]) {
        [_delegate functionButtonClicked];
    }
}

#pragma mark - setter/getter
- (UIView *)lineView
{
    if (!_lineView) {
        _lineView = [UIView new];
        _lineView.backgroundColor = [UIColor colorWithHex:0xEAE9E9];
    }
    return _lineView;
}
- (PBTalkTextView *)textView
{
    if (!_textView) {
        _textView = [[PBTalkTextView alloc] init];
        _textView.delegate = self;
    }
    return _textView;
}

- (UIButton *)functionButton
{
    if (!_functionButton) {
        _functionButton = [UIButton new];
        [_functionButton setImage:PBIMAGE(@"chat_functionButton") forState:UIControlStateNormal];
        [_functionButton addTarget:self action:@selector(functionButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _functionButton;
}
@end
