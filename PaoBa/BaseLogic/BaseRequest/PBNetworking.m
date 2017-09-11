//
//  PBNetworking.m
//  PaoBa
//
//  Created by wujian on 2017/3/16.
//  Copyright © 2017年 wujian. All rights reserved.
//

#import "PBNetworking.h"
#import "AFNetworking.h"
#import "AFHTTPSessionManager.h"
#import "AFNetworkActivityIndicatorManager.h"

#import <CommonCrypto/CommonDigest.h>
@interface NSString (md5)

+ (NSString *)networking_md5:(NSString *)string;

@end

@implementation NSString (md5)

+ (NSString *)networking_md5:(NSString *)string {
    if (string == nil || [string length] == 0) {
        return nil;
    }
    
    unsigned char digest[CC_MD5_DIGEST_LENGTH], i;
    CC_MD5([string UTF8String], (int)[string lengthOfBytesUsingEncoding:NSUTF8StringEncoding], digest);
    NSMutableString *ms = [NSMutableString string];
    
    for (i = 0; i < CC_MD5_DIGEST_LENGTH; i++) {
        [ms appendFormat:@"%02x", (int)(digest[i])];
    }
    
    return [ms copy];
}

@end

static NSString *_privateNetworkBaseUrl = nil;              // 请求基础url，默认nil
static NSDictionary *_httpHeaders = nil;                    // http头，默认nil
static PBResponseType _responseType = PBResponseTypeJSON;   // 响应类型，默认JSON
static PBRequestType  _requestType  = PBRequestTypeJSON;    // 请求类型，默认JSON
static PBNetworkReachabilityStatus _networkStatus = PBNetworkReachabilityStatusUnkonw;  // 网络状态，默认未知网络
static NSTimeInterval _timeout = 60.0f;                     // 请求超时时间，默认60s
static BOOL _shouldAutoEncode = NO;                         // 编码，默认NO
static BOOL _cacheGet = YES;                                // 缓存GET，默认YES
static BOOL _cachePost = NO;                                // 缓存POST，默认NO
//static BOOL _shouldCallbackOnCancelRequest = YES;           // 回调取消请求，默认YES
static BOOL _shoulObtainLocalWhenUnconnected = NO;          // 获取本地缓存，默认YES
static BOOL _isEnableInterfaceDebug = NO;                   // 调试，默认NO
static NSMutableArray *_requestTasks;                       // 请求任务

typedef NS_ENUM(NSUInteger, PBHttpMedthType) {
    PBHttpMedthTypeGET              = 0,                // GET请求
    PBHttpMedthTypePOST             = 1,                // POST请求
    PBHttpMedthTypeUploadImage      = 2,                // 上传图片
    PBHttpMedthTypeUploadFile       = 3,                // 上传文件
    PBHttpMedthTypeDownload         = 4                 // 下载
};


@implementation PBNetworking

+ (NSMutableArray *)allTasks {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (_requestTasks == nil) {
            _requestTasks = [[NSMutableArray alloc] init];
        }
    });
    return _requestTasks;
}

+ (void)updateBaseUrl:(NSString *)baseUrl {
    _privateNetworkBaseUrl = baseUrl;
}

+ (NSString *)baseUrl {
    return _privateNetworkBaseUrl;
}

+ (void)configCommonHttpHeaders:(NSDictionary *)httpHeaders {
    _httpHeaders = httpHeaders;
}

+ (BOOL)shouldEncode {
    return _shouldAutoEncode;
}

