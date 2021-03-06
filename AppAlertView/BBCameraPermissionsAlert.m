//
//  BBCameraPermissionsAlert.m
//  PaoBa
//
//  Created by wujian on 4/14/16.
//  Copyright © 2016 wesk痕. All rights reserved.
//

#import "BBCameraPermissionsAlert.h"
#import "BBAlertController.h"

@interface BBCameraPermissionsAlert ()

@property (nonatomic, assign) BOOL  isAlertHaveShow;

@end

@implementation BBCameraPermissionsAlert

static BBCameraPermissionsAlert *instance = NULL;

+ (BBCameraPermissionsAlert *)sharedInstance{
    if (!instance) {
        instance = [BBCameraPermissionsAlert new];
    }
    return instance;
    
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.isAlertHaveShow = false;
    }
    return self;
}


- (void)showAlertWithController:(UIViewController *)controller cancelClicked:(cancelHandler)cancelHandle setButtonClicked:(settingHandle)settingHandle
{
    if (self.isAlertHaveShow) {
        return;
    }
    self.isAlertHaveShow = true;
    __weak __typeof(self) weakSelf = self;
    BBAlertController *alertController = [BBAlertController alertControllerWithTitle:CCLocalizedString(@"popup_permission_required") message:CCLocalizedString(@"baba_access_cameradesc") preferredStyle:BBAlertControllerStyleAlert];
    [alertController addAction:[BBAlertAction actionWithTitle:CCLocalizedString(@"common.ok") style:BBAlertActionStyleCancel handler:^(BBAlertAction *action){
        cancelHandle();
        weakSelf.isAlertHaveShow = false;
    }]];
    
    [alertController addAction:[BBAlertAction actionWithTitle:CCLocalizedString(@"mobilecontactsview.enable") style:BBAlertActionStyleDefault handler:^(BBAlertAction *action){
        settingHandle();
        weakSelf.isAlertHaveShow = false;
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
    }]];
    [controller presentAlertController:alertController animated:true completion:nil];
    
}

- (void)showAlertWithController:(UIViewController *)controller cancelClicked:(cancelHandler)cancelHandle
{
    if (self.isAlertHaveShow) {
        return;
    }
    
    self.isAlertHaveShow = true;
    __weak __typeof(self) weakSelf = self;
    BBAlertController *alertController = [BBAlertController alertControllerWithTitle:CCLocalizedString(@"popup_permission_required") message:CCLocalizedString(@"baba_access_cameradesc") preferredStyle:BBAlertControllerStyleAlert];
    [alertController addAction:[BBAlertAction actionWithTitle:CCLocalizedString(@"common.ok") style:BBAlertActionStyleCancel handler:^(BBAlertAction *action){
        weakSelf.isAlertHaveShow = false;
        cancelHandle();
    }]];
    [controller presentAlertController:alertController animated:true completion:nil];
    
    
}

@end
