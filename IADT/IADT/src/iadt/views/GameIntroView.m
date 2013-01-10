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
@synthesize delegate;


- (IBAction) fadeAndRemove: (id) sender {

    if ([delegate respondsToSelector: @selector(gameIntroViewWillDismiss:)]) {
        [delegate performSelector: @selector(gameIntroViewWillDismiss:) withObject: self];
    }


    [UIView animateWithDuration: 0.3 delay: 0.0 options: UIViewAnimationOptionCurveEaseOut animations: ^{

        self.alpha = 0;
    }                completion: ^(BOOL completion) {

        [self removeFromSuperview];
        if ([delegate respondsToSelector: @selector(gameIntroViewDismissed:)]) {
            [delegate performSelector: @selector(gameIntroViewDismissed:) withObject: self];
        }
    }];
}


- (void) show: (UIView *) onView {
    self.alpha = 0;
    [onView addSubview: self];
    [UIView animateWithDuration: 0.3 delay: 0.0 options: UIViewAnimationOptionCurveEaseOut animations: ^{

        self.alpha = 1;
    }                completion: ^(BOOL completion) {

//        [self removeFromSuperview];
    }];
}


- (void) layoutSubviews {
    [super layoutSubviews];

    [textLabel sizeToFit];
    textLabel.centerX = textLabel.superview.width / 2;

    textLabel.textAlignment = NSTextAlignmentCenter;
    textLabel.bottom = detailTextLabel.top - 10;
}

@end