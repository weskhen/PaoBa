//
//  ChatMessage.h
//  PaoBa
//
//  Created by wujian on 2017/8/18.
//  Copyright © 2017年 wujian. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreText/CoreText.h>

/** 消息类型 **/
#define  kChatMsgType_Unknow            0 //所有未定义的类型
#define  kChatMsgType_Text              1 //普通文本
#define  kChatMsgType_Gift              2 //礼物
#define  kChatMsgType_Audio             3 //语音
#define  kChatMsgType_Image             4 //图片
#define  kChatMsgType_Tip               -2 //时间或系统等消息  不需要存入DB的
#define  kChatMsgType_Loading           -3 //loadingCell
#define  kChatMsgFromNotification       -2000 //消息uuid来之系统通知


/** 消息发送状态 **/
#define  kMsgStatus_None       -1 //不需要显示状态
#define  kMsgStatus_UnSended    0 //发送失败
#define  kMsgStatus_Sending     1 //发送中
#define  kMsgStatus_Sended      2 //已发送
#define  kMsgStatus_Received    3 //已送达
#define  kMsgStatus_Readed      4 //已阅读

@class PBDetailUser;
@interface ChatMessage : NSObject

@property (nonatomic, strong) NSNumber *fromuid; //发送者uid
@property (nonatomic, strong) NSNumber *touid; //接受者uid

@property (nonatomic, strong) NSString *otherPartyName; //对方昵称
@property (nonatomic, strong) NSString *otherPartyAvatar; //对方头像
@property (nonatomic, strong) NSString *msgUUID; //消息uuid 服务器可能会下发
@property (nonatomic, strong) NSNumber *msgId;  //根据此字段去重 当前时间戳
@property (nonatomic, strong) NSNumber *rowid; //根据此字段排序 客户端维护
@property (nonatomic, strong) NSNumber *sessionId;  //会话id
@property (nonatomic, strong) NSNumber *msgStatus; //消息状态
@property (nonatomic, strong) NSNumber *msgtype; //消息类型 kChatMsgType
@property (nonatomic, strong) NSNumber* timesTamp; //客户端消息时间戳
@property (nonatomic, strong) NSString *content; //Search或者ChatMessage使用
@property (nonatomic, strong) NSNumber* msgsrvtime; //该消息服务器时间
@property (nonatomic, assign) BOOL  shouldSaveToDB; //该消息是否需要保存到DB
@property (nonatomic, assign) BOOL  isOfflineMsg; //消息是离线收到的，还是在线收到的

@property (nonatomic, strong) NSString *textColorValue;//文本颜色

@property (nonatomic, assign) float renderHeight;//cell高度  消息接收到的时候需要先算好

@property (nonatomic, strong) NSString *pushContent; // push使用
@property (nonatomic, strong) NSData *blobdata; //留着待扩展

/** 消息是否在左边 或者是否是他人发送的 **/
- (BOOL)isMessageLeft;
/** 自己头像url **/
- (NSString *)selfAvatarString;

/** 构造消息体 */
+ (ChatMessage *)chatMsgWithContent:(NSString *)content
                            msgType:(NSNumber *)msgType
                               user:(PBDetailUser *)user
                            msgTime:(NSNumber *)msgTime
                             isSend:(BOOL)isSend;

@end
