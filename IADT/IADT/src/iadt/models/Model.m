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
    NSMutableDictionary *_sessionDictionary;
    NSMutableDictionary *_pointScores;
    NSString *_badgeName;
    NSMutableDictionary *_itemScores;
}


@synthesize gamesData = _gamesData;
@synthesize dataString = _dataString;
@synthesize scores = _scores;
@synthesize scoreData = _scoreData;
@synthesize lastEntry = _lastEntry;
@synthesize sessionDictionary = _sessionDictionary;
@synthesize pointScores = _pointScores;
@synthesize badgeName = _badgeName;
@synthesize itemScores = _itemScores;


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
        self.scores = [[NSMutableDictionary alloc] init];
        self.pointScores = [[NSMutableDictionary alloc] init];
        self.itemScores = [[NSMutableDictionary alloc] init];

        _dataString = [[NSUserDefaults standardUserDefaults] objectForKey: @"dataString"];



    }

    return self;
}

@end