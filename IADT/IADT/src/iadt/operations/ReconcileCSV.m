//
// Created by dpostigo on 1/11/13.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "ReconcileCSV.h"
#import "NSString+Utils.h"


@implementation ReconcileCSV {
}


- (void) main {
    [super main];

    if ([_model.dataString containsString: @"Name,Email,Zip Code,Result,Date,Phone"]) {
        NSLog(@"Replacing incompatible CSV.");
        _model.dataString = @"";
    }

    [self saveFile];
}

@end