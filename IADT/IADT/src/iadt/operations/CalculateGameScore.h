//
// Created by dpostigo on 1/15/13.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>
#import "BasicOperation.h"


@interface CalculateGameScore : BasicOperation {
    NSString *restorationIdentifier;
    NSArray *validTags;

}


@property(nonatomic, strong) NSString *restorationIdentifier;
@property(nonatomic, strong) NSArray *validTags;

- (id) initWithRestorationIdentifier: (NSString *) aRestorationIdentifier validTags: (NSArray *) aValidTags;

@end