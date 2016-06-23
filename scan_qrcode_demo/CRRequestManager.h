//
//  CRRequestManager.h
//  CarRental
//
//  Created by 王健功 on 15/11/12.
//  Copyright © 2015年 JieXing. All rights reserved.
//  网络请求基础类，这里设置了一些基础的request信息，比如baseurl等所有网络请求业务相关的类都需要继承此类

#import "YTKRequest.h"
#import "SQUrlMacro.h"

typedef void (^ResponseBlock)(id responseObject, NSInteger statusCode);

@interface CRRequestManager : YTKRequest

+ (id)initWithArgument:(id)argument withDetailUrl:(NSString *)detailUrl;
/**
 * 执行网络请求
 *
 *  @param argument  请求需要传入的参数
 *  @param detailUrl detail url，具体执行那些操作的动作url
 *  @param block     请求完成后执行的回调
 */
+ (void)initWithArgument:(id)argument withDetailUrl:(NSString *)detailUrl completionBlock:(ResponseBlock)completion;



@end
