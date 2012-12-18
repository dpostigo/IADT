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
    }                completion: ^(BOOL completion) {

        [self removeFromSuperview];
    }];
}


- (void) layoutSubviews {
    [super layoutSubviews];

    NSLog(@"%s", __PRETTY_FUNCTION__);

    [textLabel sizeToFit];
    textLabel.centerX = textLabel.superview.width/2;

    textLabel.textAlignment = NSTextAlignmentCenter;
    textLabel.bottom = detailTextLabel.top - 10;

}

@end