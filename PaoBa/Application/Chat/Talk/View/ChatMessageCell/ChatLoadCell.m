//
//  ChatLoadCell.m
//  PaoBa
//
//  Created by wujian on 2017/8/18.
//  Copyright © 2017年 wujian. All rights reserved.
//

#import "ChatLoadCell.h"
#import "ChatLoadingMessage.h"

@interface ChatLoadCell ()

@property (nonatomic, strong)  UIActivityIndicatorView *indicatorView;
@end
@implementation ChatLoadCell

+ (void)load
{
    [super registerRenderCell:[self class] messageType:kChatMsgType_Loading];
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self.contentView addSubview:self.indicatorView];
    }
    return self;
}

- (void)dealloc
{
    TraceS(@"ChatLoadCell dealloc");
}

- (void)gotoDrawingCell
{
    [super gotoDrawingCell];
    if (![self.chatMessage isKindOfClass:[ChatLoadingMessage class]]) {
        return;
    }
    CGSize indicatorViewSize = _indicatorView.frame.size;
    _indicatorView.frame = CGRectMake((SCREEN_WIDTH - indicatorViewSize.width)/2.0, (28-_indicatorView.frame.size.height)/2.0, indicatorViewSize.width, indicatorViewSize.height);
    [_indicatorView startAnimating];
}

#pragma mark - setter/getter
- (UIActivityIndicatorView *)indicatorView
{
    if (!_indicatorView) {
        _indicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        [_indicatorView startAnimating];
        [_indicatorView sizeToFit];
    }
    return _indicatorView;
}

@end
