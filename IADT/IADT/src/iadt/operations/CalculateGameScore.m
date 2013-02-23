//
// Created by dpostigo on 1/15/13.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "CalculateGameScore.h"


@implementation CalculateGameScore {
}


@synthesize restorationIdentifier;
@synthesize validTags;


- (id) initWithRestorationIdentifier: (NSString *) aRestorationIdentifier validTags: (NSArray *) aValidTags {
    self = [super init];
    if (self) {
        restorationIdentifier = aRestorationIdentifier;
        validTags = aValidTags;
    }

    return self;
}


- (void) main {
    [super main];
}

@end