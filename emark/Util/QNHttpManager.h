//
//  QNHttpManager.h
//  emark
//
//  Created by huweiya on 2018/5/7.
//  Copyright © 2018年 neebel. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"

typedef void (^successBlock)(NSURLSessionDataTask *operation, NSDictionary *responseDic);
typedef void (^failureBlock)(NSURLSessionDataTask *operation, NSError *error);

#define REQUEST_TIMEOUT_DURATION 30

@interface HTTPManagerSession : AFHTTPSessionManager

+ (instancetype)sharedSession;

@end

@interface QNHttpManager : NSObject


/**
 发送GET请求
 @param url 路径
 @param parameters 参数
 @param successBlock 成功后回调
 @param failureBlock 失败后回调
 @return 网络任务
 */
+ (NSURLSessionDataTask *)GET:(NSString *)url
                   parameters:(NSDictionary *)parameters
                      success:(successBlock)successBlock
                      failure:(failureBlock)failureBlock;


/**
 *  发送一个POST请求
 *
 *  @param url     请求路径
 *  @param params  请求参数
 *  @param success 请求成功后的回调（请将请求成功后想做的事情写到这个block中）
 *  @param failure 请求失败后的回调（请将请求失败后想做的事情写到这个block中）
 */
+ (NSURLSessionDataTask *)POST:(NSString *)url
                    parameters:(NSDictionary *)parameters
                       success:(successBlock)successBlock
                       failure:(failureBlock)failureBlock;
@end
