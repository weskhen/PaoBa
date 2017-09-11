//
//  PBNetworking.h
//  PaoBa
//
//  Created by wujian on 2017/3/16.
//  Copyright © 2017年 wujian. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, PBResponseType) {
    PBResponseTypeJSON = 1,         // 默认
    PBResponseTypeXML  = 2,         // XML
    PBResponseTypeData = 3          // 特殊情况下，一转换服务器就无法识别的，默认会尝试转换成JSON，若失败则需要自己去转换
};

typedef NS_ENUM(NSUInteger, PBRequestType) {
    PBRequestTypeJSON       = 1,    // 默认
    PBRequestTypePlainText  = 2     // 普通text/html
};

typedef NSURLSessionTask PBURLSessionTask;

typedef void(^PBResponseSuccess)(PBServerRequestsStatus status, PBNetworkReachabilityStatus reachability,  id response);

typedef void(^PBResponseFail)(PBServerRequestsStatus status, PBNetworkReachabilityStatus reachability, id response, NSError *error);


typedef void(^PBLoadProgress)(int_fast64_t bytesRead, int_fast64_t totalBytesRead);


@interface PBNetworking : NSObject

/**
 *  更新请求接口基础url（如果服务器地址有多个）
 *  @param baseUrl 请求接口基础url
 */
+ (void)updateBaseUrl:(NSString *)baseUrl;


/**
 *  配置公共的请求头，用于区分请求来源，需要与服务器约定好
 *  @param httpHeaders      如@{"client" : "iOS"}
 */
+ (void)configCommonHttpHeaders:(NSDictionary *)httpHeaders;


/**
 *  GET请求接口
 *  @param url          访问地址路径，如/user/index/login
 *  @param params       需要传的参数，如@{@"user_id" :@(80011)}
 *  @param success      接口请求响应成功回调
 *  @param fail         接口请求响应失败回调
 *  @return             NSURLSessionTask
 */
+ (PBURLSessionTask *)getWithUrl:(NSString *)url
                          params:(NSDictionary *)params
                         success:(PBResponseSuccess)success
                            fail:(PBResponseFail)fail;
/**
 *  GET请求接口
 *  @param url          访问地址路径，如/user/index/login
 *  @param refreshCache 是否刷新缓存，YES
 *  @param params       需要传的参数，如@{@"user_id" :@(80011)}
 *  @param progress     进度回调，
 *  @param success      接口请求响应成功回调
 *  @param fail         接口请求响应失败回调
 *  @return             NSURLSessionTask
 */
+ (PBURLSessionTask *)getWithUrl:(NSString *)url
                    refreshCache:(BOOL)refreshCache
                          params:(NSDictionary *)params
                        progress:(PBLoadProgress)progress
                         success:(PBResponseSuccess)success
                            fail:(PBResponseFail)fail;


/**
 *  POST请求接口
 *  @param url          访问地址路径，如/user/index/login
 *  @param params       需要传的参数，如@{@"user_id" :@(80011)}
 *  @param success      接口请求响应成功回调
 *  @param fail         接口请求响应失败回调
 *  @return             NSURLSessionTask
 */
+ (PBURLSessionTask *)postWithUrl:(NSString *)url
                           params:(NSDictionary *)params
                          success:(PBResponseSuccess)success
                             fail:(PBResponseFail)fail;

/**
 *  POST请求接口
 *  @param url          访问地址路径，如/user/index/login
 *  @param refreshCache 是否刷新缓存，YES
 *  @param params       需要传的参数，如@{@"user_id" :@(80011)}
 *  @param progress     进度回调，
 *  @param success      接口请求响应成功回调
 *  @param fail         接口请求响应失败回调
 *  @return             NSURLSessionTask
 */
+ (PBURLSessionTask *)postWithUrl:(NSString *)url
                     refreshCache:(BOOL)refreshCache
                           params:(NSDictionary *)params
                         progress:(PBLoadProgress)progress
                          success:(PBResponseSuccess)success
                             fail:(PBResponseFail)fail;


/**
 *  图片上传接口
 *  @param image        图片对象
 *  @param url          上传图片路径，如/user/images
 *  @param filename     文件名字，默认为当前时间yyyyMMddHHmmss.jpg
 *  @param name         约定关联名称，如image
 *  @param mimeType     默认iamge/jpeg
 *  @param parameters   需要传的参数，如@{@"user_id" :@(80011)}
 *  @param progress     上传进度回调
 *  @param success      上传成功回调
 *  @param fail         上传失败回调
 *  @return             NSURLSessionTask
 */
+ (PBURLSessionTask *)uploadWithImage:(UIImage *)image
                                  url:(NSString *)url
                             filename:(NSString *)filename
                                 name:(NSString *)name
                             mimeType:(NSString *)mimeType
                           parameters:(NSDictionary *)parameters
                             progress:(PBLoadProgress)progress
                              success:(PBResponseSuccess)success
                                 fail:(PBResponseFail)fail;


/**
 *  上传文件
 *  @param url              上传文件路径，如/user/images
 *  @param uploadingFile    待上传文件路径，如/user/images
 *  @param progress         进度回调
 *  @param success          上传成功回调
 *  @param fail             上传失败回调
 *  @return                 NSURLSessionTask
 */
+ (PBURLSessionTask *)uploadFileWithUrl:(NSString *)url
                          uploadingFile:(NSString *)uploadingFile
                               progress:(PBLoadProgress)progress
                                success:(PBResponseSuccess)success
                                   fail:(PBResponseFail)fail;


/**
 *  下载文件
 *  @param url              下载文件URL
 *  @param saveToPath       下载到那个路径下
 *  @param progress         下载进度
 *  @param success          下载成功后的回调
 *  @param fail             下载失败后的回调
 *  @return NSURLSessionTask
 */
+ (PBURLSessionTask *)downloadWithUrl:(NSString *)url
                           saveToPath:(NSString *)saveToPath
                             progress:(PBLoadProgress)progress
                              success:(PBResponseSuccess)success
                                 fail:(PBResponseFail)fail;



/**
 * @return XLAFNetworkReachabilityStatus    当前网络状态
 **/
+ (PBNetworkReachabilityStatus)appNetworkReachabilityStatus;

@end