+ (AFHTTPSessionManager *)manager {
    // 开启转圈圈
    [AFNetworkActivityIndicatorManager sharedManager].enabled = YES;
    
    AFHTTPSessionManager *manager = nil;;
    // 判断是否有请求基础url
    if ([self baseUrl] != nil) {
        manager = [[AFHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:[self baseUrl]]];
    } else {
        manager = [AFHTTPSessionManager manager];
    }
    // 请求类型
    switch (_requestType) {
        case PBRequestTypeJSON: {
            manager.requestSerializer = [AFJSONRequestSerializer serializer];
            break;
        }
        case PBRequestTypePlainText: {
            manager.requestSerializer = [AFHTTPRequestSerializer serializer];
            break;
        }
        default: {
            break;
        }
    }
    // 响应类型
    switch (_responseType) {
        case PBResponseTypeJSON: {
            manager.responseSerializer = [AFJSONResponseSerializer serializer];
            break;
        }
        case PBResponseTypeXML: {
            manager.responseSerializer = [AFXMLParserResponseSerializer serializer];
            break;
        }
        case PBResponseTypeData: {
            manager.responseSerializer = [AFHTTPResponseSerializer serializer];
            break;
        }
        default: {
            break;
        }
    }
    
    // 设定UTF8编码
    manager.requestSerializer.stringEncoding = NSUTF8StringEncoding;
    
    // 添加http头
    for (NSString *key in _httpHeaders.allKeys) {
        if (_httpHeaders[key] != nil) {
            [manager.requestSerializer setValue:_httpHeaders[key] forHTTPHeaderField:key];
        }
    }
    // 接收请求类型
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithArray:@[@"application/json",
                                                                              @"text/html",
                                                                              @"text/json",
                                                                              @"text/plain",
                                                                              @"text/javascript",
                                                                              @"text/xml",
                                                                              @"image/*"]];
    // 设置请求超时
    manager.requestSerializer.timeoutInterval = _timeout;
    
    // 设置允许同时最大并发数量，过大容易出问题
    manager.operationQueue.maxConcurrentOperationCount = 4;
    
    manager.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
    manager.securityPolicy.validatesDomainName = NO;
    manager.securityPolicy.allowInvalidCertificates = YES;

    // 是否读缓存
    if (_shoulObtainLocalWhenUnconnected && (_cacheGet || _cachePost ) ) {
        // 检测网络
    }
    [self detectNetwork];
    return manager;
}

+ (void)detectNetwork{
    
    AFNetworkReachabilityManager *reachabilityManager = [AFNetworkReachabilityManager sharedManager];
    [reachabilityManager startMonitoring];
    
    [reachabilityManager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        if (status == AFNetworkReachabilityStatusNotReachable){
            _networkStatus = PBNetworkReachabilityStatusNotReachable;
        }else if (status == AFNetworkReachabilityStatusUnknown){
            _networkStatus = PBNetworkReachabilityStatusUnkonw;
        }else if (status == AFNetworkReachabilityStatusReachableViaWWAN){
            _networkStatus = PBNetworkReachabilityStatusReachableViaWWAN;
        }else if (status == AFNetworkReachabilityStatusReachableViaWiFi){
            _networkStatus = PBNetworkReachabilityStatusReachableViaWiFi;
        }
    }];
}

+ (NSString *)absoluteUrlWithPath:(NSString *)path {
    // 路径处理
    if (path == nil || path.length == 0) {
        return @"";
    }
    // 没有请求基础url处理
    if ([self baseUrl] == nil || [[self baseUrl] length] == 0) {
        return path;
    }
    
    NSString *absoluteUrl = path;
    // 有请求基础url处理
    if (![path hasPrefix:@"http://"] && ![path hasPrefix:@"https://"]) {
        if ([[self baseUrl] hasSuffix:@"/"]) {
            if ([path hasPrefix:@"/"]) {
                NSMutableString * mutablePath = [NSMutableString stringWithString:path];
                [mutablePath deleteCharactersInRange:NSMakeRange(0, 1)];
                absoluteUrl = [NSString stringWithFormat:@"%@%@", [self baseUrl], mutablePath];
            }else {
                absoluteUrl = [NSString stringWithFormat:@"%@%@", [self baseUrl], path];
            }
        }else {
            if ([path hasPrefix:@"/"]) {
                absoluteUrl = [NSString stringWithFormat:@"%@%@", [self baseUrl], path];
            }else {
                absoluteUrl = [NSString stringWithFormat:@"%@/%@",[self baseUrl], path];
            }
        }
    }
    
    return absoluteUrl;
}

