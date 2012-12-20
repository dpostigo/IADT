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
    IBOutlet UIView *successView;

    IBOutletCollection(UIView) NSArray *successViews;
    IBOutletCollection(UIView) NSArray *containerViews;


    NSMutableArray *draggables;

    NSInteger itemCount;


}


@property(nonatomic, strong) GameIntroView *introView;
@property(nonatomic, strong) NSMutableArray *draggables;


- (IBAction) reset: (id) sender;


@end