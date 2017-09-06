//
//  PBTalkAdapter.h
//  PaoBa
//
//  Created by wujian on 2017/8/18.
//  Copyright © 2017年 wujian. All rights reserved.
//

#import "PBAdapter.h"

@protocol PBTalkAdapterDelegate <NSObject>

- (void)startToGetMoreData;

@end


@interface PBTalkAdapter : PBAdapter

@property (nonatomic, weak) id <PBTalkAdapterDelegate> talkAdapterDelegate;
/** 获取tableContent高度 **/
- (float)getTableContentHeight;

- (void)endLoading;
- (void)setLoadingEnable:(BOOL)enable;

@end
