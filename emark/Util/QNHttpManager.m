//
//  QNHttpManager.m
//  emark
//
//  Created by huweiya on 2018/5/7.
//  Copyright © 2018年 neebel. All rights reserved.
//

#import "QNHttpManager.h"


@implementation HTTPManagerSession

+ (instancetype)sharedSession {
    static HTTPManagerSession *_sharedClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        _sharedClient = [[HTTPManagerSession alloc] init];
        
    });
    
    return _sharedClient;
}

- (id)init {
    self = [super init];
    if (self) {
        // 设置超时时间
        [self.requestSerializer willChangeValueForKey:@"timeoutInterval"];
        self.requestSerializer.timeoutInterval = REQUEST_TIMEOUT_DURATION;
        [self.requestSerializer didChangeValueForKey:@"timeoutInterval"];

        // 设置ContentType
        AFJSONResponseSerializer *responseSerializer = [AFJSONResponseSerializer serializer];
        responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/html", @"application/x-javascript", @"text/plain", nil];
        self.responseSerializer = responseSerializer;
    }
    return self;
}

@end
@implementation QNHttpManager



+ (NSURLSessionDataTask *)GET:(NSString *)url
                   parameters:(NSDictionary *)parameters
                      success:(successBlock)successBlock
                      failure:(failureBlock)failureBlock {
    
    // 监测网络状态
    NSURLSessionDataTask *operation =
    [[HTTPManagerSession sharedSession] GET:url
                                 parameters:parameters
                                   progress:^(NSProgress * _Nonnull downloadProgress) {
                                       
                                   }
                                    success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                                        if (successBlock) {
                                            successBlock(task, responseObject);
                                        }
                                    }
                                    failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                                        if (failureBlock) {
                                            failureBlock(task, error);
                                            
                                        }
                                    }];
    
    return operation;
}




+ (NSURLSessionDataTask *)POST:(NSString *)url
                    parameters:(NSDictionary *)parameters
                       success:(successBlock)successBlock
                       failure:(failureBlock)failureBlock
{
    

    
    //2.发送Post请求
    NSURLSessionDataTask *operation =
    [[HTTPManagerSession sharedSession] POST:url
                                  parameters:parameters
                                    progress:^(NSProgress * _Nonnull downloadProgress) {
                                        
                                    }
                                     success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                                         if (successBlock) {
                                             successBlock(task, responseObject);
                                         }
                                     }
                                     failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                                         if (failureBlock) {
                                             failureBlock(task, error);
                                        
                                             
                                         }
                                     }];
    return operation;
}

@end
