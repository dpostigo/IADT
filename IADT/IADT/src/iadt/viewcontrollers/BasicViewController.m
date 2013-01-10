//
// Created by dpostigo on 9/19/12.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "BasicViewController.h"
#import "DeviceUtils.h"
#import "UIColor+Utils.h"
#import "FadePopSegue.h"
#import "DeleteToDocuments.h"


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
    //navigationBarView.pageControl.currentPage = [self.navigationController.viewControllers count] - 1;


    CGFloat currentPage = [self.navigationController.viewControllers count] - 1;
    CGFloat progress =  currentPage / 9.0f;
    navigationBarView.progressView.progress = progress;


    if (currentPage > 2)
        [navigationBarView.homeButton addTarget: self action: @selector(handleHome:) forControlEvents: UIControlEventTouchUpInside];
}


- (IBAction) handleHome: (id) sender {

    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle: @"Quit" message: @"Are you sure you want to cancel and restart?" delegate: self cancelButtonTitle: @"Cancel" otherButtonTitles: @"Quit", nil];
    alertView.delegate = self;
    [alertView show];
}


- (void) alertView: (UIAlertView *) alertView didDismissWithButtonIndex: (NSInteger) buttonIndex {
    if (buttonIndex == alertView.cancelButtonIndex) {
    }

    else {

        [_queue addOperation: [[DeleteToDocuments alloc] init]];
        UIViewController *root = [self.navigationController.viewControllers objectAtIndex: 0];
        UIStoryboardSegue *segue = [[FadePopSegue alloc] initWithIdentifier: @"BackToHome" source: self destination: root];
        [segue perform];
    }
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