//
//  SystemPermissionServiceProtocol.h
//  PaoBa
//
//  Created by wujian on 4/18/16.
//  Copyright © 2016 wesk痕. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol SystemPermissionServiceProtocol <NSObject>

//相册权限
- (void)judgeSystemAlbumPermissionsSuccess:(void (^)(void))succeedHandler withFailedHandel:(void (^)(BOOL chmod))failedHandle;
//相机权限
- (void)judgeSystemCameraPermissionsSuccess:(void (^)(void))succeedHandler withFailedHandel:(void (^)(BOOL chmod))failedHandle;
//录音权限
- (void)judgeSystemRecordPermissionsSuccess:(void (^)(void))succeedHandler withFailedHandel:(void (^)(BOOL chmod))failedHandle;

//定位权限
- (void)judeSystemLocationPermissionsSuccess:(void (^)(void))succeedHandler withFailedHandel:(void (^)(BOOL chmod))failedHandle;

//通讯录权限
- (void)judgeSystemAddressBookPermissionsSuccess:(void (^)(void))succeedHandler withFailedHandel:(void (^)(BOOL chmod))failedHandle;

@end
