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
    UIView *currentDrop;
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


- (id) initWithFrame: (CGRect) frame {
    self = [super initWithFrame: frame];
    if (self) {
        shouldFade = YES;

        circleMask = [[UIView alloc] initWithFrame: self.bounds];
        circleMask.backgroundColor = [UIColor clearColor];
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
    circleMask.center = CGPointMake(self.width/2, self.height/2);
}




- (BOOL) pointInside: (CGPoint) point withEvent: (UIEvent *) event {
    if (maskEnabled) {
        return CGRectContainsPoint(circleMask.frame, point);
    }
    return [super pointInside: point withEvent: event];
}


- (void) touchesBegan: (NSSet *) touches withEvent: (UIEvent *) event {
    [super touchesBegan: touches withEvent: event];

    if (currentDrop != nil) {
        currentDrop.userInteractionEnabled = YES;
        currentDrop = nil;
    }


    [UIView animateWithDuration: 0.25 delay: 0.0 options: UIViewAnimationOptionCurveEaseOut animations: ^{
        self.transform = CGAffineTransformScale(self.transform, 1.15, 1.15);
    }                completion: ^(BOOL completion) {

    }];

    [self draggableBeganDrop];


}


- (void) touchesMoved: (NSSet *) touches withEvent: (UIEvent *) event {
    [super touchesMoved: touches withEvent: event];

    if (shouldHover) {


    }
}


- (void) touchesEnded: (NSSet *) touches withEvent: (UIEvent *) event {
    [super touchesEnded: touches withEvent: event];

    BOOL wasDropped = NO;
    UIView *dropContainer = nil;

    if (droppable != nil) {
        dropContainer = droppable;
        wasDropped = CGRectIntersectsRect(droppable.frame, self.frame);


    }

    else if (droppables != nil && [droppables count] > 0) {
        for (UIView *aDroppable in droppables) {
            wasDropped = CGRectIntersectsRect(aDroppable.frame, self.frame) && aDroppable.userInteractionEnabled;
            if (wasDropped)    {
                dropContainer = aDroppable;
                dropContainer.userInteractionEnabled = NO;
                break;
            }
        }


    }

    if (droppingDisabled) wasDropped = NO;



    if (wasDropped){
        [self draggableWasDropped: dropContainer];
    }
    else [self draggableWasNotDropped];
}


- (void) draggableBeganDrop {
    if ([delegate respondsToSelector: @selector(draggableBeganDrop:)]) {
        [delegate performSelector: @selector(draggableBeganDrop:) withObject: self];
    }
}

- (void) draggableWasDropped: (UIView *) dropContainer {

    currentDrop = dropContainer;
    itemCount += 1;

    NSLog(@"itemCount = %i", itemCount);

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
    [self reset];

    if ([delegate respondsToSelector: @selector(draggableDidNotDrop:)]) {
        [delegate performSelector: @selector(draggableDidNotDrop:) withObject: self];
    }
}


- (void) reset {

    self.droppingDisabled = NO;
    for (UIView *d in droppables) {
        d.userInteractionEnabled = YES;
    }
    [UIView animateWithDuration: 0.25 delay: 0.0 options: UIViewAnimationOptionCurveEaseInOut animations: ^{
        self.transform = CGAffineTransformIdentity;
        self.origin = startingPoint;
        self.alpha = 1;
    }                completion: ^(BOOL completion) {
    }];
}

@end