//
//  ChatLoadingMessage.m
//  PaoBa
//
//  Created by wujian on 2017/8/18.
//  Copyright © 2017年 wujian. All rights reserved.
//

#import "ChatLoadingMessage.h"

@implementation ChatLoadingMessage

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.msgtype = @(kChatMsgType_Loading);
    }
    return self;
}

@end
