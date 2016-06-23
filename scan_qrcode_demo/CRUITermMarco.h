//
//  CRUITermMarco.h
//  CarRental
//
//  Created by 王健功 on 15/6/30.
//  Copyright (c) 2015年 JieXing. All rights reserved.

#ifndef CarRental_CRUITermMarco_h
#define CarRental_CRUITermMarco_h

//屏幕相关
#pragma mark - screen

#define APP_SCREEN_WIDTH ([[UIScreen mainScreen]bounds].size.width)
#define APP_SCREEN_HEIGHT ([[UIScreen mainScreen]bounds].size.height)
#define APP_SCREEN_WITHOUT_STATUS_HEIGHT (SCREEN_HEIGHT - [[UIApplication sharedApplication] statusBarFrame].size.height)
//颜色
#pragma mark - color
//十六进制颜色转换
#define UIColorFromHEX(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]
#define UIColorRGB(r,g,b,a)	[UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:(a)]
//设备
#pragma mark - device
/**
 *  判断g当前设备系统版本号是否超过某个版本
 */
#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
//对象
#pragma mark - init object
#define UIImageDefine(v) [UIImage imageNamed:v]

//请求相关
#define REQUEST_ERROR_MESSAGE @"returnMsg"

#define DATE_FORMAT_1 @"yyyy-MM-dd HH:mm"
#define DATE_FORMAT_2 @"yyyy-MM-dd"
#define DATE_FORMAT_3 @"HH:mm MM月dd日"

#endif
