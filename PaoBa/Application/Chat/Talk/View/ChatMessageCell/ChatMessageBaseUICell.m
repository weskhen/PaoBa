//
//  ChatMessageBaseUICell.m
//  PaoBa
//
//  Created by wujian on 2017/8/18.
//  Copyright © 2017年 wujian. All rights reserved.
//

#import "ChatMessageBaseUICell.h"
#import "ChatTextMessage.h"
#import "ChatGiftMessage.h"
#import "UIImageView+WebCache.h"
#import "UIImage+PB.h"

@interface ChatMessageBaseUICell ()

@property (nonatomic, strong) UIImageView   *avatarImageView;
@property (nonatomic, strong) UIImageView   *contentBgImageView;
@property (nonatomic, strong) UIImageView   *sendFailImageView;

@property (nonatomic, strong) UIImage *leftTextBgImage;
@property (nonatomic, strong) UIImage *rightTextBgImage;
@property (nonatomic, strong) UIImage *leftGiftBgImage;
@property (nonatomic, strong) UIImage *rightGiftBgImage;


@end
@implementation ChatMessageBaseUICell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self.contentView addSubview:self.avatarImageView];
        [self.contentView addSubview:self.contentBgImageView];
        [self.contentView addSubview:self.sendFailImageView];
        
        //监听用户数据变化 及时更新头像
    }
    return self;
}

- (void)gotoDrawingCell
{
    [super gotoDrawingCell];
    [self reloadContentView];
}

- (void)reloadContentView
{
    BOOL isMsgLeft = [self.chatMessage isMessageLeft];
    //头像
    NSString *headURL;
    if (isMsgLeft) {
        _avatarImageView.frame = CGRectMake(12, 4, 41, 41);
        headURL = self.chatMessage.otherPartyAvatar;
    }
    else{
        _avatarImageView.frame = CGRectMake(SCREEN_WIDTH - 53, 4, 41, 41);
        headURL = [self.chatMessage selfAvatarString];
    }
    
    [_avatarImageView sd_setImageWithURL:[NSURL URLWithString:headURL] placeholderImage:nil options:SDWebImageRetryFailed completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        _avatarImageView.image = [image imageWithRoundedCornersSize:image.size.height/2.0];
    }];
    [self setTouchAvatarFrame:_avatarImageView.frame];
    
    //内容背景框
    if (self.chatMessage.msgtype.intValue == kChatMsgType_Text) {
        if ([self.chatMessage isKindOfClass:[ChatTextMessage class]]) {
            ChatTextMessage *textMessage = (ChatTextMessage *)self.chatMessage;
            
            if (isMsgLeft) {
                self.contentBgImageView.image = self.leftTextBgImage;
                _contentBgImageView.frame = CGRectMake(58, 6, textMessage.textWidth+25, textMessage.textHeight+18);
            }
            else{
                self.contentBgImageView.image = self.rightTextBgImage;
                _contentBgImageView.frame = CGRectMake(SCREEN_WIDTH - textMessage.textWidth - 83, 6, textMessage.textWidth+25, textMessage.textHeight+18);
            }
        }
        [self setTouchMenuFrame:_contentBgImageView.frame];
    }
    else if (self.chatMessage.msgtype.intValue == kChatMsgType_Gift)
    {
        if (isMsgLeft) {
            self.contentBgImageView.image = self.leftGiftBgImage;
            _contentBgImageView.frame = CGRectMake(64, 6, 220, 73);
        }
        else{
            self.contentBgImageView.image = self.rightGiftBgImage;
            _contentBgImageView.frame = CGRectMake(SCREEN_WIDTH - 284, 6, 220, 73);
        }
        [self setTouchMenuFrame:_contentBgImageView.frame];
    }
    else
    {
        _contentBgImageView.image = nil;
    }
    
    //发送失败图标
    if (self.chatMessage.msgStatus.intValue == kMsgStatus_UnSended && isMsgLeft == NO) {
        self.sendFailImageView.hidden = NO;
        //y坐标 (73-16)/2+6 = 34.5 点击区域扩大到34*34
        _sendFailImageView.frame = CGRectMake(CGRectGetMinX(_contentBgImageView.frame) - 25, (self.chatMessage.renderHeight-16)/2.0, 16, 16);
        [self setTouchFailedFrame:CGRectMake(CGRectGetMinX(_contentBgImageView.frame) - 34, (self.chatMessage.renderHeight-16)/2.0 - 9, 34, 34)];
    }else{
        if (_sendFailImageView) {
            _sendFailImageView.hidden = YES;
        }
    }
}


#pragma mark - setter/getter
- (UIImageView *)avatarImageView
{
    if (!_avatarImageView) {
        _avatarImageView = [UIImageView new];
        _avatarImageView.opaque = YES;
    }
    return _avatarImageView;
}

- (UIImageView *)contentBgImageView
{
    if (!_contentBgImageView) {
        _contentBgImageView = [UIImageView new];
        _contentBgImageView.opaque = YES;
    }
    return _contentBgImageView;
}

- (UIImageView *)sendFailImageView
{
    if (!_sendFailImageView) {
        _sendFailImageView = [UIImageView new];
        _sendFailImageView.image = PBIMAGE(@"icon_fasongshibai");
    }
    return _sendFailImageView;
}

- (UIImage*)leftTextBgImage
{
    if (!_leftTextBgImage) {
        _leftTextBgImage = [PBIMAGE(@"chat_other") resizableImageWithCapInsets:UIEdgeInsetsMake(23, 14 , 7, 7)];
    }
    return _leftTextBgImage;
}

- (UIImage *)rightTextBgImage
{
    if (!_rightTextBgImage) {
        _rightTextBgImage = [PBIMAGE(@"chat_self") resizableImageWithCapInsets:UIEdgeInsetsMake(23, 7, 7, 14)];
    }
    return _rightTextBgImage;
}

- (UIImage *)leftGiftBgImage
{
    if (!_leftGiftBgImage) {
        _leftGiftBgImage = [PBIMAGE(@"chat_other") resizableImageWithCapInsets:UIEdgeInsetsMake(23, 14 , 7, 7)];
    }
    return _leftGiftBgImage;
}

- (UIImage *)rightGiftBgImage
{
    if (!_rightGiftBgImage) {
        _rightGiftBgImage = [PBIMAGE(@"chat_send_gift") resizableImageWithCapInsets:UIEdgeInsetsMake(23, 7, 7, 14)];
    }
    return _rightGiftBgImage;
}
@end
