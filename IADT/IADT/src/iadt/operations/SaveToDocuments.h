//
// Created by dpostigo on 12/18/12.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>
#import "BasicOperation.h"
#import "BasicCSVOperation.h"


@interface SaveToDocuments : BasicCSVOperation {

    NSDictionary *dictionary;
}


@property(nonatomic, strong) NSDictionary *dictionary;
- (id) initWithDictionary: (NSDictionary *) aDictionary;

@end