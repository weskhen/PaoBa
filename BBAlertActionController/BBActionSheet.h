//
//  BBActionSheet.h
//  PaoBa
//
//  Created by wujian on 4/14/16.
//  Copyright © 2016 wesk痕. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^BBActionSheetBlock)(UIActionSheet *actionSheet);
typedef void (^BBActionSheetCompletionBlock)(UIActionSheet *actionSheet, NSInteger buttonIndex);

@interface BBActionSheet : UIActionSheet

@property (nonatomic, copy) BBActionSheetBlock didPresentBlock;
@property (nonatomic, copy) BBActionSheetCompletionBlock clickedButtonBlock;

@end
