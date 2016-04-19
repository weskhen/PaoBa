//
//  BBMicrophonePermissionsAlert.h
//  PaoBa
//
//  Created by wujian on 4/14/16.
//  Copyright © 2016 wesk痕. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BBAlertViewManager.h"

@interface BBMicrophonePermissionsAlert : NSObject

+ (BBMicrophonePermissionsAlert *)sharedInstance;

//弹出麦克风权限提示框 带有去设置的功能
- (void)showAlertWithController:(UIViewController *)controller cancelClicked:(cancelHandler)cancelHandle setButtonClicked:(settingHandle)settingHandle;
//弹出麦克风权限提示框
- (void)showAlertWithController:(UIViewController *)controller cancelClicked:(cancelHandler)cancelHandle;

@end
