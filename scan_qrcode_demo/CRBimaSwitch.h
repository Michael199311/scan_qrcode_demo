//
//  CRBimaSwitch.h
//  CarRental
//
//  Created by Codger on 16/3/8.
//  Copyright © 2016年 JieXing. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, CRBimaSwitchState){
    CRBimaSwitchStateLeft = 0,
    CRBimaSwitchStateRight
};

typedef void(^buttonAction)(NSDictionary *info,NSInteger type);

@interface CRBimaSwitch : UIView

@property (nonatomic, copy) buttonAction buttonActionBlock;
@property (nonatomic, assign) CRBimaSwitchState switchState;
/**
 *  是否可用
 */
@property (nonatomic, assign) BOOL useAble;

@end
