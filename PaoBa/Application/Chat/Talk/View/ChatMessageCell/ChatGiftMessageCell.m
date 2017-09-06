//
//  ChatGiftMessageCell.m
//  PaoBa
//
//  Created by wujian on 2017/8/18.
//  Copyright © 2017年 wujian. All rights reserved.
//

#import "ChatGiftMessageCell.h"
#import "UIColor+PB.h"
#import "UIFont+PB.h"
#import "ChatGiftMessage.h"

@interface ChatGiftMessageCell ()

@property (nonatomic, strong)  UIView *giftBgView;
@property (nonatomic, strong)  UIImageView *giftImageView;
@property (nonatomic, strong)  UILabel *titleLabel;
@property (nonatomic, strong)  UILabel *descLabel;

@end
@implementation ChatGiftMessageCell

+ (void)load
{
    [super registerRenderCell:[self class] messageType:kChatMsgType_Gift];
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self.contentView addSubview:self.giftBgView];
        [self.contentView addSubview:self.giftImageView];
        [self.contentView addSubview:self.titleLabel];
        [self.contentView addSubview:self.descLabel];
        
    }
    return self;
}
- (void)gotoDrawingCell
{
    [super gotoDrawingCell];
    
    if (![self.chatMessage isKindOfClass:[ChatGiftMessage class]]) {
        return;
    }
    
    ChatGiftMessage *giftMessage = (ChatGiftMessage *)self.chatMessage;
    BOOL isMessgeLeft = [giftMessage isMessageLeft];
    CGRect contentBgRect = self.touchMenuFrame;
    
    //从左和从右 有5个px 差距
    CGFloat padding = isMessgeLeft?5:0;
    //giftBgView
    _giftBgView.frame = CGRectMake(CGRectGetMinX(contentBgRect) + 10 + padding, CGRectGetMinY(contentBgRect) + 8.5, 56, 56);
    
    //giftImageView
    _giftImageView.backgroundColor = [UIColor redColor];
//    [_giftImageView sd_setImageWithURL:[NSURL URLWithString:giftMessage.giftIcon] placeholderImage:nil options:SDWebImageRetryFailed];
    _giftImageView.frame = CGRectMake(CGRectGetMinX(contentBgRect) + 14 + padding, CGRectGetMinY(contentBgRect) + 12.5, 48, 48);
    
    //titleLabel
    _titleLabel.attributedText = giftMessage.titleString;
    if (giftMessage.titleHeight < 1) {
        _titleLabel.frame = CGRectMake(CGRectGetMinX(contentBgRect) + 76 + padding, CGRectGetMinY(contentBgRect) + 13, 128, 0);
        [_titleLabel sizeToFit];
        giftMessage.titleHeight = _titleLabel.frame.size.height;
    }
    else
    {
        _titleLabel.frame = CGRectMake(CGRectGetMinX(contentBgRect) + 76 + padding, CGRectGetMinY(contentBgRect) + 13, 128, giftMessage.titleHeight);
    }
    
    //descLabel
    _descLabel.text = [NSString stringWithFormat:@"获得了%@经验",giftMessage.exp];
    _descLabel.frame = CGRectMake(CGRectGetMinX(contentBgRect) + 76 + padding, CGRectGetMaxY(_titleLabel.frame) + (giftMessage.titleHeight > 20?2:5), 128, 20);
    
}


#pragma mark - setter/getter
- (UIView *)giftBgView
{
    if (!_giftBgView) {
        _giftBgView = [UIView new];
        _giftBgView.backgroundColor = [UIColor colorWithHex:0xF7F7F7];
    }
    return _giftBgView;
}

- (UIImageView *)giftImageView
{
    if (!_giftImageView) {
        _giftImageView = [UIImageView new];
        _giftImageView.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _giftImageView;
}

- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [UILabel new];
        _titleLabel.font = [UIFont fontOfSystemFontWithRegularSize:13];
        _titleLabel.textColor = [UIColor colorWithHex:0x666666];
        _titleLabel.numberOfLines = 2;
    }
    return _titleLabel;
}


- (UILabel *)descLabel
{
    if (!_descLabel) {
        _descLabel = [UILabel new];
        _descLabel.font = [UIFont fontOfSystemFontWithRegularSize:12];
        _descLabel.textColor = [UIColor grayFontColor];
    }
    return _descLabel;
}
@end
