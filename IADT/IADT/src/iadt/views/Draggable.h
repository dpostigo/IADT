//
// Created by dpostigo on 12/18/12.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>
#import "PuttyView.h"


typedef enum {
    DraggingModeContains = 0,
    DraggingModeIntersects = 1
} DraggingMode;

typedef enum {
    DraggableMaskTypeCircle = 0,
    DraggableMaskTypeCustom = 1,
    DraggableMaskTypeCustomCentered = 2
} DraggableMaskType;



@class Draggable;


@protocol DraggableDelegate <NSObject>


@optional
- (void) draggableBeganDragging: (Draggable *) draggable;
- (void) draggableWillDrop: (Draggable *) draggable;
- (void) draggableDidNotDrop: (Draggable *) draggable;
- (void) draggableDidFinishDrop: (Draggable *) draggable;
- (void) draggableDidFinishDragging: (Draggable *) draggable;

@end


@interface Draggable : PuttyView {


    __unsafe_unretained UILabel *associatedLabel;
    BOOL snapsToContainer;
    BOOL shouldFade;
    BOOL droppingDisabled;
    BOOL shouldHover;
    BOOL reverseScale;
    BOOL maskEnabled;


    UIView *maskView;
    CGFloat circleRadius;
    UIView *droppable;
    NSMutableArray *droppables;
    CGPoint startingPoint;
    id <DraggableDelegate> delegate;
    NSInteger itemLimit;
    NSUInteger itemCount;
    UIView *currentDrop;
    DraggingMode draggingMode;
    DraggableMaskType maskType;
}


@property(nonatomic, strong) UIView *droppable;
@property(nonatomic, strong) NSMutableArray *droppables;
@property(nonatomic) CGPoint startingPoint;
@property(nonatomic, strong) id <DraggableDelegate> delegate;
@property(nonatomic) BOOL shouldFade;
@property(nonatomic) BOOL snapsToContainer;
@property(nonatomic) CGFloat circleRadius;
@property(nonatomic) BOOL maskEnabled;
@property(nonatomic) NSInteger itemLimit;
@property(nonatomic) BOOL droppingDisabled;
@property(nonatomic) BOOL shouldHover;
@property(nonatomic, strong) UIView *currentDrop;
@property(nonatomic) BOOL reverseScale;
@property(nonatomic) DraggingMode draggingMode;
@property(nonatomic, assign) UILabel *associatedLabel;
@property(nonatomic) DraggableMaskType maskType;
@property(nonatomic, strong) UIView *maskView;
- (BOOL) isPlaced;
- (void) reset;
- (void) reset: (BOOL) animated;

@end


