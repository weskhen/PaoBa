//
//  PBMessageCellHelper.m
//  PaoBa
//
//  Created by wujian on 2017/8/18.
//  Copyright © 2017年 wujian. All rights reserved.
//

#import "PBMessageCellHelper.h"
#import "ChatMessageCell.h"

@implementation PBMessageCellHelper

+ (PBMessageCellHelper*)sharedInstance
{
    static PBMessageCellHelper* instance = NULL;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    return instance;
}

- (Class)getRenderClassByMessageType:(int)msgType
{
    Class renderClass = NULL;
    NSMutableDictionary* renderMap = [ChatMessageCell getRegisteredRenderCellMap];
    NSString* className = [renderMap objectForKey:[NSNumber numberWithInt:msgType]];
    if (!className) {
        className = @"ChatUnknowCell";
    }
    renderClass = NSClassFromString(className);
    return renderClass;
}

@end
