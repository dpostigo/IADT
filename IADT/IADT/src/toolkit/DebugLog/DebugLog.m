//
// Created by dpostigo on 1/15/13.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "DebugLog.h"


@implementation DebugLog {
}


@synthesize textLabel;


+ (DebugLog *) sharedLog {
    static DebugLog *_instance = nil;

    @synchronized (self) {
        if (_instance == nil) {
            _instance = [[self alloc] init];
        }
    }

    return _instance;
}


- (id) init {
    self = [super init];
    if (self) {


        self.backgroundColor = [UIColor whiteColor];

        self.textLabel = [[UILabel alloc] initWithFrame: self.bounds];
        textLabel.width = self.width - 20;
        textLabel.height = self.height - 20;
        textLabel.center = self.center;
        textLabel.text = @"Hello";
        [self addSubview: textLabel];
        textLabel.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleWidth;
    }

    return self;
}

@end