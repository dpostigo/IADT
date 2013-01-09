//
// Created by dpostigo on 12/18/12.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <QuartzCore/QuartzCore.h>
#import "Draggable.h"


@implementation Draggable {
    UIView *circleMask;
    NSMutableArray *usedDroppables;
}


@synthesize droppable;
@synthesize droppables;
@synthesize startingPoint;
@synthesize delegate;
@synthesize shouldFade;
@synthesize snapsToContainer;
@synthesize circleRadius;
@synthesize maskEnabled;
@synthesize itemLimit;
@synthesize droppingDisabled;
@synthesize shouldHover;
@synthesize currentDrop;
@synthesize reverseScale;
@synthesize draggingMode;

#define DRAG_DEBUG 0
#define REVERSE_SCALE_DEBUG 1
#define DRAGMODE_DEBUG 0

- (BOOL) isPlaced {
    return (currentDrop != nil);
}


- (id) initWithFrame: (CGRect) frame {
    self = [super initWithFrame: frame];
    if (self) {
        shouldFade = YES;

        circleMask = [[UIView alloc] initWithFrame: self.bounds];
        circleMask.backgroundColor = [UIColor clearColor];

        if (DRAG_DEBUG) {
            circleMask.backgroundColor = [UIColor blueColor];
        }
        [self addSubview: circleMask];

        usedDroppables = [[NSMutableArray alloc] init];
        itemCount = 0;
    }

    return self;
}


- (void) setFrame: (CGRect) frame {
    [super setFrame: frame];
    startingPoint = frame.origin;
}


- (void) setCircleRadius: (CGFloat) circleRadius1 {
    circleRadius = circleRadius1;

    circleMask.width = circleRadius * 2;
    circleMask.height = circleRadius * 2;
    circleMask.layer.cornerRadius = circleRadius;
    circleMask.center = CGPointMake(self.width / 2, self.height / 2);
}


- (BOOL) pointInside: (CGPoint) point withEvent: (UIEvent *) event {
    if (maskEnabled) {
        return CGRectContainsPoint(circleMask.frame, point);
    }
    return [super pointInside: point withEvent: event];
}


- (void) touchesBegan: (NSSet *) touches withEvent: (UIEvent *) event {
    [super touchesBegan: touches withEvent: event];

    if (DRAG_DEBUG) {
        [self addSubview: circleMask];
    }

    if (currentDrop != nil) {
        currentDrop.userInteractionEnabled = YES;
        currentDrop = nil;
    }

    [UIView animateWithDuration: 0.15 delay: 0.0 options: UIViewAnimationOptionCurveEaseInOut animations: ^{

        if (REVERSE_SCALE_DEBUG) {
            if (reverseScale) {
                self.transform = CGAffineTransformIdentity;
            } else {

                self.transform = CGAffineTransformScale(self.transform, 1.15, 1.15);
            }
        }

        else {
            self.transform = CGAffineTransformScale(self.transform, 1.15, 1.15);
        }
    }                completion: ^(BOOL completion) {
    }];

    [self draggableBeganDrop];
}


- (void) touchesMoved: (NSSet *) touches withEvent: (UIEvent *) event {
    [super touchesMoved: touches withEvent: event];

    [self showIntersects];

    if (shouldHover) {
    }
}


- (void) touchesEnded: (NSSet *) touches withEvent: (UIEvent *) event {
    [super touchesEnded: touches withEvent: event];

    BOOL wasDropped = [self calculateWasDropped];

    if (wasDropped) {
        UIView *dropContainer = [self getDropContainer];
        [self draggableWasDropped: dropContainer];
    }

    else [self draggableWasNotDropped];
}


