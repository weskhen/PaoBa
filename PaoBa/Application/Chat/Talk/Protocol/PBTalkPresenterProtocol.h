//
//  PBTalkPresenterProtocol.h
//  PaoBa
//
//  Created by wujian on 2017/3/14.
//  Copyright © 2017年 wujian. All rights reserved.
//

#ifndef PBTalkPresenterProtocol_h
#define PBTalkPresenterProtocol_h

@class PBDetailUser;
@protocol PBTalkPresenterProtocol <NSObject>

//TLTalkPresenter 业务逻辑
/** 聊天用户 **/
- (void)setTalkUser:(PBDetailUser *)user;

/** 获取正在聊天的用户信息 **/
- (PBDetailUser *)getTalkUser;

/** 请求用户详情 **/
- (void)requestUserInfo;

/** 关注用户 **/
- (void)followTalkUser;

/** 发送文本 **/
- (void)sendChatText:(NSString *)text;


/** 获取之前聊天记录 **/
- (void)getPreMoreMessages;

/** 插入loading cell **/
- (void)insertLoadingCell:(NSMutableArray *)messageList;

@end
#endif /* PBTalkPresenterProtocol_h */
