//
//  SQItemTMSHandler.h
//  scan_qrcode_demo
//
//  Created by Codger on 16/3/29.
//
//

#import <Foundation/Foundation.h>
#import "SQUrlMacro.h"

typedef NS_ENUM(NSInteger, SQHTTPMethod) {
    SQHTTPMethodGet = 0,
    SQHTTPMethodPost,
    SQHTTPMethodPut,
    SQHTTPMethodDelete
};

@interface SQItemTMSHandler : NSObject

@property (nonatomic, strong) NSDictionary *parameterDic;

@property (nonatomic, strong) NSString *functionName;

- (void)handleTMSRequestWithHttpMethod:(NSString *)method block:(ResponseBlock)blcok;

@end
    