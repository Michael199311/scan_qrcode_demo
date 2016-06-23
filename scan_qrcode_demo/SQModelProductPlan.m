//
//  SQModelProductPlan.m
//  scan_qrcode_demo
//
//  Created by Codger on 16/4/11.
//
//

#import "SQModelProductPlan.h"
#import "MJExtension.h"

@implementation SQModelProductPlan


- (NSDictionary *)replacedKeyFromPropertyName{
    return @{@"productPlanId":@"id",@"wetherNew":@"new"};
}
@end
