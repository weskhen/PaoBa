//
//  PBTimeTool.h
//  PaoBa
//
//  Created by wujian on 2017/8/18.
//  Copyright © 2017年 wujian. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PBTimeTool : NSObject

/**
 *  返回格式化后的时间
 *
 *  @param timestamp 时间戳
 */
+ (NSString *)getTalkTimeStr:(long long)timestamp;

@end
