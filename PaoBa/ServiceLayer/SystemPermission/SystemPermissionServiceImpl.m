//
//  SystemPermissionServiceImpl.m
//  PaoBa
//
//  Created by wujian on 4/18/16.
//  Copyright © 2016 wesk痕. All rights reserved.
//

#import "SystemPermissionServiceImpl.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <AVFoundation/AVFoundation.h>
#import <CoreLocation/CLLocationManager.h>
#import <AddressBook/AddressBook.h>
#import <UIKit/UIKit.h>
#import <Photos/Photos.h>


@interface SystemPermissionServiceImpl  ()

@property (nonatomic, assign)     ABAddressBookRef addressBook;

@end

@implementation SystemPermissionServiceImpl

- (void)judgeSystemAlbumPermissionsSuccess:(void (^)(void))succeedHandler withFailedHandel:(void (^)(BOOL chmod))failedHandle
{
    if (IS_IOS9_OR_HIGHER) {

        PHAuthorizationStatus status = [PHPhotoLibrary authorizationStatus];
        if (status == PHAuthorizationStatusRestricted || status == PHAuthorizationStatusDenied)
        {
            // 无权限
            if (IS_IOS8_OR_HIGHER && [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]]) {
                failedHandle(true);
                return;
            }
            else {
                failedHandle(false);
                return;
            }
        }
        else if (status == PHAuthorizationStatusNotDetermined)
        {
            [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (status == PHAuthorizationStatusAuthorized)
                    {
                        succeedHandler();
                    }
                    else
                    {
                        if (IS_IOS8_OR_HIGHER && [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]]) {
                            failedHandle(true);
                            return;
                        }
                        else {
                            failedHandle(false);
                            return;
                        }
                    }
                });

            }];
        }
        else
        {
            succeedHandler();
        }
    }
    else
    {
        ALAuthorizationStatus authStatus = [ALAssetsLibrary authorizationStatus];
        if (authStatus == ALAuthorizationStatusDenied || authStatus == ALAuthorizationStatusRestricted) {
            if (IS_IOS8_OR_HIGHER && [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]]) {
                failedHandle(true);
                return;
            }
            else {
                failedHandle(false);
                return;
            }
        }
        succeedHandler();
    }
    
}


- (void)judgeSystemCameraPermissionsSuccess:(void (^)(void))succeedHandler withFailedHandel:(void (^)(BOOL chmod))failedHandle
{
    
    if (IS_IOS7_OR_HIGHER) {
        
        AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
        if (authStatus == AVAuthorizationStatusDenied || authStatus == AVAuthorizationStatusRestricted) {
            if (IS_IOS8_OR_HIGHER && [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]]) {
                failedHandle (true);
            }
            else {
                failedHandle (false);
            }
        }
        else if(authStatus == AVAuthorizationStatusAuthorized)
        {
            succeedHandler();
        }
        else if (authStatus == ALAuthorizationStatusNotDetermined){
            [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    if(granted){
                        succeedHandler();
                    }
                    
                    else {
                        if (IS_IOS8_OR_HIGHER && [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]]) {
                            failedHandle (true);
                        }
                        else {
                            failedHandle (false);
                        }
                    }
                    
                });
                
            }];
        }
    }
    else {
        succeedHandler ();
    }
    
}

- (void)judgeSystemRecordPermissionsSuccess:(void (^)(void))succeedHandler withFailedHandel:(void (^)(BOOL chmod))failedHandle
{
    if (IS_IOS7_OR_HIGHER)
    {
        [[AVAudioSession sharedInstance] requestRecordPermission:^(BOOL granted) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (granted) {
                    
                    succeedHandler();
                }
                else {
                    if (IS_IOS8_OR_HIGHER && [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]]) {
                        
                        failedHandle(true);
                    }
                    else {
                        failedHandle(false);
                    }
                }
            });
            
        }];
    }
    else
    {
        succeedHandler();
    }
    
}

- (void)judeSystemLocationPermissionsSuccess:(void (^)(void))succeedHandler withFailedHandel:(void (^)(BOOL chmod))failedHandle
{
    if (IS_IOS8_OR_HIGHER) {
        if ([CLLocationManager locationServicesEnabled] && [CLLocationManager authorizationStatus] != kCLAuthorizationStatusDenied && [CLLocationManager authorizationStatus] != kCLAuthorizationStatusRestricted) {
            succeedHandler();
        }
        else
        {
            if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]]) {
                
                failedHandle(true);
            }
            else {
                failedHandle(false);
            }
        }
    }
    else
    {
        if ([CLLocationManager locationServicesEnabled]&& ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorized || [CLLocationManager authorizationStatus] == kCLAuthorizationStatusNotDetermined)) {
            succeedHandler();
        }
        else
        {
            failedHandle(false);
        }
    }
}

- (void)judgeSystemAddressBookPermissionsSuccess:(void (^)(void))succeedHandler withFailedHandel:(void (^)(BOOL chmod))failedHandle
{
    if (IS_IOS8_OR_HIGHER)
    {
        if (&ABAddressBookRequestAccessWithCompletion != NULL)
        {
            ABAddressBookRequestAccessWithCompletion(self.addressBook, ^(bool granted, CFErrorRef error)
            {
                if (granted) {
                    succeedHandler();
                }
                else
                {
                    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]])
                    {
                        
                        failedHandle(true);
                    }
                    else {
                        failedHandle(false);
                    }
                }
            });
        }

    }
    else
    {
        if (&ABAddressBookRequestAccessWithCompletion != NULL)
        {
            ABAddressBookRequestAccessWithCompletion(self.addressBook, ^(bool granted, CFErrorRef error)
            {
                if (granted) {
                    succeedHandler();
                }
                else
                {
                    failedHandle(false);
                }
            });
        }

    }
}

- (void)judgeSystemNotificationPermissionsSuccess:(void (^)(void))succeedHandler withFailedHandel:(void (^)(BOOL chmod))failedHandle
{
    BOOL pushEnabled;
    
    // 设置里的通知总开关是否打开
    BOOL settingEnabled = [[UIApplication sharedApplication] isRegisteredForRemoteNotifications];
    // 设置里的通知各子项是否都打开
    BOOL subsettingEnabled = [[UIApplication sharedApplication] currentUserNotificationSettings].types != UIUserNotificationTypeNone;
    
    pushEnabled = settingEnabled && subsettingEnabled;
    if (pushEnabled) {
        succeedHandler();
    }
    else
    {
        if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]])
        {
            
            failedHandle(true);
        }
        else {
            failedHandle(false);
        }
    }
}


- (void)registerNotificationSettings
{
#ifdef __IPHONE_8_0
    if (IS_IOS8_OR_HIGHER) {
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeBadge
                                                                                             | UIUserNotificationTypeSound
                                                                                             | UIUserNotificationTypeAlert)
                                                                                 categories:nil];
        [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
    }
    else
#endif
    {
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeAlert)];
    }
}

#pragma mark - setter/getter
- (ABAddressBookRef )addressBook
{
    @synchronized (self)
    {
        if (_addressBook == NULL)
        {
            if (&ABAddressBookCreateWithOptions)
            {
                _addressBook = ABAddressBookCreateWithOptions(NULL, NULL);
            }
        }
        return _addressBook;
    }
}

@end
