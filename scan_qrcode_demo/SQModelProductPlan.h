//
//  SQModelProductPlan.h
//  scan_qrcode_demo
//
//  Created by Codger on 16/4/11.
//
//

#import <Foundation/Foundation.h>

@interface SQModelProductPlan : NSObject
@property (nonatomic, strong) NSString *productPlanId;
@property (nonatomic, strong) NSString *tcuModelId;
@property (nonatomic, strong) NSString *batchNo;
@property (nonatomic, strong) NSString *startNo;
@property (nonatomic, assign) NSInteger planTotal;
@property (nonatomic, assign) NSInteger actualTotal;
@property (nonatomic, strong) NSString *status;
@property (nonatomic, strong) NSString *oem;
@property (nonatomic, strong) NSString *deliveryDeadline;
@property (nonatomic, assign) BOOL deleted;
@property (nonatomic, assign) BOOL wetherNew;

@end