#pragma mark - 缓存响应
+ (void)cacheResponseObject:(id)responseObject request:(NSURLRequest *)request parameters:params {
    if (request && responseObject && ![responseObject isKindOfClass:[NSNull class]]) {
        NSString *directoryPath = cachePath();
        
        NSError *error = nil;
        
        if (![[NSFileManager defaultManager] fileExistsAtPath:directoryPath isDirectory:nil]) {
            [[NSFileManager defaultManager] createDirectoryAtPath:directoryPath
                                      withIntermediateDirectories:YES
                                                       attributes:nil
                                                            error:&error];
            if (error) {
                NSLog(@"create cache dir error: %@\n", error);
                return;
            }
        }
        
        NSString *absoluteURL = [self generateGETAbsoluteURL:request.URL.absoluteString params:params];
        NSString *key = [NSString networking_md5:absoluteURL];
        NSString *path = [directoryPath stringByAppendingPathComponent:key];
        NSDictionary *dict = (NSDictionary *)responseObject;
        
        NSData *data = nil;
        if ([dict isKindOfClass:[NSData class]]) {
            data = responseObject;
        } else {
            data = [NSJSONSerialization dataWithJSONObject:dict
                                                   options:NSJSONWritingPrettyPrinted
                                                     error:&error];
        }
        
        if (data && error == nil) {
            BOOL isOk = [[NSFileManager defaultManager] createFileAtPath:path contents:data attributes:nil];
            if (isOk) {
                NSLog(@"cache file ok for request: %@\n", absoluteURL);
            } else {
                NSLog(@"cache file error for request: %@\n", absoluteURL);
            }
        }
    }
}


+ (id)cahceResponseWithURL:(NSString *)url parameters:params {
    id cacheData = nil;
    
    if (url) {
        // 缓存路径
        NSString *directoryPath = cachePath();
        // 生成get绝对路径url
        NSString *absoluteURL = [self generateGETAbsoluteURL:url params:params];
        NSString *key = [NSString networking_md5:absoluteURL];
        NSString *path = [directoryPath stringByAppendingPathComponent:key];
        
        NSData *data = [[NSFileManager defaultManager] contentsAtPath:path];
        if (data) {
            cacheData = data;
            NSLog(@"Read data from cache for url: %@\n", url);
        }
    }
    
    return cacheData;
}


static inline NSString *cachePath() {
    return [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/PBNetworkingCaches"];
}


+ (NSString *)generateGETAbsoluteURL:(NSString *)url params:(id)params {
    if (params == nil || ![params isKindOfClass:[NSDictionary class]] || [params count] == 0) {
        return url;
    }
    
    NSString *queries = @"";
    for (NSString *key in params) {
        id value = [params objectForKey:key];
        
        if ([value isKindOfClass:[NSDictionary class]]) {
            continue;
        } else if ([value isKindOfClass:[NSArray class]]) {
            continue;
        } else if ([value isKindOfClass:[NSSet class]]) {
            continue;
        } else {
            queries = [NSString stringWithFormat:@"%@%@=%@&",
                       (queries.length == 0 ? @"&" : queries),
                       key,
                       value];
        }
    }
    
    if (queries.length > 1) {
        queries = [queries substringToIndex:queries.length - 1];
    }
    
    if (([url hasPrefix:@"http://"] || [url hasPrefix:@"https://"]) && queries.length > 1) {
        if ([url rangeOfString:@"?"].location != NSNotFound || [url rangeOfString:@"#"].location != NSNotFound) {
            url = [NSString stringWithFormat:@"%@%@", url, queries];
        } else {
            queries = [queries substringFromIndex:1];
            url = [NSString stringWithFormat:@"%@?%@", url, queries];
        }
    }
    
    return url.length == 0 ? queries : url;
}

+ (id)tryToParseData:(id)responseData {
    if ([responseData isKindOfClass:[NSData class]]) {
        // 尝试解析成JSON
        if (responseData == nil) {
            return responseData;
        } else {
            NSError *error = nil;
            NSDictionary *response = [NSJSONSerialization JSONObjectWithData:responseData
                                                                     options:NSJSONReadingMutableContainers
                                                                       error:&error];
            
            if (error != nil) {
                return responseData;
            } else {
                return response;
            }
        }
    } else {
        return responseData;
    }
}
+ (NSString *)encodeUrl:(NSString *)url {
    return [self urlEncode:url];
}

+ (NSString *)urlEncode:(NSString *)url {
    NSString *newString =
    CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                                                              (CFStringRef)url,
                                                              NULL,
                                                              CFSTR(":/?#[]@!$ &'()*+,;=\"<>%{}|\\^~`"), CFStringConvertNSStringEncodingToEncoding(NSUTF8StringEncoding)));
    if (newString) {
        return newString;
    }
    
    return url;
}

