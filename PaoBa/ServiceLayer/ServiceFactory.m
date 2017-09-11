//
//  ServiceFactory.m
//  PaoBa
//
//  Created by wujian on 12/14/15.
//  Copyright © 2015 wesk痕. All rights reserved.
//

#import "ServiceFactory.h"
//#import "DaoFactory.h"

#import "SystemPermissionServiceImpl.h"
#import "UserLogicServiceImpl.h"

@interface ServiceFactory ()

@property (nonatomic, assign)   BOOL isStarted;

@property (nonatomic, strong) SystemPermissionServiceImpl *systemPermissionService;
@property (nonatomic, strong) UserLogicServiceImpl        *userLogicService;
@end

#define ServiceQueueSpecific "com.wesk.service_queue"
static dispatch_queue_t serviceQueue = NULL;

@implementation ServiceFactory


+ (ServiceFactory *)sharedInstance {
    static ServiceFactory *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [ServiceFactory new];
    });
    return instance;
}

- (dispatch_queue_t)getServiceQueue {
    return serviceQueue;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        [self startAllService];
    }
    return self;
}

-(void)startAllService
{
    if(self.isStarted){
        return;
    }
    self.isStarted=YES;
    self.systemPermissionService = [SystemPermissionServiceImpl new];
    self.userLogicService = [UserLogicServiceImpl new];
    
}

-(void)stopAllService
{
    
}


- (id <SystemPermissionServiceProtocol>)getSystemPermissionService
{
    return _systemPermissionService;
}

- (id <UserLogicServiceProtocol>)getUserLogicService
{
    return _userLogicService;
}
//
//- (void)performTaskInServiceThread:(dispatch_block_t)block async:(BOOL)async
//{
//    if (async) {
//        dispatch_async(self.getServiceQueue, ^{
//            block();
//        });
//    }
//    else
//    {
//        dispatch_async(dispatch_get_main_queue(), ^{
//            block();
//        });
//    }
//}

@end
