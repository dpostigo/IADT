//
// Created by dpostigo on 12/18/12.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <QuartzCore/QuartzCore.h>
#import "Draggable.h"


@implementation Draggable {
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
@synthesize associatedLabel;
@synthesize maskType;
@synthesize maskView;

#define DRAG_DEBUG 0
#define REVERSE_SCALE_DEBUG 1
#define DRAGMODE_ENABLED 1

- (BOOL) isPlaced {
    return (currentDrop != nil);
}


- (id) initWithFrame: (CGRect) frame {
    self = [super initWithFrame: frame];
    if (self) {
        shouldFade = YES;

        maskView = [[UIView alloc] initWithFrame: self.bounds];
        maskView.backgroundColor = [UIColor clearColor];

        if (DRAG_DEBUG) {
            maskView.backgroundColor = [UIColor blueColor];
        }
        [self addSubview: maskView];

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
    [self layout];
}


- (void) layout {

    switch (maskType) {

        case DraggableMaskTypeCustom :
            break;

        case DraggableMaskTypeCustomCentered :
            maskView.center = CGPointMake(self.width / 2, self.height / 2);
            break;

        case DraggableMaskTypeCircle :
        default:
            maskView.width = circleRadius * 2;
            maskView.height = circleRadius * 2;
            maskView.layer.cornerRadius = circleRadius;
            maskView.center = CGPointMake(self.width / 2, self.height / 2);
            break;
    }
}


- (BOOL) pointInside: (CGPoint) point withEvent: (UIEvent *) event {
    if (maskEnabled) {
        return CGRectContainsPoint(maskView.frame, point);
    }
    return [super pointInside: point withEvent: event];
}


- (void) touchesBegan: (NSSet *) touches withEvent: (UIEvent *) event {
    [super touchesBegan: touches withEvent: event];

    if (DRAG_DEBUG) {
        [self addSubview: maskView];
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

    [self draggableBeganDragging];
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

    else{
        [self draggableWasNotDropped];
        [self draggableDidFinishDragging];
    }

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
    CGRect frame = CGRectMake(self.origin.x + maskView.origin.x, self.origin.y + maskView.origin.y, maskView.size.width, maskView.size.height);

    if (DRAGMODE_ENABLED) {
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


- (void) draggableBeganDragging {

    if (associatedLabel != nil) {
        [UIView animateWithDuration: 0.25 delay: 0.0 options: UIViewAnimationOptionCurveEaseInOut animations: ^{
            associatedLabel.alpha = GHOST_IMAGE_ALPHA;
        }                completion: nil];
    }

    if ([delegate respondsToSelector: @selector(draggableBeganDragging:)]) {
        [delegate performSelector: @selector(draggableBeganDragging:) withObject: self];
    }
}

- (void) draggableDidFinishDragging {
    if ([delegate respondsToSelector: @selector(draggableDidFinishDragging:)]) {
        [delegate performSelector: @selector(draggableDidFinishDragging:) withObject: self];
    }
}


- (void) draggableWasDropped: (UIView *) dropContainer {

    currentDrop = dropContainer;
    itemCount += 1;



    if ([delegate respondsToSelector: @selector(draggableWillDrop:)]) {
        [delegate performSelector: @selector(draggableWillDrop:) withObject: self];
    }


    [UIView animateWithDuration: 0.25 delay: 0.0 options: UIViewAnimationOptionCurveEaseInOut animations: ^{

        self.transform = CGAffineTransformIdentity;
        self.alpha = !shouldFade;

        if (snapsToContainer) {
            self.centerX = dropContainer.centerX;
            self.centerY = dropContainer.centerY;
        }
    }                completion: ^(BOOL completion) {


        if ([delegate respondsToSelector: @selector(draggableDidFinishDrop:)]) {
            [delegate performSelector: @selector(draggableDidFinishDrop:) withObject: self];
        }


        [self draggableDidFinishDragging];

    }];



}


- (void) draggableWasNotDropped {

    [self resetPosition: YES];
    [self resetLabel];

    if ([delegate respondsToSelector: @selector(draggableDidNotDrop:)]) {
        [delegate performSelector: @selector(draggableDidNotDrop:) withObject: self];
    }
}


- (void) reset {
    [self reset: YES];
}


- (void) reset: (BOOL) animated {
    for (UIView *aDroppable in self.droppables) {
        aDroppable.userInteractionEnabled = YES;
    }

    self.droppingDisabled = NO;
    currentDrop = nil;
    [self resetPosition: animated];
    [self resetLabel];
}


- (void) resetLabel {
    [UIView animateWithDuration: 0.25 delay: 0.0 options: UIViewAnimationOptionCurveEaseInOut animations: ^{
        associatedLabel.alpha = 1.0;
    }                completion: nil];
}


- (void) resetPosition: (BOOL) animated {

    [UIView animateWithDuration: (animated ? 0.25: 0) delay: 0.0 options: UIViewAnimationOptionCurveEaseInOut animations: ^{

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