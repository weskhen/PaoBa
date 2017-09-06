//
//  PBTalkControllerProtocol.h
//  PaoBa
//
//  Created by wujian on 2017/3/14.
//  Copyright © 2017年 wujian. All rights reserved.
//

typedef enum : NSUInteger {
    PBTalkControllerFrom_None = 0, //默认 个人页聊天或聊天会话
    PBTalkControllerFrom_Stream, // 直播间私信
} PBTalkControllerFrom;

@class PBDetailUser;
//外部类对TalkController进行的操作
@protocol PBTalkControllerProtocol <NSObject>

- (void)setControllerFromSource:(PBTalkControllerFrom )source talkUser:(PBDetailUser *)dstUser;

@end

