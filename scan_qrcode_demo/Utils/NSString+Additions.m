//
//  NSString+Additions.m
//  CarRentalStaff
//
//  Created by Nathan on 11/29/14.
//  Copyright (c) 2014 Tom Hu. All rights reserved.
//

#import "NSString+Additions.h"
#import "NSObject+Additions.h"
#import "CommonCrypto/CommonDigest.h"

@implementation NSString (Additions)

- (NSDate *)stringToDateWithFormat:(NSString *)dateFormat
{
	NSDateFormatter *format = [[NSDateFormatter alloc] init];
	[format setDateFormat:dateFormat];
	return [format dateFromString:self];
}

- (NSString *)encodeUrlString {
    NSString *sUrl = (NSString *)CFBridgingRelease
    (CFURLCreateStringByAddingPercentEscapes(
                                             kCFAllocatorDefault,
                                             (CFStringRef)[self copy],
                                             NULL,
                                             NULL,
                                             kCFStringEncodingUTF8)
     );
	return sUrl;
}

- (NSTimeInterval)timeIntervalSinceDateString:(NSString *)anotherDateString;
{
	NSTimeInterval interval = 0;
	NSDate *date = [self stringToDateWithFormat:DATE_FORMAT_1];
	NSDate *anotherDate = [anotherDateString stringToDateWithFormat:DATE_FORMAT_1];
	interval = [date timeIntervalSinceDate:anotherDate];
	return interval;
}

+ (BOOL) isNotEmptyString:(NSString *)string
{
	return (string != nil && string.length != 0);
}

+ (NSString *)validateString:(NSString *)string
{
	return [NSObject isNotNull:string];
}

+ (CGFloat)heightForString:(NSString *)value font:(UIFont *)font andWidth:(float)width
{
	
	NSDictionary *attribute = @{NSFontAttributeName:font};
	CGSize sizeToFit = [value boundingRectWithSize:CGSizeMake(width, CGFLOAT_MAX)
										   options:NSStringDrawingUsesLineFragmentOrigin
										attributes:attribute
										   context:nil].size;
	return sizeToFit.height;
}

+ (NSString *)md5WithString:(NSString *)string{
    const char *str = [string UTF8String];
    unsigned char r[CC_MD5_DIGEST_LENGTH];
    CC_MD5(str, (uint32_t)strlen(str), r);
    return [NSString stringWithFormat:@"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",
            r[0], r[1], r[2], r[3], r[4], r[5], r[6], r[7], r[8], r[9], r[10], r[11], r[12], r[13], r[14], r[15]];
}
@end
