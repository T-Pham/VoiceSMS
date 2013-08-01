//
//  PeoplePickerDelegate.m
//  VoiceSMS
//
//  Created by eastagile 87:21 on 8/1/13.
//  Copyright (c) 2013 eastagile. All rights reserved.
//

#import "PeoplePickerDelegate.h"

@implementation PeoplePickerDelegate

- (void)callPhoneNumber:(NSString *)phoneNumber {
    NSString *phoneURLString = [NSString stringWithFormat:@"tel:%@", phoneNumber];
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
    return phoneNumber;
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
