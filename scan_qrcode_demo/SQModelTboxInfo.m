//
//  CRModelTCUInfo.m
//  scan_qrcode_demo
//
//  Created by Codger on 16/1/8.
//
//

#import "SQModelTboxInfo.h"
#import "MJExtension.h"

@implementation SQModelTboxInfo

- (NSDictionary *)replacedKeyFromPropertyName{
    return @{@"TboxId":@"id"};
}

@end
