//
//  PBTalkTableHeaderView.h
//  PaoBa
//
//  Created by wujian on 2017/8/18.
//  Copyright © 2017年 wujian. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PBTalkTableHeaderViewDelegate <NSObject>

- (void)followButtonClicked;

@end
@interface PBTalkTableHeaderView : UIView

@property (nonatomic, weak) id <PBTalkTableHeaderViewDelegate> delegate;

@end
