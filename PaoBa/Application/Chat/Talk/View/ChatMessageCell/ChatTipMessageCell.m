//
//  ChatTipMessageCell.m
//  PaoBa
//
//  Created by wujian on 2017/8/18.
//  Copyright © 2017年 wujian. All rights reserved.
//

#import "ChatTipMessageCell.h"
#import "UIFont+PB.h"
#import "UIColor+PB.h"
#import "ChatTipMessage.h"

@interface ChatTipMessageCell ()

@property (nonatomic, strong)  UILabel *tipLabel;

@end

@implementation ChatTipMessageCell

+ (void)load
{
    [super registerRenderCell:[self class] messageType:kChatMsgType_Tip];
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self.contentView addSubview:self.tipLabel];
    }
    return self;
}

- (void)gotoDrawingCell
{
    [super gotoDrawingCell];
    if (![self.chatMessage isKindOfClass:[ChatTipMessage class]]) {
        return;
    }
    ChatTipMessage *tipMessage = (ChatTipMessage *)self.chatMessage;

    _tipLabel.text = self.chatMessage.content;
    if (!self.chatMessage.textColorValue) {
        _tipLabel.textColor = [UIColor grayFontColor];
    }
    else
    {
        _tipLabel.textColor = [UIColor hexChangeFloat:self.chatMessage.textColorValue];
    }
    _tipLabel.frame = CGRectMake((SCREEN_WIDTH - tipMessage.textSize.width)/2.0, (30 - tipMessage.textSize.height)/2.0, tipMessage.textSize.width, tipMessage.textSize.height);
}

#pragma mark - setter/getter

- (UILabel *)tipLabel
{
    if (!_tipLabel) {
        _tipLabel = [UILabel new];
        _tipLabel.backgroundColor = [UIColor clearColor];
        _tipLabel.font = [UIFont fontOfSystemFontWithRegularSize:12];
        _tipLabel.textColor = [UIColor grayFontColor];
        _tipLabel.opaque = YES;
        _tipLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _tipLabel;
}

@end
