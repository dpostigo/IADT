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
#import "DeleteCSV.h"


#define FINAL_TAG 22


@implementation BasicViewController {
    CGPoint startLocation;
    NSInteger lastTag;
}


@synthesize backgroundView;
@synthesize activityView;
@synthesize navigationBarView;


- (void) viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor colorWithString: @"e9e9e9"];
    self.navigationItem.hidesBackButton = YES;


}


- (void) viewDidAppear: (BOOL) animated {
    [super viewDidAppear: animated];

    NSLog(@"%s", __PRETTY_FUNCTION__);
    for (int j = 0; j < 3; j++) {
        UIButton *button = [UIButton buttonWithType: UIButtonTypeCustom];
        button.bounds = CGRectMake(0, 0, 100, 100);

        if (j == 0) {
            button.right = self.view.width;
            button.top = 0;
        } else if (j == 1) {

            button.bottom = self.view.height;
            button.right = self.view.width;
        } else if (j == 2) {
            button.left = 0;
            button.bottom = self.view.height;
        }

        button.tag = 20 + j;
        [button addTarget: self action: @selector(handleSecretGesture:) forControlEvents: UIControlEventTouchUpInside];
        [self.view addSubview: button];
    }

    NSLog(@"%s", sel_getName(_cmd));
}


- (void) handleSecretGesture: (id) sender {
    NSLog(@"%s", __PRETTY_FUNCTION__);


    NSInteger tag = [sender tag];

    if (tag == FINAL_TAG) {
        lastTag = 0;

        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle: @"Delete Data" message: @"Are you sure you want to delete all your data?" delegate: self cancelButtonTitle: @"Cancel" otherButtonTitles: @"OK", nil];
        alertView.delegate = self;
        [alertView show];
    } else if (tag == lastTag - 1 || lastTag == 0) {
        lastTag = tag;
    } else {
        //Not in sequence
    }
}


- (void) handleDeleteData {
    [_queue addOperation: [[DeleteCSV alloc] init]];
}


- (void) loadView {
    [super loadView];
    self.navigationBarView = [[[NSBundle mainBundle] loadNibNamed: @"NavigationBar" owner: navigationBarView options: nil] objectAtIndex: 0];
    [self.view addSubview: navigationBarView];
    //navigationBarView.pageControl.currentPage = [self.navigationController.viewControllers count] - 1;


    CGFloat currentPage = [self.navigationController.viewControllers count] - 1;
    CGFloat progress = currentPage / 9.0f;
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
    if ([alertView.title isEqualToString: @"Quit"]) {
        if (buttonIndex != alertView.cancelButtonIndex) {

            NSLog(@"Delete to documents");
            [_queue addOperation: [[DeleteToDocuments alloc] init]];
            UIViewController *root = [self.navigationController.viewControllers objectAtIndex: 0];
            UIStoryboardSegue *segue = [[FadePopSegue alloc] initWithIdentifier: @"BackToHome" source: self destination: root];
            [segue perform];
        }
    }

    else if ([alertView.title isEqualToString: @"Delete Data"]) {
        if (buttonIndex != alertView.cancelButtonIndex) {
            [self handleDeleteData];
        }
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