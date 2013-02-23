//
// Created by dpostigo on 12/18/12.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "SaveToDocuments.h"


@implementation SaveToDocuments {
}


@synthesize dictionary;


- (id) initWithDictionary: (NSDictionary *) aDictionary {
    self = [super init];
    if (self) {
        dictionary = aDictionary;
    }

    return self;
}


- (void) main {
    [super main];

    if (dictionary == nil) return;
    NSString *string = [self composeFile: dictionary];

    _model.dataString = string;

    [self saveFile];

}




- (NSString *) composeFile: (NSDictionary *) dict {

    NSString *valueString = [[dict allValues] componentsJoinedByString: @","];
    NSArray *array = nil;

    if (_model.dataString == nil || [_model.dataString isEqualToString: @""]) {
        NSString *keyString = [[dict allKeys] componentsJoinedByString: @","];
        array = [NSArray arrayWithObjects: keyString, valueString, nil];
    } else {

        array = [NSArray arrayWithObjects: _model.dataString, valueString, nil];
    }

    NSString *string = [array componentsJoinedByString: @"\n"];
    _model.lastEntry = valueString;

    return string;
}

@end