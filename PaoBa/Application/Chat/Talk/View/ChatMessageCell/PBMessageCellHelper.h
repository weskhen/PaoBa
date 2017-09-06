//
//  PBMessageCellHelper.h
//  PaoBa
//
//  Created by wujian on 2017/8/18.
//  Copyright © 2017年 wujian. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PBMessageCellHelper : NSObject

+ (PBMessageCellHelper*)sharedInstance;

- (Class)getRenderClassByMessageType:(int)msgType;

@end
