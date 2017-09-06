//
//  PBTalkTableHeaderView.m
//  PaoBa
//
//  Created by wujian on 2017/8/18.
//  Copyright © 2017年 wujian. All rights reserved.
//

#import "PBTalkTableHeaderView.h"
#import "UIColor+PB.h"
#import "UIFont+PB.h"
#import "Masonry.h"

@interface PBTalkTableHeaderView ()

@property (nonatomic, strong)  UILabel *tipLabel;
@property (nonatomic, strong)  UIButton *followButton;
@end
@implementation PBTalkTableHeaderView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithHex:0xFFFCF2];
        
        [self addSubview:self.tipLabel];
        [self addSubview:self.followButton];
        [_followButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self).offset(1);
            make.trailing.equalTo(self);
            make.size.mas_equalTo(CGSizeMake(51, 36));
        }];
        CGSize size = [_tipLabel sizeThatFits:CGSizeZero];
        size.width = MIN(size.width, SCREEN_WIDTH - 51 - 12);
        [_tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(self).offset(12);
            make.centerY.equalTo(_followButton);
            make.size.mas_equalTo(size);
        }];
    }
    return self;
}

#pragma mark - buttonEvent
- (void)followButtonClicked:(id)sender
{
    if ([_delegate respondsToSelector:@selector(followButtonClicked)]) {
        [_delegate followButtonClicked];
    }
}


#pragma mark - setter/getter
- (UILabel *)tipLabel
{
    if (!_tipLabel) {
        _tipLabel = [UILabel new];
        _tipLabel.backgroundColor = [UIColor clearColor];
        _tipLabel.font = [UIFont fontOfRobotoRegularWithSize:14];
        _tipLabel.textColor = [UIColor colorWithHex:0xFF5849];
        _tipLabel.text = @"关注好友不迷路哦～～";
    }
    return _tipLabel;
}

- (UIButton *)followButton
{
    if (!_followButton) {
        _followButton = [UIButton new];
        [_followButton setImage:PBIMAGE(@"btn_sixin_guanzhu_n") forState:UIControlStateNormal];
        [_followButton setImageEdgeInsets:UIEdgeInsetsMake(8, 8, 8, 8)];
        [_followButton addTarget:self action:@selector(followButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _followButton;
}
@end
