//
//  PBTalkPresenter.m
//  PaoBa
//
//  Created by wujian on 2017/3/14.
//  Copyright © 2017年 wujian. All rights reserved.
//

#import "PBTalkPresenter.h"
#import "PBTalkPresenterProtocol.h"
#import "PBController.h"
#import "PBTalkInteractorProtocol.h"
#import "PBTalkViewProtocol.h"
#import "ChatMessage.h"
#import "ChatTextMessage.h"
#import "PBDetailUser.h"
#import "ChatTipMessage.h"
#import "ChatGiftMessage.h"
#import "ChatLoadingMessage.h"
#import "PBOwnUser.h"
#import "PBUserDefaults.h"
#import "PBTimeTool.h"

@interface PBTalkPresenter ()<PBTalkPresenterProtocol>

@property (nonatomic, strong)  PBDetailUser *currentTalkUser;

@property (nonatomic, strong)  NSMutableArray *messageArray; //消息列表  确保数据稳定性 数据需要在指定的DB线程操作
@property (nonatomic, assign)  long long lastTimeMessageTime; //消息最下面的时间
@property (nonatomic, assign)  long long firstTimeMessageTime; //消息最上面的时间

@property (nonatomic, strong)  NSNumber *currentMaxTimeTamp;


@end
@implementation PBTalkPresenter


- (instancetype)init
{
    self = [super init];
    if (self) {
        NSTimeInterval timestamp = [[[NSDate alloc] init] timeIntervalSince1970] * 1000;

        self.currentMaxTimeTamp = [NSNumber numberWithDouble:(timestamp + 60 * 60 * 24 * 365 * 1000.0)];  //初始化为一年后
        
//        [[NSNotificationCenter defaultCenter] addObserver:self
//                                                 selector:@selector(addChatMsg:)
//                                                     name:KNotificationAddChatMessage
//                                                   object:nil];
//        [[NSNotificationCenter defaultCenter] addObserver:self
//                                                 selector:@selector(addGroupChatMsg:)
//                                                     name:KNotificationAddGroupChatMessage
//                                                   object:nil];
//        [[NSNotificationCenter defaultCenter] addObserver:self
//                                                 selector:@selector(deleteChatMsg:)
//                                                     name:KNotificationDeleteChatMessage
//                                                   object:nil];
//        [[NSNotificationCenter defaultCenter] addObserver:self
//                                                 selector:@selector(deleteAllChatMsg:)
//                                                     name:KNotificationDeleteAllChatMessage
//                                                   object:nil];
//        [[NSNotificationCenter defaultCenter] addObserver:self
//                                                 selector:@selector(updateChatMsg:)
//                                                     name:KNotificationUpdateChatMessage
//                                                   object:nil];
        
    }
    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    TraceS(@"TLTalkPresenter dealloc");
}

#pragma mark - Notification
//Message Add
- (void)addChatMsg:(NSNotification *)notif
{
    ChatMessage *msg = [notif object];
    [self insertNewChatMessage:msg];
}

- (void)addGroupChatMsg:(NSNotification *)notif {
    
}

//Message Delete
- (void)deleteChatMsg:(NSNotification *)notif {
    
}

- (void)deleteAllChatMsg:(NSNotification *)notif {
    
}

// Message Update
- (void)updateChatMsg:(NSNotification *)notif {
    ChatMessage *msg = [notif object];
    [self updateChatMessage:msg];
}

//插入新消息
- (void)insertNewChatMessage:(ChatMessage *)chatMsg {
    
    //不是当前会话
    if (chatMsg.sessionId.longLongValue != self.currentTalkUser.userId.longLongValue) {
        return;
    }
    BOOL hasExist = NO;
    for (ChatMessage *existMessage in self.messageArray) {
        if (chatMsg.rowid.longLongValue == existMessage.rowid.integerValue) {
            hasExist = YES;
            break;
        }
    }
    
    if (hasExist) {
        [self updateChatMessage:chatMsg];
    }
    else{
        [self chectAddTimeChatMessage:chatMsg msgList:self.messageArray];
    }
    PBSend(self.baseController.cView, PBTalkViewProtocol, insertNewMessage:chatMsg talkArray:self.messageArray);
}

//更新消息
- (void)updateChatMessage:(ChatMessage *)chatMsg {
    
    //update existing message object
    int chatMessageIndex = 0;
    for (int i = 0; i < self.messageArray.count; i++) {
        ChatMessage *existingMsg = [self.messageArray objectAtIndex:i];
        if (existingMsg.rowid.longLongValue == chatMsg.rowid.longLongValue) {
            //更新消息至DB
            [self updateMessage:existingMsg withMessage:chatMsg];
            chatMessageIndex = i;
            break;
        }
    }
    PBSend(self.baseController.cView, PBTalkViewProtocol, updateMessage:chatMsg andMessageIndex:chatMessageIndex);
}

