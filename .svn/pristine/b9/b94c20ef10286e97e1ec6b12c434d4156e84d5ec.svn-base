//
//  NSDate+Additions.m
//  CarRentalClient
//
//  Created by 王健功 on 15/6/12.
//  Copyright (c) 2015年 TAC. All rights reserved.
//

#import "NSDate+Additions.h"

@implementation NSDate (Additions)

- (NSString *)dateToStringWithFormat:(NSString *)dateFormat
{
	NSDateFormatter *format = [[NSDateFormatter alloc] init];
	[format setDateFormat:dateFormat];
	return [format stringFromDate:self];
}

- (NSInteger)getHour
{
	NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
	NSInteger unitFlags = NSHourCalendarUnit;
	NSDateComponents *component = [calendar components:unitFlags fromDate:self];
	return [component hour];
}

- (NSInteger)getMinite
{
	NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
	NSInteger unitFlags = NSMinuteCalendarUnit;
	NSDateComponents *component = [calendar components:unitFlags fromDate:self];
	return [component minute];
}

- (NSString *)getWeekDay
{
	NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
	NSInteger unitFlags = NSCalendarUnitWeekday;
	NSDateComponents *component = [calendar components:unitFlags fromDate:self];
	NSInteger weekDay = [component weekday];
	NSString *weekDayString = nil;
	switch (weekDay) {
		case 1:
			weekDayString = @"星期日";
			break;
		case 2:
			weekDayString = @"星期一";
			break;
		case 3:
			weekDayString = @"星期二";
			break;
		case 4:
			weekDayString = @"星期三";
			break;
		case 5:
			weekDayString = @"星期四";
			break;
		case 6:
			weekDayString = @"星期五";
			break;
		case 7:
			weekDayString = @"星期六";
			break;
		default:
			break;
	}
	return weekDayString;
}


@end