+ (void)logWithSuccessResponse:(id)response url:(NSString *)url params:(NSDictionary *)params {
    if (_isEnableInterfaceDebug) {
        NSLog(@"\n");
        NSLog(@"\nRequest success, URL: %@\n params:%@\n response:%@\n\n",[self generateGETAbsoluteURL:url params:params],params,[self tryToParseData:response]);
    }
}
+ (void)logWithFailError:(NSError *)error url:(NSString *)url params:(id)params {
    if (_isEnableInterfaceDebug) {        
        NSString *format = @" params: ";
        if (params == nil || ![params isKindOfClass:[NSDictionary class]]) {
            format = @"";
            params = @"";
        }
        
        NSLog(@"\n");
        if ([error code] == NSURLErrorCancelled) {
            NSLog(@"\nRequest was canceled mannully, URL: %@ %@%@\n\n",[self generateGETAbsoluteURL:url params:params],format,params);
        } else {
            NSLog(@"\nRequest error, URL: %@ %@%@\n errorInfos:%@\n\n",[self generateGETAbsoluteURL:url params:params],format,params,[error localizedDescription]);
        }
    }
}


+ (void)successResponse:(id)responseData callback:(PBResponseSuccess)success {
    success(PBServerRequestsStatusSuccess, _networkStatus, [self tryToParseData:responseData]);
}

+ (void)failResponse:(id)responseData callback:(PBResponseFail)fail error:(NSError *)error {
    fail(PBServerRequestsStatusFail, _networkStatus, [self tryToParseData:responseData], error);
}

+ (PBURLSessionTask *)requestWithUrl:(NSString *)url
                          refreshCache:(BOOL)refreshCache
                               iamge:(UIImage *)image
                       uploadingFile:(NSString *)uploadingFile
                            filename:(NSString *)filename
                                name:(NSString *)name
                            mimeType:(NSString *)mimeType
                          saveToPath:(NSString *)saveToPath
                             httpMedth:(PBHttpMedthType)httpMethod
                                params:(NSDictionary *)params
                              progress:(PBLoadProgress)progress
                               success:(PBResponseSuccess)success
                                  fail:(PBResponseFail)fail {
    
    AFHTTPSessionManager *manager = [self manager];
    NSString *absolute = [self absoluteUrlWithPath:url];
    
    PBURLSessionTask *session = nil;
    switch (httpMethod) {
        case PBHttpMedthTypeGET:
            [self getWithManmger:manager absolute:absolute session:session Url:url
                    refreshCache:refreshCache params:params progress:progress success:success fail:fail];
            break;
        case PBHttpMedthTypePOST:
            [self postWithManmger:manager absolute:absolute session:session Url:url
                     refreshCache:refreshCache params:params progress:progress success:success fail:fail];
            break;
        case PBHttpMedthTypeUploadImage:
            [self uploadImageWithManmger:manager absolute:absolute session:session Url:url params:params iamge:image
                                filename:filename name:name mimeType:mimeType progress:progress success:success fail:fail];
            break;
        case PBHttpMedthTypeUploadFile:
            [self uploadFileWithManmger:manager session:session Url:url uploadingFile:uploadingFile progress:progress success:success fail:fail];
            break;
        case PBHttpMedthTypeDownload:
            [self downLoadWithManmger:manager session:session Url:url saveToPath:saveToPath progress:progress success:success fail:fail];
            break;
        default:
            break;
    }
    
    // 添请求加任务
    if (session) {
        [[self allTasks] addObject:session];
    }
    return session;
}

