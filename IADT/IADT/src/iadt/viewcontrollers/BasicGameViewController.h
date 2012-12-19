//
// Created by dpostigo on 12/17/12.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>
#import "BasicViewController.h"
#import "GameIntroView.h"


@interface BasicGameViewController : BasicViewController {

    GameIntroView *introView;


    IBOutlet UIView *containerView;
    IBOutletCollection(UIView) NSArray *containerViews;

    IBOutletCollection(UIView) NSArray *successViews;
    IBOutlet UIView *successView;

    NSMutableArray *draggables;
}


@property(nonatomic, strong) GameIntroView *introView;

@property(nonatomic, strong) NSMutableArray *draggables;
- (IBAction) reset: (id) sender;
- (void) dragItem: (UIPanGestureRecognizer *) recognizer;

@end