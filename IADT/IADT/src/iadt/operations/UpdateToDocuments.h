//
// Created by dpostigo on 12/19/12.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>
#import "BasicOperation.h"
#import "BasicCSVOperation.h"


@interface UpdateToDocuments : BasicCSVOperation {
    NSString *result;

}


@property(nonatomic, retain) NSString *result;
- (id) initWithResult: (NSString *) aResult;

@end