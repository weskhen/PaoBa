//
//  PBDetailUser.h
//  PaoBa
//
//  Created by wujian on 2017/8/18.
//  Copyright © 2017年 wujian. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PBDetailUser : NSObject

@property (nonatomic, strong)  NSNumber *userId;
@property (nonatomic, strong)  NSString *avatarUrl;
@property (nonatomic, strong)  NSString *name;
@property (nonatomic, strong)  NSNumber *isFollowing;//是否关注
@end
