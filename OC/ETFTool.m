//
//  ETFTool.m
//  JingTeYuHui
//
//  Created by Dj H on 2017/7/14.
//  Copyright © 2017年 Dj H. All rights reserved.
//

#import "ETFTool.h"
#define userTag @"user"
#define tokenTag @"token"
#define stokenTag @"stoken"
#import <MessageUI/MessageUI.h>

@interface ETFTool () <MFMessageComposeViewControllerDelegate>

@property (nonatomic, strong) NSDate *currentDate;

@end

@implementation ETFTool

- (instancetype)init {
    if (self = [super init]) {
    }
    return self;
}

- (NSString*)today{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *currentDateStr = [dateFormatter stringFromDate:[NSDate date]];
    return currentDateStr;
}

- (NSString*)get7daysago:(NSString*)day{
    NSDate *date=[self strtodate:day];
    //
    NSTimeInterval  oneDay = 24*60*60*1;
    date=[date initWithTimeIntervalSinceNow:-oneDay*7];
    //
    //date=[date dateByAddingTimeInterval:-oneDay*7];
    //
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *currentDateStr = [dateFormatter stringFromDate:date];
    return currentDateStr;
}

- (NSString *)daysAgo:(NSInteger)numDays currentDay:(NSString *)day {
    NSDate *date = [self strtodate:day];
    NSTimeInterval  oneDay = 24*60*60*1;
    date=[date initWithTimeInterval:-oneDay*numDays sinceDate:date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *currentDateStr = [dateFormatter stringFromDate:date];
    return currentDateStr;
}

- (NSString *)todaysAgo:(NSInteger)numDays currentDay:(NSString *)day {
    NSDate *date = [self strtodate:day];
    NSTimeInterval  oneDay = 24*60*60*1;
    date=[date initWithTimeInterval:oneDay*numDays sinceDate:date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *currentDateStr = [dateFormatter stringFromDate:date];
    return currentDateStr;
}

- (NSString*)to7daysago{
    
    NSTimeInterval  oneDay = 24*60*60*1;
    NSDate *date =[[NSDate alloc] initWithTimeIntervalSinceNow:-oneDay*7];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *currentDateStr = [dateFormatter stringFromDate:date];
    return currentDateStr;
}

- (NSString*)dateformat:(NSDate*)date format:(NSString*)format{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:format];
    NSString *currentDateStr = [dateFormatter stringFromDate:date];
    return currentDateStr;
}

- (NSDate*)formatdate:(NSString*)sdate format:(NSString*)format{
    NSDateFormatter* dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:format];
    NSDate *date = [dateFormat dateFromString:sdate];
    return date;
}

NSString *msdatetostr(double time,NSString *format){
    NSDate *date=[NSDate dateWithTimeIntervalSince1970:(time-25569)*86400];//f*86400 1970开始 windows下语言为1899-12-30开始
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:format];//@"yyyy-MM-dd HH:mm:ss"
    [dateFormatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC"]];
    NSString *str = [dateFormatter stringFromDate:date];
    return str;
}




- (NSString *)getCurrentDate {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSString *dateTime = [formatter stringFromDate:[NSDate date]];
    return dateTime;
}

-(NSString*)getNextMonthDate{
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
//    NSDateComponents *comps = nil;
//    comps = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay fromDate:[NSDate date]];
    NSDateComponents *adcomps = [[NSDateComponents alloc] init];
    [adcomps setYear:0];
    [adcomps setMonth:+1];
    [adcomps setDay:0];
    NSDate *newdate = [calendar dateByAddingComponents:adcomps toDate:[NSDate date] options:0];
    //
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSString *dateTime = [formatter stringFromDate:newdate];
    return dateTime;
}


-(NSString*)getdayfrist{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *comps;
    //本年
    comps = [calendar components:(NSCalendarUnitYear) fromDate:[NSDate date]];
    NSInteger year = [comps year];
    //本月
    comps = [calendar components:(NSCalendarUnitMonth) fromDate:[NSDate date]];
    NSInteger month = [comps month];
    //
    NSString *firstDay = [NSString stringWithFormat:@"%.4ld-%.2ld-%.2d",(long)year,(long)month,1];
    return firstDay;
}

-(NSString*) getdaylast{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *comps;
    //本年
    comps = [calendar components:(NSCalendarUnitYear) fromDate:[NSDate date]];
    NSInteger year = [comps year];
    //本月
    comps = [calendar components:(NSCalendarUnitMonth) fromDate:[NSDate date]];
    NSInteger month = [comps month];
    //本月第一天的星期
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    NSTimeZone *timeZone = [NSTimeZone localTimeZone];
    [formatter setTimeZone:timeZone];
    [formatter setDateFormat:@"M/d/yyyy"];
    NSString *firstDay = [NSString stringWithFormat:@"%ld/%d/%ld",(long)month,1,(long)year];
    NSDate *date = [formatter dateFromString:firstDay];
    //下月第一天
    NSDateComponents *c1 = [[NSDateComponents alloc] init];
    [c1 setMonth:1];
    NSDate *date2 = [calendar dateByAddingComponents:c1 toDate:date options:0];
    //本月最后一天
    NSDateComponents *c2 = [[NSDateComponents alloc] init];
    [c2 setDay:-1];
    NSDate *date3 = [calendar dateByAddingComponents:c2 toDate:date2 options:0];
    comps = [calendar components:(NSCalendarUnitDay) fromDate:date3];
    
    NSInteger maxDays = [comps day];
    return [NSString stringWithFormat:@"%.4ld-%.2ld-%.2ld",(long)year,(long)month,(long)maxDays];
}

