//
//  ChatTipMessage.h
//  PaoBa
//
//  Created by wujian on 2017/8/18.
//  Copyright © 2017年 wujian. All rights reserved.
//

#import "ChatMessage.h"
#import <CoreGraphics/CoreGraphics.h>

/** tipMessage 是一个特殊的临时消息 如用来展示消息时间 突然插入的文本若提示等 消息实体除了**/
@interface ChatTipMessage : ChatMessage

@property (nonatomic, assign)   CGSize          textSize;//for timestamp and system message

@end
