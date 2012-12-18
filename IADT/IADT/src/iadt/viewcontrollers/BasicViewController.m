//
// Created by dpostigo on 9/19/12.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "BasicViewController.h"
#import "DeviceUtils.h"
#import "UIColor+Utils.h"


@implementation BasicViewController {
}


@synthesize backgroundView;
@synthesize activityView;
@synthesize navigationBarView;


- (void) viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor colorWithString: @"e9e9e9"];
    self.navigationItem.hidesBackButton = YES;
}


- (void) loadView {
    [super loadView];
    self.navigationBarView = [[[NSBundle mainBundle] loadNibNamed: @"NavigationBar" owner: navigationBarView options: nil] objectAtIndex: 0];
    [self.view addSubview: navigationBarView];

    navigationBarView.pageControl.currentPage = [self.navigationController.viewControllers count] - 1;

    UISwipeGestureRecognizer *swipe = [[UISwipeGestureRecognizer alloc] initWithTarget: self action: @selector(handleSwipe:)];
    swipe.direction = UISwipeGestureRecognizerDirectionRight;

    [self.view addGestureRecognizer: swipe];
}


- (IBAction) popToRoot: (id) sender {
    [self.navigationController popToRootViewControllerAnimated: YES];
}


- (void) handleSwipe: (UISwipeGestureRecognizer *) swipe {

    [self.navigationController popViewControllerAnimated: YES];
}


- (BOOL) shouldAutorotateToInterfaceOrientation: (UIInterfaceOrientation) toInterfaceOrientation {
    return UIInterfaceOrientationIsLandscape(toInterfaceOrientation);
}

@end