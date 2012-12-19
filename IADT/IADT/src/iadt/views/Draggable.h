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
- (void) draggableDidDrop: (Draggable *) draggable;


@end


@interface Draggable : PuttyView {

    UIView *droppable;
    NSArray *droppables;

    CGPoint startingPoint;
    BOOL shouldSnap;
    BOOL shouldFade;

    id<DraggableDelegate> delegate;


}


@property(nonatomic, strong) UIView *droppable;
@property(nonatomic, strong) NSArray *droppables;
@property(nonatomic) CGPoint startingPoint;
@property(nonatomic, strong) id <DraggableDelegate> delegate;
@property(nonatomic) BOOL shouldFade;
- (void) reset;

@end


