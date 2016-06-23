//
//  SQModelLocation.h
//  scan_qrcode_demo
//
//  Created by Codger on 16/4/1.
//
//

#import <Foundation/Foundation.h>

@interface SQModelLocation : NSObject

@property (nonatomic, strong) NSString *typeValue;
@property (nonatomic, strong) NSString *locationId;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *code;
@property (nonatomic, strong) NSString *address;
@property (nonatomic, strong) NSString *locationDescription;
@property (nonatomic, strong) NSString *manInCharge;
@property (nonatomic, strong) NSString *manInChargeContract;
@property (nonatomic, strong) NSString *type;
@property (nonatomic, strong) NSString *createUserId;
@property (nonatomic, strong) NSString *createTime;

@end
