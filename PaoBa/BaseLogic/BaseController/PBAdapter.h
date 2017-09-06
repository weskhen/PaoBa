//
//  PBAdapter.h
//  PaoBa
//
//  Created by wujian on 2017/8/18.
//  Copyright © 2017年 wujian. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@protocol PBAdapterDelegate <NSObject>

@optional
- (void)didSelectCellData:(id)cellData;

- (void)didSelectCellData:(id)cellData indexPath:(NSIndexPath *)indexPath;
@end
@interface PBAdapter : NSObject<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, weak)     id<PBAdapterDelegate>                    adapterDelegate;



- (NSArray*)getAdapterArray;
- (void)setAdapterArray:(NSArray*)arr;

@end
