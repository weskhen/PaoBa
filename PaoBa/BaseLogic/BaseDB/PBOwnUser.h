//
//  PBOwnUser.h
//  PaoBa
//
//  Created by wujian on 2017/8/18.
//  Copyright © 2017年 wujian. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PBDetailUser.h"

@interface PBOwnUser : NSObject

#define _Owner [[PBOwnUser sharedInstance] getCurrentOwner]

+ (PBOwnUser *)sharedInstance;


@property (nonatomic, strong) PBDetailUser *owner;


- (PBDetailUser *)getCurrentOwner;


@end
