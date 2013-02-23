//
// Created by dpostigo on 12/17/12.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "LoginViewController.h"
#import "SaveToDocuments.h"
#import "NSString+Utils.h"
#import "UIColor+Utils.h"


@implementation LoginViewController {
    NSMutableArray *invalidMarks;
}


- (void) viewDidLoad {
    [super viewDidLoad];

    invalidMarks = [[NSMutableArray alloc] init];

    [self subscribeTextField: name];
    [self subscribeTextField: lastName];
    [self subscribeTextField: email];
    [self subscribeTextField: phone];
    [self subscribeTextField: zip];

    email.mode = TextFieldModeEmail;
    phone.mode = TextFieldModePhone;
    zip.mode = TextFieldModeZip;

    phone.isNumeric = YES;
    phone.characterLimit = 11;
    zip.isNumeric = YES;
    zip.characterLimit = 5;

    if (!DEBUG) {
        submitButton.userInteractionEnabled = NO;
        submitButton.alpha = 0.2;
    }

    for (TextField *textfield in textFields) {
        UIView *view = [[UIView alloc] initWithFrame: textfield.superview.frame];
        view.autoresizingMask = textfield.superview.autoresizingMask;
        view.width += 2;
        view.height += 4;
        if (textfield == lastName) {
            view.left += 1;
        }
        view.backgroundColor = [UIColor colorWithRed: 1.0 green: 0.0 blue: 0.0 alpha: 0.1];
        view.alpha = 0;
        textfield.invalidView = view;
        view.userInteractionEnabled = NO;
        [self.view addSubview: view];


    }
}


- (IBAction) handleSubmit: (id) sender {

    BOOL isValid = [self isValid];

    if (isValid || DEBUG) {
        NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
        [dict setObject: name.text forKey: @"First Name"];
        [dict setObject: lastName.text forKey: @"Last Name"];
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

    BOOL isValid = self.isValid;
    submitButton.userInteractionEnabled = isValid;
    submitButton.alpha = isValid ? 1: 0.2;
    [self checkTextField: aTextField];
}


- (void) textFieldDidChange: (UITextField *) aTextField {
    [super textFieldDidChange: aTextField];

    TextField *textfield = (TextField *) aTextField;
    if (textfield.invalidView.alpha == 1) {
        [self checkTextField: textfield];
    }
}

- (void) checkTextField: (TextField *) textfield {
    [UIView animateWithDuration: 0.15 delay: 0 options: UIViewAnimationOptionCurveEaseOut animations: ^{
        textfield.invalidView.alpha = !textfield.isValid;
        if (textfield.isValid) {
            textfield.superview.backgroundColor = [UIColor colorWithString: @"f4f4f4"];
        } else {
            textfield.superview.backgroundColor = [UIColor colorWithString: @"f4f4f4"];

        }
    }                completion: nil];

}


- (BOOL) isValid {
    NSArray *invalidFields = self.invalidFields;
    return ([invalidFields count] == 0);

}


- (NSArray *) invalidFields {

    NSMutableArray *invalid = [[NSMutableArray alloc] init];
    for (TextField *aTextField in textFields) {
        if (!aTextField.isValid) {
            [invalid addObject: aTextField];
        }
    }
    return invalid;
}

@end