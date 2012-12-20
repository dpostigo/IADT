//
// Created by dpostigo on 12/18/12.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>
#import "PuttyView.h"


@class Draggable;
@protocol DraggableDelegate <NSObject>


@optional
- (void) draggableBeganDrop: (Draggable *) draggable;
- (void) draggableDidDrop: (Draggable *) draggable;
- (void) draggableDidNotDrop: (Draggable *) draggable;


@end


@interface Draggable : PuttyView {

    BOOL snapsToContainer;
    BOOL shouldFade;
    BOOL droppingDisabled;
    BOOL shouldHover;


    CGFloat circleRadius;
    BOOL maskEnabled;

    UIView *droppable;
    NSMutableArray *droppables;


    CGPoint startingPoint;

    id<DraggableDelegate> delegate;

    NSInteger itemLimit;
    NSUInteger itemCount;




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
- (void) reset;

@end

