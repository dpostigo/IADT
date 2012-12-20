//
// Created by dpostigo on 12/19/12.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "UpdateToDocuments.h"


@implementation UpdateToDocuments {
}


@synthesize result;


- (id) initWithResult: (NSString *) aResult {
    self = [super init];
    if (self) {
        result = aResult;
    }

    return self;
}


- (void) main {
    [super main];

    NSString *string = [NSString stringWithFormat: @"%@%@", _model.lastEntry, result];
    _model.dataString = [_model.dataString stringByReplacingOccurrencesOfString: _model.lastEntry withString: string];

    NSString *path = [_model.userDocumentsPath stringByAppendingString: @"/data.csv"];
    [[NSUserDefaults standardUserDefaults] setObject: _model.dataString forKey: @"dataString"];
    NSData *data = [_model.dataString dataUsingEncoding: NSUTF8StringEncoding];
    [data writeToFile: path atomically: YES];


}

@end