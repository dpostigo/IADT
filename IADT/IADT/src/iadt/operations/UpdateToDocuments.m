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

    [_model.sessionDictionary setObject: result forKey: @"Result"];


    NSString *string = [[_model.sessionDictionary allValues] componentsJoinedByString: @", "];
    _model.dataString = [_model.dataString stringByReplacingOccurrencesOfString: _model.lastEntry withString: string];

    [self saveFile];


}

@end