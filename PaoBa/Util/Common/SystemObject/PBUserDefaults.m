//
//  PBUserDefaults.m
//  PaoBa
//
//  Created by wujian on 2017/8/18.
//  Copyright © 2017年 wujian. All rights reserved.
//

#import "PBUserDefaults.h"

NSString *const KTalkMessageRowId                = @"talkMessageRowId";

@implementation PBUserDefaults

+ (void)load
{
    //初始化rowId值
    if (![PBUserDefaults getCurrentRowId]) {
        [PBUserDefaults saveRowIdToDB:@(10000)];
    }
}

+ (NSNumber *)getCurrentRowId
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSNumber *rowId = [defaults objectForKey:KTalkMessageRowId];
    return rowId;
}

+ (void)saveRowIdToDB:(NSNumber *)rowId
{
    if (rowId) {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setObject:rowId forKey:KTalkMessageRowId];
        [defaults synchronize];
    }
}

@end