/** 消息状态更新 **/
- (void)updateMessage:(ChatMessage*)existingMsg withMessage:(ChatMessage*)newMsg
{
    if (existingMsg.msgStatus.intValue >= kMsgStatus_Sended &&
        newMsg.msgStatus.intValue < existingMsg.msgStatus.intValue) {
        //已发送成功的消息不需要再改变为更小的状态了
        return;
    }
    existingMsg.msgStatus = newMsg.msgStatus;
}

#pragma mark - PBTalkPresenterProtocol
- (void)setTalkUser:(PBDetailUser *)user
{
    if (!_currentTalkUser) {
        _currentTalkUser = user;
    }
}

- (PBDetailUser *)getTalkUser
{
    return _currentTalkUser;
}

/** 请求用户详情 **/
- (void)requestUserInfo
{
    NSNumber *userId = _currentTalkUser.userId;
    PBWEAKSELF
//    [_currentTalkUser loadDataWithServerInfo:dic];
    PBSend(self.baseController.cView, PBTalkViewProtocol, refreshPersonalInfoView);
    
}

- (void)followTalkUser
{
    if (!_currentTalkUser.userId) {
        return;
    }
    
    
}

- (void)sendChatText:(NSString *)text
{
    //构建消息
    if (ISEmptyString(text)) {
        return;
    }
    
    NSTimeInterval timestamp = [[[NSDate alloc] init] timeIntervalSince1970] * 1000;
    ChatMessage *msg = [ChatMessage chatMsgWithContent:text
                                               msgType:@(1)
                                                  user:self.currentTalkUser
                                               msgTime:@(timestamp)
                                                isSend:YES];
    
    ChatTextMessage *textMessage = [ChatTextMessage new];
    textMessage = [ChatTextMessage createTextMessageWithMsg:msg];
    
    //发送消息至服务
    [self insertNewChatMessage:textMessage];

    //插入到DB
//    [self updateDBWithTextMsg:textMessage];
}

- (void)getPreMoreMessages
{
    NSMutableDictionary *messageDic = [[NSMutableDictionary alloc] init];
    NSMutableArray *temMesssages = [[NSMutableArray alloc] init];
    [messageDic setObject:@(1) forKey:@"status"];
    for (int i = 0; i < 20; i++) {
        NSNumber *currentRowId = [PBUserDefaults getCurrentRowId];
        NSNumber *insertRowId  = @(currentRowId.longLongValue +1);
        [PBUserDefaults saveRowIdToDB:insertRowId];

        ChatTextMessage *textMessage = [ChatTextMessage createMesgWithRowId:insertRowId.intValue fromUid:_Owner.userId toUid:_currentTalkUser.userId otherPartyAvatar:_currentTalkUser.avatarUrl];
        [temMesssages addObject:textMessage];
    }
    [messageDic setObject:temMesssages forKey:@"data"];
    
    //测试先查全部消息，后面调用分页查询
    PBWEAKSELF
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        PBSTRONGSELF
//        NSDictionary *result = [NSDictionary new];
        NSArray *dataArr = messageDic[@"data"];
        BOOL hasMoreData = YES;
        if ([messageDic[@"status"] integerValue] == 0) {//1有数据，0无数据
            hasMoreData = NO;
        }
        if (strongSelf.messageArray.count > 0) {
            // 移除最上层的时间消息
            [strongSelf.messageArray removeObjectAtIndex:0];
        }
        
        NSMutableArray *msgList = [strongSelf addTimeToMessageList:dataArr];
        //最上面一条数据为时间消息
        if (![[msgList firstObject] isKindOfClass:[ChatTipMessage class]] && msgList.count > 0) {
            //第一次加载 列表为空
            if (self.messageArray.count == 0) {
                ChatTipMessage *firstTipMessage = [self getNearTimeMessageFromTempMessageList:msgList];
                //如果最上层的时间和上一个时间消息相等 移除消息列表中对应的时间消息
                if (firstTipMessage && firstTipMessage.timesTamp.longLongValue == self.firstTimeMessageTime) {
                    if ([msgList containsObject:firstTipMessage]) {
                        [msgList removeObject:firstTipMessage];
                    }
                }
                
            }
            else
            {
                ChatTipMessage *firstTipMessage = [self getNearTimeMessageFromMessageList];
                //如果最上层的时间和上一个时间消息相等 移除消息列表中对应的时间消息
                if (firstTipMessage && firstTipMessage.timesTamp.longLongValue == self.firstTimeMessageTime) {
                    if ([strongSelf.messageArray containsObject:firstTipMessage]) {
                        [strongSelf.messageArray removeObject:firstTipMessage];
                    }
                }
                
            }
            ChatTipMessage *timeMessage = [self getTimeMessageWithTime:self.firstTimeMessageTime];
            [msgList insertObject:timeMessage atIndex:0];
        }

        [strongSelf.messageArray insertObjects:msgList atIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, msgList.count)]];
        PBSend(strongSelf.baseController.cView, PBTalkViewProtocol, refreshTalkViewWithMsgList:strongSelf.messageArray andHasMoreMsg:hasMoreData);

        
    });
    
}

