//
// Created by dpostigo on 12/17/12.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "LoginViewController.h"


@implementation LoginViewController {
}


- (void) viewDidLoad {
    [super viewDidLoad];

    [self subscribeTextField: name];
    [self subscribeTextField: email];
    [self subscribeTextField: phone];
    [self subscribeTextField: zip];
}

@end