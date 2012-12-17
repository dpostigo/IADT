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


    NSString *titleText;
    NSString *detailTitleText;
}


@property(nonatomic, strong) GameIntroView *introView;
@property(nonatomic, retain) NSString *titleText;
@property(nonatomic, retain) NSString *detailTitleText;
- (IBAction) dragItem: (UIPanGestureRecognizer *) recognizer;

@end