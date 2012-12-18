//
// Created by dpostigo on 12/17/12.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>
#import "BasicViewController.h"
#import "TextField.h"


@interface LoginViewController : BasicViewController {
    IBOutlet UITextField *name;
    IBOutlet UITextField *email;
    IBOutlet TextField *phone;
    IBOutlet TextField *zip;

    IBOutlet UIButton *submitButton;
}


@end