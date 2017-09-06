//
//  ChatTextMessage.h
//  PaoBa
//
//  Created by wujian on 2017/8/18.
//  Copyright © 2017年 wujian. All rights reserved.
//

#import "ChatMessage.h"

@interface ChatTextMessage : ChatMessage

@property (nonatomic, strong)   NSAttributedString   *attributedMsgString; //富文本信息
@property (nonatomic, assign)   float                   textWidth;
@property (nonatomic, assign)   float                   textHeight;
@property (nonatomic, assign)   CTFrameRef              ctFrame;
@property (nonatomic, assign)   BOOL                    hasLink;//系统强链接

/** 系统消息要求的link优先   之后是识别出来的link**/
@property (nonatomic, strong)   NSString    *linkString; //如果没有linkString 说明是普通文本消息

/** for test**/
+ (ChatTextMessage *)createMesgWithRowId:(int)rowId fromUid:(NSNumber *)formUid toUid:(NSNumber *)toUid otherPartyAvatar:(NSString *)avatar;

+ (ChatTextMessage *)createTextMessageWithMsg:(ChatMessage *)msg;

@end
