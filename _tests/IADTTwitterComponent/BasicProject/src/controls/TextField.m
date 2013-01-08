//
// Created by dpostigo on 12/4/12.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "TextField.h"
#import "TextFieldDelegate.h"

@implementation TextField {
}

@synthesize dismissKeyboardOnReturn;
@synthesize delegateManager;

- (id) initWithCoder: (NSCoder *) aDecoder {
    self = [super initWithCoder: aDecoder];
    if (self) {

        self.delegateManager = [[TextFieldDelegate alloc] init];
        self.dismissKeyboardOnReturn = YES;
//        self.delegate =  delegateManager;



    }

    return self;
}


- (void) touchedUpOutside {
    NSLog(@"%s", __PRETTY_FUNCTION__);
}

@end