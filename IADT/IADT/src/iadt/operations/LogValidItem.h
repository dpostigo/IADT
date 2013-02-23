//
// Created by dpostigo on 1/15/13.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>
#import "BasicOperation.h"


@interface LogValidItem : BasicOperation {

    NSArray *validTags;
    NSString *restorationIdentifier;
}


@property(nonatomic, strong) NSArray *validTags;
@property(nonatomic, strong) NSString *restorationIdentifier;

- (id) initWithValidTags: (NSArray *) aValidTags restorationIdentifier: (NSString *) aRestorationIdentifier;

@end