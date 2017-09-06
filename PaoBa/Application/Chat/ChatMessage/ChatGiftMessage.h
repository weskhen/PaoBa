//
//  ChatGiftMessage.h
//  PaoBa
//
//  Created by wujian on 2017/8/18.
//  Copyright © 2017年 wujian. All rights reserved.
//

#import "ChatMessage.h"

@interface ChatGiftMessage : ChatMessage

@property (nonatomic, strong)  NSNumber *giftId; //礼物Id
@property (nonatomic, strong)  NSString *giftName;//礼物名字
@property (nonatomic, strong)  NSString *giftIcon;//礼物icon地址

@property (nonatomic, strong)  NSString *exp; //经验增长
@property (nonatomic, strong)  NSNumber *giftNumber;//礼物个数


/** 矢量 **/
@property (nonatomic, assign)  CGFloat titleHeight;//标题高度
@property (nonatomic, strong)  NSAttributedString *titleString;//标题高度



@end