- (BOOL) calculateWasDropped {
    if (droppingDisabled) return NO;

    if (droppable != nil) {
        return [self evalWasDropped: droppable];
    }

    BOOL wasDropped = NO;

    if (droppables != nil && [droppables count] > 0) {
        for (UIView *aDroppable in droppables) {

            wasDropped = [self evalWasDropped: aDroppable];

            if (aDroppable.userInteractionEnabled == NO) {
                wasDropped = NO;
            }

            if (wasDropped) {
                break;
            }
        }
    }

    return wasDropped;
}


- (BOOL) evalWasDropped: (UIView *) aDroppable {
    CGRect frame = CGRectMake(self.origin.x + circleMask.origin.x, self.origin.y + circleMask.origin.y, circleMask.size.width, circleMask.size.height);

    if (DRAGMODE_DEBUG) {
        return (draggingMode == DraggingModeContains ? CGRectContainsRect(aDroppable.frame, frame): CGRectIntersectsRect(aDroppable.frame, frame));
    }
    else {
        return CGRectIntersectsRect(aDroppable.frame, frame);
    }
}


- (void) showIntersects {

    if (DRAG_DEBUG) {
        if (droppable != nil) {
            BOOL contains = [self evalWasDropped: droppable];
            if (contains) {
                droppable.backgroundColor = [UIColor grayColor];
            }

            else {
                droppable.backgroundColor = [UIColor clearColor];
            }
        }

        if (droppables != nil && [droppables count] > 0) {
            for (UIView *aDroppable in droppables) {
                BOOL contains = [self evalWasDropped: aDroppable];

                if (contains) {
                    aDroppable.backgroundColor = [UIColor grayColor];
                }

                else {
                    aDroppable.backgroundColor = [UIColor clearColor];
                }
            }
        }
    }
}


- (UIView *) getDropContainer {
    if (droppable != nil) return droppable;

    UIView *dropContainer = nil;
    for (UIView *aDroppable in droppables) {

        BOOL contains = [self evalWasDropped: aDroppable];

        if (contains) {
            dropContainer = aDroppable;
            dropContainer.userInteractionEnabled = NO;
            break;
        }
    }
    return dropContainer;
}


- (void) draggableBeganDrop {
    if ([delegate respondsToSelector: @selector(draggableBeganDrop:)]) {
        [delegate performSelector: @selector(draggableBeganDrop:) withObject: self];
    }
}


- (void) draggableWasDropped: (UIView *) dropContainer {

    currentDrop = dropContainer;
    itemCount += 1;

    [UIView animateWithDuration: 0.25 delay: 0.0 options: UIViewAnimationOptionCurveEaseInOut animations: ^{

        self.transform = CGAffineTransformIdentity;
        self.alpha = !shouldFade;

        if (snapsToContainer) {
            self.centerX = dropContainer.centerX;
            self.centerY = dropContainer.centerY;
        }
    }                completion: ^(BOOL completion) {
    }];

    if ([delegate respondsToSelector: @selector(draggableDidDrop:)]) {
        [delegate performSelector: @selector(draggableDidDrop:) withObject: self];
    }
}


- (void) draggableWasNotDropped {

    [self resetPosition];

    if ([delegate respondsToSelector: @selector(draggableDidNotDrop:)]) {
        [delegate performSelector: @selector(draggableDidNotDrop:) withObject: self];
    }
}


- (void) reset {

    self.droppingDisabled = NO;
    [self resetPosition];
}


- (void) resetPosition {
    [UIView animateWithDuration: 0.25 delay: 0.0 options: UIViewAnimationOptionCurveEaseInOut animations: ^{

        if (REVERSE_SCALE_DEBUG) {

            if (reverseScale) {
                if (CGAffineTransformEqualToTransform(self.transform, CGAffineTransformIdentity)) {
                    self.transform = CGAffineTransformScale(self.transform, 1.15, 1.15);
                }
            } else {
                self.transform = CGAffineTransformIdentity;
            }
        }

        else {
            self.transform = CGAffineTransformIdentity;
        }
        self.origin = startingPoint;
        self.alpha = 1;
    }                completion: ^(BOOL completion) {
    }];
}

@end