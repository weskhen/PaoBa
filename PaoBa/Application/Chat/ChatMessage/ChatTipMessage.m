//
//  ChatTipMessage.m
//  PaoBa
//
//  Created by wujian on 2017/8/18.
//  Copyright © 2017年 wujian. All rights reserved.
//

#import "ChatTipMessage.h"

@interface ChatTipMessage ()


@end

@implementation ChatTipMessage

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.msgtype = @(kChatMsgType_Tip);
    }
    return self;
}

@end
