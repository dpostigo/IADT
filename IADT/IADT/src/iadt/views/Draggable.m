//
// Created by dpostigo on 12/18/12.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "Draggable.h"


@implementation Draggable {
}


@synthesize droppable;
@synthesize droppables;
@synthesize startingPoint;
@synthesize delegate;
@synthesize shouldFade;


- (id) initWithFrame: (CGRect) frame {
    self = [super initWithFrame: frame];
    if (self) {
        shouldFade = YES;
    }

    return self;
}


- (void) setFrame: (CGRect) frame {
    [super setFrame: frame];
    startingPoint = frame.origin;
}


- (void) touchesBegan: (NSSet *) touches withEvent: (UIEvent *) event {
    [super touchesBegan: touches withEvent: event];

    [UIView animateWithDuration: 0.2 delay: 0.0 options: UIViewAnimationOptionCurveEaseInOut animations: ^{
        self.transform = CGAffineTransformScale(self.transform, 1.15, 1.15);
    }                completion: ^(BOOL completion) {
    }];
}


- (void) touchesEnded: (NSSet *) touches withEvent: (UIEvent *) event {
    [super touchesEnded: touches withEvent: event];

    BOOL wasDropped = NO;
    if (droppable != nil) {
        wasDropped = CGRectIntersectsRect(droppable.frame, self.frame);
    } else if (droppables != nil && [droppables count] > 0) {
        for (UIView *aDroppable in droppables) {
            wasDropped = CGRectIntersectsRect(aDroppable.frame, self.frame);
            if (wasDropped)
                break;
        }
    }

    if (wasDropped) [self draggableWasDropped];
    else [self draggableWasNotDropped];
}


- (void) draggableWasDropped {

    [UIView animateWithDuration: 0.25 delay: 0.0 options: UIViewAnimationOptionCurveEaseInOut animations: ^{
        self.transform = CGAffineTransformIdentity;
        self.alpha = !shouldFade;
    }                completion: ^(BOOL completion) {
    }];

    if ([delegate respondsToSelector: @selector(draggableDidDrop:)]) {
        [delegate performSelector: @selector(draggableDidDrop:) withObject: self];
    }
}


- (void) draggableWasNotDropped {
    [self reset];
}


- (void) reset {
    [UIView animateWithDuration: 0.25 delay: 0.0 options: UIViewAnimationOptionCurveEaseInOut animations: ^{
        self.transform = CGAffineTransformIdentity;
        self.origin = startingPoint;
    }                completion: ^(BOOL completion) {
    }];
}

@end