//
//  PBTalkViewProtocol.h
//  PaoBa
//
//  Created by wujian on 2017/3/14.
//  Copyright © 2017年 wujian. All rights reserved.
//

#ifndef PBTalkViewProtocol_h
#define PBTalkViewProtocol_h

@class ChatMessage;
@protocol PBTalkViewProtocol <NSObject>

- (void)buildView;

- (void)refreshTalkViewWithMsgList:(NSMutableArray *)msgList andHasMoreMsg:(BOOL)hasMore;

/** 从服务器get对方详情消息 **/
- (void)refreshPersonalInfoView;

/** 关注用户是否成功 **/
- (void)followUserSuccessed:(BOOL)sucessed;


/** 隐藏键盘 **/
- (void)hiddenDownInputViewAndBottomView;

/** 更新一条消息 **/
- (void)insertNewMessage:(ChatMessage *)message talkArray:(NSMutableArray *)messageList;

- (void)updateMessage:(ChatMessage *)message andMessageIndex:(NSInteger)index;

@end
#endif /* PBTalkViewProtocol_h */