- (void)insertLoadingCell:(NSMutableArray *)messageList
{
    ChatLoadingMessage *loadingMessage = [ChatLoadingMessage new];
    loadingMessage.renderHeight = 28;
    [messageList insertObject:loadingMessage atIndex:0];
}


#pragma mark - PrivateMethod
/** 发送消息更新DB */
- (void)updateDBWithTextMsg:(ChatMessage *)msg {
    //拿到消息创建一条会话
    
}

- (NSMutableArray *)addTimeToMessageList:(NSArray *)msgList{
    NSMutableArray *newMsgList = [[NSMutableArray alloc] init];
    for (ChatMessage *message in msgList) {
        // 1.判断EMMessage对象前面是否要加『时间』
        [self chectAddTimeChatMessage:message msgList:newMsgList];
    }
    return newMsgList;
}

- (BOOL)chectAddTimeChatMessage:(ChatMessage *)message msgList:(NSMutableArray *)msgList
{
    BOOL addTimeMessage = NO; //添加时间消息
    BOOL isUpMessage = NO; //朝上消息
    if (self.firstTimeMessageTime == 0) {
        self.firstTimeMessageTime = self.lastTimeMessageTime = message.timesTamp.longLongValue;
        addTimeMessage = YES;
        self.currentMaxTimeTamp = message.timesTamp;
    }
    else
    {
        if (message.timesTamp.longLongValue < self.firstTimeMessageTime) {
            isUpMessage = YES;
            self.currentMaxTimeTamp = message.timesTamp;
        }
        if (message.timesTamp.longLongValue > self.lastTimeMessageTime && message.timesTamp.longLongValue - self.lastTimeMessageTime > 5*60*1000) {
            self.lastTimeMessageTime = message.timesTamp.longLongValue;
            addTimeMessage = YES;
        }
        else if (message.timesTamp.longLongValue < self.firstTimeMessageTime && (self.firstTimeMessageTime-message.timesTamp.longLongValue > 5*60*1000))
        {
            self.firstTimeMessageTime = message.timesTamp.longLongValue;
            addTimeMessage = YES;
        }
        
    }
    
    if (addTimeMessage) {
        ChatTipMessage *tipMessage = [self getTimeMessageWithTime:message.timesTamp.longLongValue];
        if (isUpMessage) {
            // 2.再加ChatMessage
            [msgList insertObject:message atIndex:0];
            [msgList insertObject:tipMessage atIndex:0];
        }
        else{
            [msgList addObject:tipMessage];
            // 2.再加ChatMessage
            [msgList addObject:message];
        }
    }
    else{
        if (isUpMessage) {
            [msgList insertObject:message atIndex:0];
        }
        else{
            [msgList addObject:message];
        }
        
    }
    return isUpMessage;
}

- (ChatTipMessage *)getTimeMessageWithTime:(long long)timesTamp
{
    NSString *timeStr = [PBTimeTool getTalkTimeStr:timesTamp];
    ChatTipMessage *tipMessage = [ChatTipMessage new];
    tipMessage.content = timeStr;
    tipMessage.textSize = CGSizeMake(160, 16);
    tipMessage.renderHeight = 28;
    tipMessage.timesTamp = @(timesTamp);
    return tipMessage;
}

- (ChatTipMessage *)getNearTimeMessageFromMessageList
{
    ChatTipMessage *tipMessage = nil;
    for (int i = 0; i < self.messageArray.count; i ++) {
        ChatMessage *message = [self.messageArray objectAtIndex:i];
        if ([message isKindOfClass:[ChatTipMessage class]]) {
            tipMessage = (ChatTipMessage *)message;
            break;
        }
    }
    return tipMessage;
}

- (ChatTipMessage *)getNearTimeMessageFromTempMessageList:(NSMutableArray *)messageArray
{
    ChatTipMessage *tipMessage = nil;
    for (int i = 0; i < messageArray.count; i ++) {
        ChatMessage *message = [messageArray objectAtIndex:i];
        if ([message isKindOfClass:[ChatTipMessage class]]) {
            tipMessage = (ChatTipMessage *)message;
            break;
        }
    }
    return tipMessage;
}

#pragma mark - setter/getter
- (NSMutableArray *)messageArray
{
    if (!_messageArray) {
        _messageArray = [[NSMutableArray alloc] init];
    }
    return _messageArray;
}
@end
