//
// Created by dpostigo on 1/15/13.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>


@interface DebugLog : UIView {
    UILabel *textLabel;
}


@property(nonatomic, strong) UILabel *textLabel;
+ (DebugLog *) sharedLog;

@end