+ (void)getWithManmger:(AFHTTPSessionManager *)manager
              absolute:(NSString *)absolute
               session:(PBURLSessionTask *)session
                   Url:(NSString *)url
          refreshCache:(BOOL)refreshCache
                params:(NSDictionary *)params
              progress:(PBLoadProgress)progress
               success:(PBResponseSuccess)success
                  fail:(PBResponseFail)fail {
    session = [manager GET:url parameters:params progress:^(NSProgress * _Nonnull downloadProgress) {
        // 请求进度
        if (progress) {
            progress(downloadProgress.completedUnitCount, downloadProgress.totalUnitCount);
        }
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        // 成功回调
        [self successResponse:responseObject callback:success];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        // 删除请求任务
        [[self allTasks] removeObject:task];
        // 缓存响应
        id response = [PBNetworking cahceResponseWithURL:absolute parameters:params];
        // 失败回调
        [self failResponse:response callback:fail error:error];
    }];
}

+ (void)postWithManmger:(AFHTTPSessionManager *)manager
              absolute:(NSString *)absolute
               session:(PBURLSessionTask *)session
                   Url:(NSString *)url
          refreshCache:(BOOL)refreshCache
                params:(NSDictionary *)params
              progress:(PBLoadProgress)progress
               success:(PBResponseSuccess)success
                  fail:(PBResponseFail)fail {
    session = [manager POST:url parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
        // 请求进度
        if (progress) {
            progress(uploadProgress.completedUnitCount, uploadProgress.totalUnitCount);
        }
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [self cacheResponseObject:responseObject request:task.currentRequest  parameters:params];
        // 成功回调
        [self successResponse:responseObject callback:success];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        // 删除请求任务
        [[self allTasks] removeObject:task];
        // 缓存响应
        id response = [PBNetworking cahceResponseWithURL:absolute parameters:params];
        // 失败回调
        [self failResponse:response callback:fail error:error];
    }];
}

+ (void)uploadImageWithManmger:(AFHTTPSessionManager *)manager
                 absolute:(NSString *)absolute
                  session:(PBURLSessionTask *)session
                      Url:(NSString *)url
                   params:(NSDictionary *)params
                    iamge:(UIImage *)image
                 filename:(NSString *)filename
                     name:(NSString *)name
                 mimeType:(NSString *)mimeType
                 progress:(PBLoadProgress)progress
                  success:(PBResponseSuccess)success
                     fail:(PBResponseFail)fail {
    if ([self baseUrl] == nil) {
        if ([NSURL URLWithString:url] == nil) {
            NSLog(@"URLString无效，无法生成URL。可能是URL中有中文，请尝试Encode URL");
            return;
        }
    } else {
        if ([NSURL URLWithString:[NSString stringWithFormat:@"%@%@", [self baseUrl], url]] == nil) {
            NSLog(@"URLString无效，无法生成URL。可能是URL中有中文，请尝试Encode URL");
            return;
        }
    }
    
    if ([self shouldEncode]) {
        url = [self encodeUrl:url];
    }
    session = [manager POST:url parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        NSData *imageData = UIImageJPEGRepresentation(image, 1);
        NSString *imageFileName = filename;
        if (filename == nil || ![filename isKindOfClass:[NSString class]] || filename.length == 0) {
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            formatter.dateFormat = @"yyyyMMddHHmmss";
            NSString *str = [formatter stringFromDate:[NSDate date]];
            imageFileName = [NSString stringWithFormat:@"%@.jpg", str];
        }
        // 上传图片，以文件流的格式
        [formData appendPartWithFileData:imageData name:name fileName:imageFileName mimeType:mimeType];
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        // 上传进度
        if (progress) {
            progress(uploadProgress.completedUnitCount, uploadProgress.totalUnitCount);
        }
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        // 删除任务
        [[self allTasks] removeObject:task];
        // 成功日志
        [self logWithSuccessResponse:responseObject url:absolute params:params];
        // 成功回调
        [self successResponse:responseObject callback:success];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        // 删除任务
        [[self allTasks] removeObject:task];
        // 失败日志
        [self logWithFailError:error url:absolute params:params];
        // 失败回调
        [self failResponse:nil callback:fail error:error];
    }];
    [session resume];
}

