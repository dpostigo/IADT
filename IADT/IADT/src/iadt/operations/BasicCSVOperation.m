//
// Created by dpostigo on 12/20/12.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "BasicCSVOperation.h"


@implementation BasicCSVOperation {
}


- (void) saveFile {


    [[NSUserDefaults standardUserDefaults] setObject: _model.dataString forKey: @"dataString"];

    NSString *path = [_model.userDocumentsPath stringByAppendingString: @"/data.csv"];
    NSData *data = [_model.dataString dataUsingEncoding: NSUTF8StringEncoding];
    [data writeToFile: path atomically: YES];
}

@end