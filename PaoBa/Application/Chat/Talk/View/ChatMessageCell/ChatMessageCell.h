//
//  ChatMessageCell.h
//  PaoBa
//
//  Created by wujian on 2017/8/18.
//  Copyright © 2017年 wujian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ChatMessage.h"

@interface ChatMessageCell : UITableViewCell

@property (nonatomic, strong)   ChatMessage *chatMessage;

@property (nonatomic, assign)   CGRect  touchFailedFrame;
@property (nonatomic, assign)   CGRect  touchAvatarFrame;
@property (nonatomic, assign)   CGRect  touchMenuFrame; //ContentBgFrame

+ (NSMutableDictionary*)getRegisteredRenderCellMap;
+ (void)registerRenderCell:(Class)cellClass messageType:(int)mtype;

/** 消息绘制 **/
- (void)gotoDrawingCell;

/** 设置点击失败按钮触发位置 **/
- (void)setTouchFailedFrame:(CGRect)frame;
/** 设置点击头像位置 **/
- (void)setTouchAvatarFrame:(CGRect)frame;
/** 设置长按出现菜单范围 **/
- (void)setTouchMenuFrame:(CGRect)frame;

@end
