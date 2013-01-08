//
// Created by dpostigo on 9/19/12.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "BasicViewController.h"
#import "DeviceUtils.h"
#import "DETweetComposeViewController.h"

@implementation BasicViewController {

}

@synthesize backgroundView;
@synthesize activityView;


- (void) viewDidLoad {
    [super viewDidLoad];


    if (backgroundView == nil) {

        NSString *string = @"background-texture.png";
        if ([DeviceUtils isPad]) string = @"background-texture-ipad.png";

        NSLog(@"string = %@", string);
        UIImageView *background = [[UIImageView alloc] initWithImage: [UIImage imageNamed: string]];

        backgroundView = [[UIView alloc] init];
        [backgroundView addSubview: background];

        [self.view insertSubview: backgroundView atIndex: 0];
    }


    DETweetComposeViewControllerCompletionHandler completionHandler = ^(DETweetComposeViewControllerResult result) {
        switch (result) {
            case DETweetComposeViewControllerResultCancelled:
                NSLog(@"Twitter Result: Cancelled");
                break;
            case DETweetComposeViewControllerResultDone:
                NSLog(@"Twitter Result: Sent");
                break;
        }
        [self dismissModalViewControllerAnimated:YES];
    };

    DETweetComposeViewController *tcvc = [[DETweetComposeViewController alloc] init];
    self.modalPresentationStyle = UIModalPresentationCurrentContext;
//    [self addTweetContent:tcvc];
    tcvc.completionHandler = completionHandler;

    // Optionally, set alwaysUseDETwitterCredentials to YES to prevent using
    //  iOS5 Twitter credentials.
    tcvc.alwaysUseDETwitterCredentials = YES;
    [self presentViewController: tcvc animated: YES completion: nil];

}


- (BOOL) shouldAutorotateToInterfaceOrientation: (UIInterfaceOrientation) toInterfaceOrientation {
    return UIInterfaceOrientationIsLandscape(toInterfaceOrientation);
}




@end