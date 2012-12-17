//
// Created by dpostigo on 9/20/12.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "Model.h"


@implementation Model {
@private
    NSDictionary *_gamesData;
}


@synthesize gamesData = _gamesData;


+ (Model *) sharedModel {
    static Model *_instance = nil;

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

        NSLog(@"%s", __PRETTY_FUNCTION__);



        NSString *path = [[NSBundle mainBundle] pathForResource: @"data" ofType: @"plist"];
        NSArray *array = [NSArray arrayWithContentsOfFile: path];
        NSDictionary *dictionary = [array objectAtIndex: 0];
        NSLog(@"dictionary = %@", dictionary);

        self.gamesData = dictionary;
    }

    return self;
}

@end