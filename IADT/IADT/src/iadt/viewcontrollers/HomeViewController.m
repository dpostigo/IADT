//
// Created by Dani Postigo on 8/12/13.
// Copyright (c) 2013 Daniela Postigo. All rights reserved.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "HomeViewController.h"
#import "Model.h"

@implementation HomeViewController {

}

- (IBAction) handleStartButton: (id) sender {
    NSLog(@"_model.collectsUserData = %d", _model.collectsUserData);
    if (_model.collectsUserData) {
        [self performSegueWithIdentifier: @"UserDataSegue" sender: self];
    }
    else [self performSegueWithIdentifier: @"StartSegue" sender: self];

}
@end