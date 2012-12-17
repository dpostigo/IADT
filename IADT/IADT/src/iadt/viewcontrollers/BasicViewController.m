//
// Created by dpostigo on 9/19/12.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "BasicViewController.h"
#import "DeviceUtils.h"

@implementation BasicViewController {

}

@synthesize backgroundView;
@synthesize activityView;


- (void) viewDidLoad {
    [super viewDidLoad];


    if (backgroundView == nil) {

        NSString *string = @"background-texture.png";
        if ([DeviceUtils isPad]) string = @"background-texture-ipad.png";


        UIImageView *background = [[UIImageView alloc] initWithImage: [UIImage imageNamed: string]];

        backgroundView = [[UIView alloc] init];
        [backgroundView addSubview: background];

        [self.view insertSubview: backgroundView atIndex: 0];
    }

    self.navigationItem.hidesBackButton = YES;
}


- (BOOL) shouldAutorotateToInterfaceOrientation: (UIInterfaceOrientation) toInterfaceOrientation {
    return UIInterfaceOrientationIsLandscape(toInterfaceOrientation);
}


@end