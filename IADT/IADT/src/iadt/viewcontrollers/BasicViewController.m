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


- (void) viewDidLoad {
    [super viewDidLoad];


//    if (backgroundView == nil) {
//
//        NSString *string = @"splash-bg.png";
////        if ([DeviceUtils isPad]) string = @"background-texture-ipad.png";
//
//
//        UIImageView *background = [[UIImageView alloc] initWithImage: [UIImage imageNamed: string]];
//
//        backgroundView = [[UIView alloc] init];
//        [backgroundView addSubview: background];
//
//        [self.view insertSubview: backgroundView atIndex: 0];
//    }

    self.view.backgroundColor = [UIColor colorWithString: @"e9e9e9"];
    NSLog(@"self.view.backgroundColor = %@", self.view.backgroundColor);
    self.navigationItem.hidesBackButton = YES;
}


- (IBAction) popToRoot: (id) sender {
    [self.navigationController popToRootViewControllerAnimated: YES];

}

- (BOOL) shouldAutorotateToInterfaceOrientation: (UIInterfaceOrientation) toInterfaceOrientation {
    return UIInterfaceOrientationIsLandscape(toInterfaceOrientation);
}


@end