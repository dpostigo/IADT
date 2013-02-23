//
// Created by dpostigo on 9/20/12.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>
#import "BasicModel.h"

@interface Model : BasicModel  {


}


@property(nonatomic, strong) NSDictionary *gamesData;
@property(nonatomic, retain) NSString *dataString;
@property(nonatomic, strong) NSMutableDictionary *scores;
@property(nonatomic, strong) NSDictionary *scoreData;
@property(nonatomic, retain) NSString *lastEntry;
@property(nonatomic, strong) NSMutableDictionary *sessionDictionary;
@property(nonatomic, strong) NSMutableDictionary *pointScores;
@property(nonatomic, retain) NSString *badgeName;
@property(nonatomic, strong) NSMutableDictionary *itemScores;
+ (Model *) sharedModel;


@end