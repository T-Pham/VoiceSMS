//
//  PeoplePickerDelegate.m
//  VoiceSMS
//
//  Created by eastagile 87:21 on 8/1/13.
//  Copyright (c) 2013 eastagile. All rights reserved.
//

#import "PeoplePickerDelegate.h"

@implementation PeoplePickerDelegate

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
    return NO;
}

- (void)peoplePickerNavigationControllerDidCancel:(ABPeoplePickerNavigationController *)peoplePicker {}

@end
