//
// Created by dpostigo on 1/15/13.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "LogValidItem.h"


@implementation LogValidItem {
}


@synthesize validTags;
@synthesize restorationIdentifier;


- (id) initWithValidTags: (NSArray *) aValidTags restorationIdentifier: (NSString *) aRestorationIdentifier {
    self = [super init];
    if (self) {
        validTags = aValidTags;
        restorationIdentifier = aRestorationIdentifier;
    }

    return self;
}


- (void) main {
    [super main];
    NSArray *items = [[_model.scoreData objectForKey: self.restorationIdentifier] objectForKey: @"Items"];


    if ([validTags count] > 0) {
        NSInteger tag = [[validTags objectAtIndex: 0] integerValue];
        NSString *string = [items objectAtIndex: tag - 1];
        string = [string stringByReplacingOccurrencesOfString: @"-icon.png" withString: @""];
        string = [string capitalizedString];
        NSLog(@"VALID ITEM: %@ (%i)", string, tag);
    }
}

@end