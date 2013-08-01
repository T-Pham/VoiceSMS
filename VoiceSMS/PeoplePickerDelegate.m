//
//  PeoplePickerDelegate.m
//  VoiceSMS
//
//  Created by eastagile 87:21 on 8/1/13.
//  Copyright (c) 2013 eastagile. All rights reserved.
//

#import "PeoplePickerDelegate.h"
#import <CoreTelephony/CTCarrier.h>
#import <CoreTelephony/CTTelephonyNetworkInfo.h>

@implementation PeoplePickerDelegate

- (void)callPhoneNumber:(NSString *)phoneNumber {
    if (!phoneNumber) return;
    NSString *phoneURLString = [NSString stringWithFormat:@"telprompt:%@", phoneNumber];
    NSURL *phoneURL = [NSURL URLWithString:phoneURLString];
    [[UIApplication sharedApplication] openURL:phoneURL];
}

- (NSString *)getPhoneNumberWithPerson:(ABRecordRef)person property:(ABPropertyID)property identifier:(ABMultiValueIdentifier)identifier {
    if (property == kABPersonPhoneProperty) {
        ABMultiValueRef numbers = ABRecordCopyValue(person, property);
        NSString* targetNumber = (__bridge NSString *) ABMultiValueCopyValueAtIndex(numbers, ABMultiValueGetIndexForIdentifier(numbers, identifier));
        return targetNumber;
    }
    return nil;
}

- (NSString *)voiceSMSPhoneNumberFromPhoneNumber:(NSString *)phoneNumber {
    if (!phoneNumber) return nil;
    NSString *prefix = [self voiceSMSPrefix];
    if (!prefix) return nil;
    NSString *standardizedNumber = [self standardizeNumber:phoneNumber];
    if (!standardizedNumber) return nil;
    return [prefix stringByAppendingString:standardizedNumber];
}

- (NSString *)voiceSMSPrefix {
    CTTelephonyNetworkInfo *networkInfo = [[CTTelephonyNetworkInfo alloc] init];
    CTCarrier *carrier = [networkInfo subscriberCellularProvider];
    NSString *mcc = [carrier mobileCountryCode];
    NSString *mnc = [carrier mobileNetworkCode];
    if ([@"452" isEqualToString:mcc]) {
        if ([@"01" isEqualToString:mnc]) return @"9302";
        if ([@"02" isEqualToString:mnc]) return @"945";
        if ([@"04" isEqualToString:mnc]) return @"1354";
    }
    return nil;
}

- (NSString *)standardizeNumber:(NSString *)phoneNumber {
    if ([@"+" isEqualToString:[phoneNumber substringToIndex:1]]) {
        if (phoneNumber.length < 4) return nil;
        NSString *first3Chars = [phoneNumber substringToIndex:3];
        if ([@"+84" isEqualToString:first3Chars]) phoneNumber = [@"0" stringByAppendingString:[phoneNumber substringFromIndex:3]];
        else return nil;
    } else {
        NSCharacterSet *set = [NSCharacterSet characterSetWithCharactersInString:@"*#,;"];
        if ([phoneNumber rangeOfCharacterFromSet:set].location != NSNotFound) return nil;
    }
    NSString *standardizedNumber = [[phoneNumber componentsSeparatedByCharactersInSet:[[NSCharacterSet decimalDigitCharacterSet] invertedSet]] componentsJoinedByString:@""];
    return standardizedNumber;
}

#pragma UINavigationControllerDelegate methods
- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    if ([navigationController.viewControllers indexOfObject:viewController] <= 1) {
        viewController.navigationItem.rightBarButtonItem = nil;
    }
}

#pragma ABPeoplePickerNavigationControllerDelegate methods
- (BOOL)peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker shouldContinueAfterSelectingPerson:(ABRecordRef)person {
    return YES;
}

- (BOOL)peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker shouldContinueAfterSelectingPerson:(ABRecordRef)person property:(ABPropertyID)property identifier:(ABMultiValueIdentifier)identifier {
    NSString *originalPhoneNumber = [self getPhoneNumberWithPerson:person property:property identifier:identifier];
    NSString *phoneNumber = [self voiceSMSPhoneNumberFromPhoneNumber:originalPhoneNumber];
    [self callPhoneNumber:phoneNumber];
    return NO;
}

- (void)peoplePickerNavigationControllerDidCancel:(ABPeoplePickerNavigationController *)peoplePicker {}

@end
