//
//  ChatMessage.m
//  PaoBa
//
//  Created by wujian on 2017/8/18.
//  Copyright © 2017年 wujian. All rights reserved.
//

#import "ChatMessage.h"
#import "PBOwnUser.h"
#import "PBUserDefaults.h"

@implementation ChatMessage


- (BOOL)isMessageLeft
{
    if (self.fromuid.longLongValue == _Owner.userId.longLongValue) {
        //如果消息的发送者id是自己 靠右
        return NO;
    }
    return YES;
}

- (NSString *)selfAvatarString
{
    return _Owner.avatarUrl;
}

+ (ChatMessage *)chatMsgWithContent:(NSString *)content
                            msgType:(NSNumber *)msgType
                               user:(PBDetailUser *)user
                            msgTime:(NSNumber *)msgTime
                             isSend:(BOOL)isSend
{
    ChatMessage *msg = [[ChatMessage alloc] init];
    
    if (isSend) {
        msg.fromuid          = _Owner.userId;
        msg.touid            = user.userId;
    }
    else {
        msg.fromuid          = user.userId;
        msg.touid            = _Owner.userId;
    }
    
    msg.otherPartyName   = user.name;

    msg.sessionId        = user.userId;
    msg.msgtype          = msgType;
    msg.timesTamp        = msgTime;
    msg.content          = content;
    
    NSNumber *currentRowId = [PBUserDefaults getCurrentRowId];
    NSNumber *insertRowId  = @(currentRowId.longLongValue +1);
    msg.rowid              = currentRowId;
    [PBUserDefaults saveRowIdToDB:insertRowId];
    
    if (ISEmptyString(user.name)) {
        msg.otherPartyName = user.userId.stringValue;
    }
    return msg;
}

@end
