//
// Created by dpostigo on 9/19/12.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "BasicViewController.h"
#import "DeviceUtils.h"
#import "UIColor+Utils.h"


@implementation BasicViewController {
    CGPoint startLocation;
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

    UIPanGestureRecognizer *swipe = [[UIPanGestureRecognizer alloc] initWithTarget: self action: @selector(handleSwipe:)];
    swipe.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer: swipe];
}


- (IBAction) popToRoot: (id) sender {
    [self.navigationController popToRootViewControllerAnimated: YES];
}


- (void) handleSwipe: (UIPanGestureRecognizer *) sender {
    if (sender.state == UIGestureRecognizerStateBegan) {
        startLocation = [sender locationInView: self.view];
    }
    else if (sender.state == UIGestureRecognizerStateEnded) {
        CGPoint stopLocation = [sender locationInView: self.view];
        CGFloat dx = stopLocation.x - startLocation.x;
        CGFloat dy = stopLocation.y - startLocation.y;
        CGFloat distance = sqrt(dx * dx + dy * dy);
        NSLog(@"Distance: %f", distance);

        if (distance > 700) {

            CGPoint velocity = [sender velocityInView: sender.view];

            if (velocity.x > 0) {
                [self.navigationController popViewControllerAnimated: YES];
            }
            else {
                NSLog(@"gesture went left");
            }

        }
    }
}


- (BOOL) shouldAutorotateToInterfaceOrientation: (UIInterfaceOrientation) toInterfaceOrientation {
    return UIInterfaceOrientationIsLandscape(toInterfaceOrientation);
}

@end