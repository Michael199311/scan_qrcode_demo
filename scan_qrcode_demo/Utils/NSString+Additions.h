//
//  NSString+Additions.h
//  CarRentalStaff
//
//  Created by Nathan on 11/29/14.
//  Copyright (c) 2014 Tom Hu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Additions)

/**
 *  string transform date
 *
 */
- (NSDate *)stringToDateWithFormat:(NSString *)dateFormat;
/**
 *  NSString UTF-8转码
 *
 *  @return 转成UTF-8的NSString 对象
 */
- (NSString *)encodeUrlString;
/**
 *  获取两个时间字符串之间的时间间隔
 *
 *  @param anotherDateString 时间字符串
 *
 *  @return 返回时间间隔
 */
- (NSTimeInterval)timeIntervalSinceDateString:(NSString *)anotherDateString;
/**
 *  非空字符串
 *
 *  @param string string
 *
 *  @return 是否为空
 */
+ (BOOL) isNotEmptyString:(NSString *)string;
/**
 *  将null,nil的string转换成@""，这个主要是对后台返回的数据进行NULL检测
 *  如果检测NULL,有可能会crash
 */
+ (NSString *)validateString:(NSString *)string;
/**
 *  根据宽度，字体获取字符串对应显示的高度
 *
 *  @param value 需要显示的内容
 *  @param font  字体font
 *  @param width 指定宽度
 *
 *  @return 高度
 */
+ (CGFloat)heightForString:(NSString *)value font:(UIFont*)font andWidth:(float)width;
/**
 *  对字符串进行MD5加密
 *
 *  @param string 需要加密的字符串
 *
 */
+ (NSString *)md5WithString:(NSString *)string;

@end
