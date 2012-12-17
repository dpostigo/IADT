//
// Created by dpostigo on 12/17/12.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "GameIntroView.h"


@implementation GameIntroView {
}


@synthesize textLabel;
@synthesize detailTextLabel;


- (IBAction) fadeAndRemove: (id) sender {

    [UIView animateWithDuration: 0.3 delay: 0.0 options: UIViewAnimationOptionCurveEaseOut animations: ^{

    self.alpha = 0;

        } completion:  ^(BOOL completion) {

        [self removeFromSuperview];
    }];
}

@end