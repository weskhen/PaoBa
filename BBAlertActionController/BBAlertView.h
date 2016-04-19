//
//  BBAlertView.h
//  PaoBa
//
//  Created by wujian on 4/14/16.
//  Copyright © 2016 wesk痕. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^BBAlertViewBlock)(UIAlertView *alertView);
typedef void (^BBAlertViewCompletionBlock)(UIAlertView *alertView, NSInteger buttonIndex);

@interface BBAlertView : UIAlertView

@property (nonatomic, copy) BBAlertViewBlock didPresentBlock;
@property (nonatomic, copy) BBAlertViewCompletionBlock clickedButtonBlock;

@end