+ (void)uploadFileWithManmger:(AFHTTPSessionManager *)manager
                      session:(PBURLSessionTask *)session
                          Url:(NSString *)url
                uploadingFile:(NSString *)uploadingFile
                     progress:(PBLoadProgress)progress
                      success:(PBResponseSuccess)success
                         fail:(PBResponseFail)fail {
    if ([NSURL URLWithString:uploadingFile] == nil) {
        NSLog(@"uploadingFile无效，无法生成URL。请检查待上传文件是否存在");
        return;
    }
    NSURL *uploadURL = nil;
    if ([self baseUrl] == nil) {
        uploadURL = [NSURL URLWithString:url];
    } else {
        uploadURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", [self baseUrl], url]];
    }
    if (uploadURL == nil) {
        NSLog(@"URLString无效，无法生成URL。可能是URL中有中文或特殊字符，请尝试Encode URL");
        return;
    }
    NSURLRequest *request = [NSURLRequest requestWithURL:uploadURL];
    [manager uploadTaskWithRequest:request fromFile:[NSURL URLWithString:uploadingFile] progress:^(NSProgress * _Nonnull uploadProgress) {
        if (progress) {
            progress(uploadProgress.completedUnitCount, uploadProgress.totalUnitCount);
        }
    } completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        [[self allTasks] removeObject:session];
        if (error) {
            [self logWithFailError:error url:response.URL.absoluteString params:nil];
            [self successResponse:responseObject callback:success];
        } else {
            [self logWithSuccessResponse:responseObject url:response.URL.absoluteString params:nil];
            [self failResponse:responseObject callback:fail error:error];
        }
    }];
    
}

+ (void)downLoadWithManmger:(AFHTTPSessionManager *)manager
                      session:(PBURLSessionTask *)session
                          Url:(NSString *)url
                 saveToPath:(NSString *)saveToPath
                     progress:(PBLoadProgress)progress
                      success:(PBResponseSuccess)success
                         fail:(PBResponseFail)fail {
    if ([self baseUrl] == nil) {
        if ([NSURL URLWithString:url] == nil) {
            NSLog(@"URLString无效，无法生成URL。可能是URL中有中文，请尝试Encode URL");
            return;
        }
    } else {
        if ([NSURL URLWithString:[NSString stringWithFormat:@"%@%@", [self baseUrl], url]] == nil) {
            NSLog(@"URLString无效，无法生成URL。可能是URL中有中文，请尝试Encode URL");
            return;
        }
    }
    
    NSURLRequest *downloadRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    
    
    session = [manager downloadTaskWithRequest:downloadRequest progress:^(NSProgress * _Nonnull downloadProgress) {
        if (progress) {
            progress(downloadProgress.completedUnitCount, downloadProgress.totalUnitCount);
        }
    } destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
        return [NSURL URLWithString:saveToPath];
    } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
        [[self allTasks] removeObject:session];
        
        if (error == nil) {
            if (success) {
                [self successResponse:filePath.absoluteString callback:success];
            }
            if (_isEnableInterfaceDebug) {
                NSLog(@"Download success for url %@", [self absoluteUrlWithPath:url]);
            }
        } else {
            if (fail) {
                [self failResponse:response callback:fail error:error];
            }
            if (_isEnableInterfaceDebug) {
                NSLog(@"Download fail for url %@, reason : %@", [self absoluteUrlWithPath:url], [error description]);
            }
        }
    }];
    
    [session resume];
}


+ (PBURLSessionTask *)getWithUrl:(NSString *)url
                          params:(NSDictionary *)params
                         success:(PBResponseSuccess)success
                            fail:(PBResponseFail)fail
{
    return [self requestWithUrl:url
                   refreshCache:YES
                          iamge:nil
                  uploadingFile:nil
                       filename:nil
                           name:nil
                       mimeType:nil
                     saveToPath:nil
                      httpMedth:PBHttpMedthTypeGET
                         params:params
                       progress:nil
                        success:success
                           fail:fail];
}

