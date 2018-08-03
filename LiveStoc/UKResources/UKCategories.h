//
//  UKCategories.h
//  LiveStoc
//
//  Created by Harjit Singh on 12/18/17.
//  Copyright © 2017 Harjit Singh. All rights reserved.
//

#import <Foundation/Foundation.h>

#define AMLocalizedString(key, comment) \
[[LocalizationSystem sharedLocalSystem] localizedStringForKey:(key) value:(comment)]

#define LocalizationSetLanguage(language) \
[[LocalizationSystem sharedLocalSystem] setLanguage:(language)]

#define LocalizationGetLanguage \
[[LocalizationSystem sharedLocalSystem] getLanguage]

#define LocalizationReset \
[[LocalizationSystem sharedLocalSystem] resetLocalization]

@interface UKCategories : NSObject

@end
@interface NSMutableArray (UKMutableArray)

- (void)reverse;

@end


@interface NSDate (UKDate)


#pragma mark - Component Properties

@property (nonatomic, readonly) NSInteger year;
@property (nonatomic, readonly) NSInteger month;
@property (nonatomic, readonly) NSInteger day;
@property (nonatomic, readonly) NSInteger hour;
@property (nonatomic, readonly) NSInteger minute;
@property (nonatomic, readonly) NSInteger second;
@property (nonatomic, readonly) NSInteger nanosecond;
@property (nonatomic, readonly) NSInteger weekday;
@property (nonatomic, readonly) NSInteger weekdayOrdinal;
@property (nonatomic, readonly) NSInteger weekOfMonth;
@property (nonatomic, readonly) NSInteger weekOfYear;
@property (nonatomic, readonly) NSInteger yearForWeekOfYear;
@property (nonatomic, readonly) NSInteger quarter;
@property (nonatomic, readonly) BOOL isLeapMonth;
@property (nonatomic, readonly) BOOL isLeapYear;
@property (nonatomic, readonly) BOOL isToday;
@property (nonatomic, readonly) BOOL isYesterday;


//NS_ASSUME_NONNULL_BEGIN

#pragma mark - Date modify

- ( NSDate *)dateByAddingYears:(NSInteger)years;

- ( NSDate *)dateByAddingMonths:(NSInteger)months;

- ( NSDate *)dateByAddingWeeks:(NSInteger)weeks;

- ( NSDate *)dateByAddingDays:(NSInteger)days;

- ( NSDate *)dateByAddingHours:(NSInteger)hours;

- ( NSDate *)dateByAddingMinutes:(NSInteger)minutes;

- ( NSDate *)dateByAddingSeconds:(NSInteger)seconds;



#pragma mark - Date Format


- ( NSString *)stringWithFormat:(NSString *)format;

- ( NSString *)stringWithFormat:(NSString *)format
                       timeZone:( NSTimeZone *)timeZone
                         locale:( NSLocale *)locale;

- ( NSString *)stringWithISOFormat;

+ ( NSDate *)dateWithString:(NSString *)dateString format:(NSString *)format;

+ ( NSDate *)dateWithString:(NSString *)dateString
                     format:(NSString *)format
                   timeZone:( NSTimeZone *)timeZone
                     locale:( NSLocale *)locale;

+ ( NSDate *)dateWithISOFormatString:(NSString *)dateString;

@end


@interface NSMutableDictionary (UKMutableDictionary)


- (NSArray *)allKeysSorted;
- (NSArray *)allValuesSortedByKeys;
- (BOOL)containsObjectForKey:(id)key;
- (NSDictionary *)entriesForKeys:(NSArray *)keys;
- (NSString *)jsonStringEncoded;
- (BOOL)boolValueForKey:(NSString *)key default:(BOOL)def;
- (int)intValueForKey:(NSString *)key default:(int)def;

@end
@interface NSString (UKString)
+(NSString *)dateToFormatedDateWord:(NSString *)dateStr;
- (BOOL) isValidEmail: (NSString *) candidate;
+(NSString *)base64String:(NSString *)str;
@end

@interface LocalizationSystem : NSObject
{
    NSString *language;
}

// you really shouldn't care about this functions and use the MACROS
+ (LocalizationSystem *)sharedLocalSystem;


//gets the string localized
- (NSString *)localizedStringForKey:(NSString *)key value:(NSString *)comment;

//sets the language
- (void) setLanguage:(NSString*) language;

//gets the current language
- (NSString*) getLanguage;

//resets this system.
- (void) resetLocalization;

@end
