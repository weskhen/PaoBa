//
//  NSObject+BaseController.h
//  ResponderBaseController
//
//  Created by wujian on 6/28/16.
//  Copyright © 2016 wesk痕. All rights reserved.
//

#import <Foundation/Foundation.h>


@class PBController;
@interface NSObject (BaseController)

@property (nonatomic, weak)  PBController *baseController;

@end
