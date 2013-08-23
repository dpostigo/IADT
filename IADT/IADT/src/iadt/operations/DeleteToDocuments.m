//
// Created by dpostigo on 12/20/12.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "DeleteToDocuments.h"

@implementation DeleteToDocuments {
}

- (void) main {
    [super main];

    if (_model.collectsUserData) {
        _model.dataString = [_model.dataString stringByReplacingOccurrencesOfString: _model.lastEntry withString: @""];
        [self saveFile];
    }
}

@end