//
// Created by dpostigo on 9/20/12.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "Model.h"


@implementation Model {
@private
    NSDictionary *_gamesData;
    NSString *_dataString;
    NSMutableDictionary *_scores;
    NSDictionary *_scoreData;
}


@synthesize gamesData = _gamesData;
@synthesize dataString = _dataString;
@synthesize scores = _scores;
@synthesize scoreData = _scoreData;


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

        NSString *path = [[NSBundle mainBundle] pathForResource: @"data" ofType: @"plist"];
        NSArray *array = [NSArray arrayWithContentsOfFile: path];
        NSDictionary *dictionary = [array objectAtIndex: 0];

        self.gamesData = dictionary;
        self.scoreData = [array objectAtIndex: 1];

        _dataString = [[NSUserDefaults standardUserDefaults] objectForKey: @"dataString"];
        NSLog(@"_dataString = %@", _dataString);



    }

    return self;
}

@end