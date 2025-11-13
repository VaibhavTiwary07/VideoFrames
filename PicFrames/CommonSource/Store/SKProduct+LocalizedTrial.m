//
//  SKProduct+LocalizedPrice.m
//  InstaSplash
//
//  Created by Vijaya kumar reddy Doddavala on 9/27/12.
//  Copyright (c) 2012 motorola. All rights reserved.
//

#import "SKProduct+LocalizedTrial.h"

@implementation SKProduct (LocalizedTrial)

- (NSString *)LocalizedTrial
{
//    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
//    [numberFormatter setFormatterBehavior:NSNumberFormatterBehavior10_4];
//    [numberFormatter setNumberStyle:NSNumberFormatterCurrencyStyle];
//    [numberFormatter setLocale:self.priceLocale];
//    NSString *formattedString = [numberFormatter stringFromNumber:self.price];
//    [numberFormatter release];
//    return formattedString;

if (@available(iOS 11.2, *)) {
    
    NSDateComponentsFormatter *formatter = [[NSDateComponentsFormatter alloc] init];
    [formatter setUnitsStyle:NSDateComponentsFormatterUnitsStyleFull]; //e.g 1 month
    formatter.zeroFormattingBehavior = NSDateComponentsFormatterZeroFormattingBehaviorDropAll;
    NSDateComponents * dateComponents = [[NSDateComponents alloc]init];
    [dateComponents setCalendar:[NSCalendar currentCalendar]];
    
    switch (self.introductoryPrice.subscriptionPeriod.unit) {
        case SKProductPeriodUnitDay:{
            formatter.allowedUnits = NSCalendarUnitDay;
            [dateComponents setDay:self.introductoryPrice.subscriptionPeriod.numberOfUnits];
            break;
        }
        case SKProductPeriodUnitWeek:{
            formatter.allowedUnits = NSCalendarUnitWeekOfMonth;
            [dateComponents setWeekOfMonth:self.introductoryPrice.subscriptionPeriod.numberOfUnits];
            break;
        }
        case SKProductPeriodUnitMonth:{
            formatter.allowedUnits = NSCalendarUnitMonth;
            [dateComponents setMonth:self.introductoryPrice.subscriptionPeriod.numberOfUnits];
            break;
        }
        case SKProductPeriodUnitYear:{
            formatter.allowedUnits = NSCalendarUnitYear;
            [dateComponents setYear:self.introductoryPrice.subscriptionPeriod.numberOfUnits];
            break;
        }
        default:{
            return nil;
            break;
        }
            break;
    }
    [dateComponents setValue:self.introductoryPrice.subscriptionPeriod.numberOfUnits forComponent:formatter.allowedUnits];
    return [formatter stringFromDateComponents:dateComponents];
    
} else {
    // Fallback on earlier versions
}

return nil;
}
@end
