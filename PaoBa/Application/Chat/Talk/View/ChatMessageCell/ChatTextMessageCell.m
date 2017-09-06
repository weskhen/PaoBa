//
//  ChatTextMessageCell.m
//  PaoBa
//
//  Created by wujian on 2017/8/18.
//  Copyright © 2017年 wujian. All rights reserved.
//

#import "ChatTextMessageCell.h"
#import "PBChatLabel.h"
#import "ChatTextMessage.h"
#import "UIColor+PB.h"

@interface ChatTextMessageCell ()<PBChatLabelDelegate>

@property (nonatomic, strong) PBChatLabel   *chatLabel;

@end

@implementation ChatTextMessageCell

+ (void)load
{
    [super registerRenderCell:[self class] messageType:kChatMsgType_Text];
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self.contentView addSubview:self.chatLabel];
    }
    return self;
}

- (void)gotoDrawingCell
{
    [super gotoDrawingCell];
    if (![self.chatMessage isKindOfClass:[ChatTextMessage class]]) {
        return;
    }
    ChatTextMessage *textMessage = (ChatTextMessage *)self.chatMessage;
    //chatLabel
    self.chatLabel.attributedText = textMessage.attributedMsgString;
    BOOL isMsgLeft = [textMessage isMessageLeft];
    if (isMsgLeft) {
        _chatLabel.frame = CGRectMake(72, 12, textMessage.textWidth+4, textMessage.textHeight+4);
    }
    else{
        _chatLabel.frame = CGRectMake(SCREEN_WIDTH - textMessage.textWidth - 76, 12, textMessage.textWidth+4, textMessage.textHeight+4);
    }
    if (ISEmptyString(self.chatMessage.textColorValue)) {
        _chatLabel.textColor = isMsgLeft?[UIColor blackFontColor]:[UIColor whiteColor];
    }
    else
    {
        _chatLabel.textColor = [UIColor hexChangeFloat:self.chatMessage.textColorValue];
    }
}

#pragma mark - PBChatLabelDelegate
- (BOOL)hasTouchPBChatLabelWillContinue
{
    if (![self.chatMessage isKindOfClass:[ChatTextMessage class]]) {
        return YES;
    }
    ChatTextMessage *textMessage = (ChatTextMessage *)self.chatMessage;

    if (textMessage.hasLink) {
        //do Something
        NSLog(@"点击了该文本 需要调转URL：%@",textMessage.linkString);
    }
    return NO;
}

#pragma mark - setter/getter
- (PBChatLabel *)chatLabel
{
    if (!_chatLabel) {
        _chatLabel = [PBChatLabel new];
        _chatLabel.textColor = [UIColor blackFontColor];
        _chatLabel.font = [UIFont systemFontOfSize:16];
        _chatLabel.numberOfLines = 0;
    }
    return _chatLabel;
}
@end
