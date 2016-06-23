//
//  CRRequestManager.m
//  CarRental
//
//  Created by 王健功 on 15/11/12.
//  Copyright © 2015年 JieXing. All rights reserved.
//

#import "CRRequestManager.h"
//#import "CRURLMarco.h"
//#import "CRLoginControll.h"
#import "YTKJSONSerializerWithData.h"




@interface CRRequestManager ()

@property (nonatomic, strong) id argument;
@property (nonatomic, strong) NSString *detailUrl;
@end
@implementation CRRequestManager

+ (id)initWithArgument:(id)argument withDetailUrl:(NSString *)detailUrl
{
	CRRequestManager *request = [[CRRequestManager alloc] init];
	request.argument = argument;
	request.detailUrl = detailUrl;
	return request;
}

+ (void)initWithArgument:(id)argument withDetailUrl:(NSString *)detailUrl completionBlock:(ResponseBlock)completion
{
	CRRequestManager *request = [CRRequestManager initWithArgument:argument withDetailUrl:detailUrl];
	[request startWithCompletionBlockWithSuccess:^(YTKBaseRequest *request) {
		NSString *returnFlag = request.responseJSONObject[@"returnFlag"];
		NSString *msg = nil;
		NSString *msgCode = nil;
        NSLog(@"获取到的数据:%@",request.responseJSONObject);
		id data = request.responseJSONObject[@"returnData"][@"data"];
		if ([returnFlag integerValue] != 200) {
			
			
            
                    NSError *error = [NSError errorWithDomain:@""
                                                         code:[msgCode intValue]
                                                     userInfo:request.responseJSONObject[@"returnData"]];
                    completion(nil,error);
            
            
            
		}else{
			completion(data,nil);
		}
	} failure:^(YTKBaseRequest *request) {
		NSError *requestError = request.requestError;
		NSError *error = nil;
		if (requestError.code != -999) {
			//-999取消当前请求的code
			NSDictionary *errorDic = requestError.userInfo[@"JSON Error"];
			if (errorDic) {
				error = [NSError errorWithDomain:@""
											code:0
										userInfo:@{@"returnMsg":@"请求失败"}];
			}
			else{
				if (requestError.code == -1009) {
					error = [NSError errorWithDomain:@""
												code:0
											userInfo:@{@"returnMsg":@"网络连接未打开，请在\"设置\"检测网络设置"}];
				}else{
					error = [NSError errorWithDomain:@""
												code:0
											userInfo:@{@"returnMsg":@"网络连接不正常"}];
				}
			}
		}
		completion(nil,error);
	}];
}

- (NSString *)baseUrl
{
	return TMS_BASE_URL;
}

- (YTKRequestMethod)requestMethod
{
	return YTKRequestMethodGet;
}

- (YTKRequestSerializerType)requestSerializerType
{
	return YTKRequestSerializerTypeJSON;
}

- (id)requestArgument
{
	return self.argument;
}

- (NSString *)requestUrl
{
	return self.detailUrl;
}


@end
