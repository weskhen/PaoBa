//
//  ServiceFactory.h
//  PaoBa
//
//  Created by wujian on 12/14/15.
//  Copyright © 2015 wesk痕. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SystemPermissionServiceProtocol.h"
#import "UserLogicServiceProtocol.h"

#define _Service [ServiceFactory sharedInstance]

@interface ServiceFactory : NSObject

+ (ServiceFactory *)sharedInstance;

- (dispatch_queue_t)getServiceQueue;

- (void)startAllService;
- (void)stopAllService;

- (id <SystemPermissionServiceProtocol>)getSystemPermissionService;
- (id <UserLogicServiceProtocol>)getUserLogicService;

//- (void)performTaskInServiceThread:(dispatch_block_t)block async:(BOOL)async;

@end
