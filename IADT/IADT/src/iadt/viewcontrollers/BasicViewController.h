//
// Created by dpostigo on 9/19/12.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>
#import "VeryBasicViewController.h"
#import "NavigationBar.h"

@interface BasicViewController : VeryBasicViewController <UIAlertViewDelegate> {
    IBOutlet UIView *backgroundView;
    IBOutlet UIActivityIndicatorView *activityView;

    NavigationBar *navigationBarView;
}

@property(nonatomic, strong) IBOutlet UIView *backgroundView;
@property(nonatomic, strong) UIActivityIndicatorView *activityView;
@property(nonatomic, strong) NavigationBar *navigationBarView;

@end