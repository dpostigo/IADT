//
// Created by dpostigo on 12/17/12.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>
#import "BasicViewController.h"
#import "GameIntroView.h"



@interface BasicGameViewController : BasicViewController {

    BOOL isDummyGame;
    GameIntroView *introView;

    IBOutlet UIImageView *ghostImage;
    IBOutlet UIView *containerView;
    IBOutlet UIView *successView;
    IBOutlet UIButton *validSuccessButton;

    IBOutletCollection(UIView) NSArray *successButtons;
    IBOutletCollection(UIView) NSArray *successViews;
    IBOutletCollection(UIView) NSArray *containerViews;
    IBOutletCollection(UIView) NSArray *labels;
    NSMutableArray *draggables;
    NSInteger itemCount;

    IBOutlet UIButton *nextButton;

}


@property(nonatomic, strong) GameIntroView *introView;
@property(nonatomic, strong) NSMutableArray *draggables;
@property(nonatomic) BOOL isDummyGame;
- (IBAction) reset: (id) sender;


@end