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
+ (Model *) sharedModel;


@end