+ (PBURLSessionTask *)getWithUrl:(NSString *)url
                    refreshCache:(BOOL)refreshCache
                          params:(NSDictionary *)params
                        progress:(PBLoadProgress)progress
                         success:(PBResponseSuccess)success
                            fail:(PBResponseFail)fail {
    return [self requestWithUrl:url
                   refreshCache:refreshCache
                          iamge:nil
                  uploadingFile:nil
                       filename:nil
                           name:nil
                       mimeType:nil
                     saveToPath:nil
                      httpMedth:PBHttpMedthTypeGET
                         params:params
                       progress:progress
                        success:success
                           fail:fail];
}


+ (PBURLSessionTask *)postWithUrl:(NSString *)url
                           params:(NSDictionary *)params
                          success:(PBResponseSuccess)success
                             fail:(PBResponseFail)fail {
    return [self requestWithUrl:url
                   refreshCache:YES
                          iamge:nil
                  uploadingFile:nil
                       filename:nil
                           name:nil
                       mimeType:nil
                     saveToPath:nil
                      httpMedth:PBHttpMedthTypePOST
                         params:params
                       progress:nil
                        success:success
                           fail:fail];
}

+ (PBURLSessionTask *)postWithUrl:(NSString *)url
                     refreshCache:(BOOL)refreshCache
                           params:(NSDictionary *)params
                         progress:(PBLoadProgress)progress
                          success:(PBResponseSuccess)success
                             fail:(PBResponseFail)fail {
    return [self requestWithUrl:url
                   refreshCache:refreshCache
                          iamge:nil
                  uploadingFile:nil
                       filename:nil
                           name:nil
                       mimeType:nil
                     saveToPath:nil
                      httpMedth:PBHttpMedthTypePOST
                         params:params
                       progress:progress
                        success:success
                           fail:fail];
}


+ (PBURLSessionTask *)uploadWithImage:(UIImage *)image
                                  url:(NSString *)url
                             filename:(NSString *)filename
                                 name:(NSString *)name
                             mimeType:(NSString *)mimeType
                           parameters:(NSDictionary *)parameters
                             progress:(PBLoadProgress)progress
                              success:(PBResponseSuccess)success
                                 fail:(PBResponseFail)fail {
    return [self requestWithUrl:url
                   refreshCache:_shouldAutoEncode
                          iamge:image
                  uploadingFile:nil
                       filename:filename
                           name:name
                       mimeType:mimeType
                     saveToPath:nil
                      httpMedth:PBHttpMedthTypeUploadImage
                         params:parameters
                       progress:progress
                        success:success
                           fail:fail];
}


+ (PBURLSessionTask *)uploadFileWithUrl:(NSString *)url
                          uploadingFile:(NSString *)uploadingFile
                               progress:(PBLoadProgress)progress
                                success:(PBResponseSuccess)success
                                   fail:(PBResponseFail)fail {
    return [self requestWithUrl:url
                   refreshCache:_shouldAutoEncode
                          iamge:nil
                  uploadingFile:uploadingFile
                       filename:nil
                           name:nil
                       mimeType:nil
                     saveToPath:nil
                      httpMedth:PBHttpMedthTypeUploadFile
                         params:nil
                       progress:progress
                        success:success
                           fail:fail];
}


+ (PBURLSessionTask *)downloadWithUrl:(NSString *)url
                           saveToPath:(NSString *)saveToPath
                             progress:(PBLoadProgress)progress
                              success:(PBResponseSuccess)success
                                 fail:(PBResponseFail)fail {
    return [self requestWithUrl:url
                   refreshCache:_shouldAutoEncode
                          iamge:nil
                  uploadingFile:nil
                       filename:nil
                           name:nil
                       mimeType:nil
                     saveToPath:saveToPath
                      httpMedth:PBHttpMedthTypeDownload
                         params:nil
                       progress:progress
                        success:success
                           fail:fail];
}

+ (PBNetworkReachabilityStatus)appNetworkReachabilityStatus
{
    return _networkStatus;
}

@end
