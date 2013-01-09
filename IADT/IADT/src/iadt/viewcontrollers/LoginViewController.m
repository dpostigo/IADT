//
// Created by dpostigo on 12/17/12.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "LoginViewController.h"
#import "SaveToDocuments.h"
#import "NSString+Utils.h"


@implementation LoginViewController {
}


- (void) viewDidLoad {
    [super viewDidLoad];

    [self subscribeTextField: name];
    [self subscribeTextField: email];
    [self subscribeTextField: phone];
    [self subscribeTextField: zip];

    phone.isNumeric = YES;
    phone.characterLimit = 11;
    zip.isNumeric = YES;
    zip.characterLimit = 5;


    if (!DEBUG) {
        submitButton.userInteractionEnabled = NO;
        submitButton.alpha = 0.2;

    }
}


- (IBAction) handleSubmit: (id) sender {

    BOOL isValid = [self isValid];

    if (isValid || DEBUG) {

        NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
        [dict setObject: name.text forKey: @"Name"];
        [dict setObject: email.text forKey: @"Email"];
        [dict setObject: phone.text forKey: @"Phone"];
        [dict setObject: zip.text forKey: @"Zip Code"];
        [dict setObject: [NSDate date] forKey: @"Date"];
        [dict setObject: @"" forKey: @"Result"];


        _model.sessionDictionary = dict;
        [_queue addOperation: [[SaveToDocuments alloc] initWithDictionary: dict]];
        [self performSegueWithIdentifier: @"LoginSegue" sender: self];
    }
}


- (void) textFieldEndedEditing: (UITextField *) aTextField {
    [super textFieldEndedEditing: aTextField];
    NSLog(@"%s", __PRETTY_FUNCTION__);
    BOOL isValid = [self isValid];

    submitButton.userInteractionEnabled = isValid;
    submitButton.alpha = isValid ? 1: 0.2;
}


- (BOOL) isValid {

    for (TextField *aTextField in textFields) {

        NSString *string = [aTextField.text trimWhitespace];
        if ([string isEqualToString: @""]) {
            return NO;
        }

        if (aTextField == email) {
            if (![string containsString: @"@"] || ![string containsString: @"."]) {
                return NO;
            }
        }

    }

    return YES;
}

@end