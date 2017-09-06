//
//  PBChatLabel.h
//  PaoBa
//
//  Created by wujian on 2017/8/18.
//  Copyright © 2017年 wujian. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PBChatLabelDelegate <NSObject>

@required
/** 是否响应touch事件 默认响应  自定义类型可以下这个回调函数里实现**/
- (BOOL)hasTouchPBChatLabelWillContinue;

@optional
/** 电话号码文本触发 **/
- (void)phoneNumberTouch:(NSString *)phoneNumber;

/** 链接文本触发 **/
- (void)urlStringTouch:(NSURL *)url;

@end
@interface PBChatLabel : UILabel

@property (nonatomic, weak) id <PBChatLabelDelegate> delegate;

@end