//
- (NSString *)strdatetotime:(NSString*)value{
    value=[value stringByReplacingOccurrencesOfString:@"/" withString:@"-"];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];//yyyy-MM-dd HH:mm:ss
    [dateFormatter setTimeZone:[NSTimeZone systemTimeZone]];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *dt=[dateFormatter dateFromString:value];
    //系统时间 北京时间
    [dateFormatter setTimeZone:[NSTimeZone systemTimeZone]];
    [dateFormatter setDateStyle:NSDateFormatterShortStyle];
    [dateFormatter setDateFormat:@"HH:mm:ss"];
    return  [dateFormatter stringFromDate:dt];
}

- (NSDate *)strtodate:(NSString*)value{
    if(value.length==10){
        value=[NSString stringWithFormat:@"%@ 00:00:00",value];
    }
    NSDateFormatter* dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    [dateFormat setTimeZone:[NSTimeZone systemTimeZone]];
    //[dateFormat setDateStyle:NSDateFormatterShortStyle];
    NSDate *date = [dateFormat dateFromString:value];
    return date;
}

//天数要计算当天 时 调用 后天数+1
- (NSInteger)numberOfDaysWithFromDate:(NSDate *)fromDate toDate:(NSDate *)toDate{
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents    * comp = [calendar components:NSCalendarUnitDay
                                         fromDate:fromDate
                                         toDate:toDate
                                         options:NSCalendarWrapComponents];
    //NSLog(@" -- >>  comp : %@  << --",comp);
    return comp.day;
}

- (NSInteger)numberOfMonthsWithFromDate:(NSDate *)fromDate toDate:(NSDate *)toDate{
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents    * comp = [calendar components:NSCalendarUnitMonth
                                             fromDate:fromDate
                                               toDate:toDate
                                              options:NSCalendarWrapComponents];
    //NSLog(@" -- >>  comp : %@  << --",comp);
    return comp.month;
}

- (NSInteger)numberOfYearsWithFromDate:(NSDate *)fromDate toDate:(NSDate *)toDate{
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents    * comp = [calendar components:NSCalendarUnitYear
                                             fromDate:fromDate
                                               toDate:toDate
                                              options:NSCalendarWrapComponents];
    //NSLog(@" -- >>  comp : %@  << --",comp);
    return comp.year;
}

- (NSString *)getDateTimeWith:(NSDate *)date {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setTimeZone:[NSTimeZone systemTimeZone]];
    [dateFormatter setDateStyle:NSDateFormatterShortStyle];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    return  [dateFormatter stringFromDate:date];
}

-(NSString*)get_time {
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setTimeZone:[NSTimeZone systemTimeZone]];
    [dateFormatter setDateStyle:NSDateFormatterShortStyle];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    return  [dateFormatter stringFromDate:[NSDate date]];
}


-(NSString *)documentsPath:(NSString *)fileName {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    return [documentsDirectory stringByAppendingPathComponent:fileName];
}

-(void)save_Array:(NSString *)fileName Array:(NSArray*)arr{
  [arr writeToFile:[self documentsPath:fileName] atomically:YES];
}
-(NSArray *)load_Array:(NSString *)fileName{
   NSString *filePath = [self documentsPath:fileName];
   return [NSArray arrayWithContentsOfFile:filePath];
}

- (NSString *)weekdayOfDayStr:(NSString *)dateStr {
    if (!dateStr) {
        return @"";
    }
    dateStr = [dateStr stringByReplacingOccurrencesOfString:@"T" withString:@" "];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    if ([dateStr containsString:@":"]) {
        [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    } else {
        [formatter setDateFormat:@"yyyy-MM-dd"];
    }
    
    
    NSDate *date = [formatter dateFromString:dateStr];
    NSInteger num = [self numberOfDaysWithFromDate:date toDate:[NSDate date]];
    NSArray *weekdays = [NSArray arrayWithObjects:[NSNull null],@"周日",@"星期一",@"星期二",@"星期三",@"星期四",@"星期五",@"星期六", nil];
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSTimeZone *timeZone = [[NSTimeZone alloc] initWithName:@"Asia/Shanghai"];
    [calendar setTimeZone:timeZone];
    NSCalendarUnit calendarUnit = NSCalendarUnitWeekday;
    
    NSDateComponents *dateComponents = [calendar components:calendarUnit fromDate:date];
    NSDateComponents *currentComponents = [calendar components:calendarUnit fromDate:[NSDate date]];
    if (num > (7-currentComponents.weekday)) {
        return [[dateStr componentsSeparatedByString:@" "] firstObject];
    } else if (num == 0) {
        NSTimeInterval interval = [date timeIntervalSinceDate:[NSDate date]];
        long temp = 0;
        if (interval < 60) {
            return [NSString stringWithFormat:@"刚刚"];
        } else if ((temp = interval/60) < 60) {
            return [NSString stringWithFormat:@"%ld分钟前",temp];
        } else if ((temp = interval/(60*60)) < 24) {
            return [NSString stringWithFormat:@"%ld小时前",temp];
        }
    }
    return [weekdays objectAtIndex:dateComponents.weekday];
}

@end
