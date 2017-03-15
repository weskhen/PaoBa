//
//  PBMainControllerProtocol.h
//  PaoBa
//
//  Created by wujian on 2017/3/14.
//  Copyright © 2017年 wujian. All rights reserved.
//

typedef enum : NSUInteger {
    PBMainControllFrom_ViewController = 0,
    PBMainControllFrom_SettController,
    PBMainControllFrom_ChatController,
} PBMainControllFrom;

//外部类对MainController进行的操作
@protocol PBMainControllerProtocol <NSObject>

- (void)setControllerFromSource:(PBMainControllFrom )source;

@end

