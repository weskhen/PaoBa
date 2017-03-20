//
//  PBRequestManage.m
//  PaoBa
//
//  Created by wujian on 2017/3/15.
//  Copyright © 2017年 wujian. All rights reserved.
//

#import "PBRequestManage.h"
#import "PBWeakTimerTarget.h"
#import "PBRequestCommon.h"

@interface PBRequestManage ()

@property (nonatomic, strong) NSMutableDictionary *reqMap;
@property (nonatomic, assign) int reqSequence;

@property (nonatomic, strong) NSTimer *timer;
@end
@implementation PBRequestManage


+ (PBRequestManage *)sharedInstance
{
    static PBRequestManage *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [PBRequestManage new];
    });
    return instance;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.reqMap = [[NSMutableDictionary alloc] init];
        self.reqSequence = 0;
        self.timer = [PBWeakTimerTarget scheduledTimerWithTimeInterval:1 target:self selector:@selector(checkTimeout) userInfo:nil repeats:true];
    }
    return self;
}

- (void)checkTimeout
{
    @synchronized (self) {
        NSMutableArray* timeoutedArray=[NSMutableArray new];
        [self.reqMap enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
            PBRequestCommon* request=(PBRequestCommon*)obj;
            if([request isTimeouted]){
                NSLog(@"reqid=%d,callback=%@ timeouted",request.reqId,request.delegate);
                [timeoutedArray addObject:[NSNumber numberWithInt:request.reqId]];
                [request.delegate onCallFail:nil];
            }
        }];
        for(NSNumber* timeoutReqId in timeoutedArray){
            [self.reqMap removeObjectForKey:timeoutReqId];
        }
    }
}

- (int)getNextReqId
{
    @synchronized(self)
    {
        return self.reqSequence++;
    }
}

- (void)addReq:(PBRequestCommon *)req withId:(int)seqid
{
    @synchronized(self)
    {
        [self.reqMap setObject:req forKey:[NSNumber numberWithInt:seqid]];
        NSLog(@"addReq,reqid=%d,callback=%@",seqid,req.delegate);
    }
}

- (void)removeReq:(PBRequestCommon *)req withId:(int)seqid
{
    @synchronized(self)
    {
        [self.reqMap removeObjectForKey:[NSNumber numberWithInt:seqid]];
        NSLog(@"removeReq,reqid=%d",seqid);
    }
}

@end