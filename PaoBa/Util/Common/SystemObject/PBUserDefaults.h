//
//  PBUserDefaults.h
//  PaoBa
//
//  Created by wujian on 2017/8/18.
//  Copyright © 2017年 wujian. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PBUserDefaults : NSUserDefaults

//消息rowId 保存
+ (NSNumber *)getCurrentRowId;
+ (void)saveRowIdToDB:(NSNumber *)rowId;

@end
