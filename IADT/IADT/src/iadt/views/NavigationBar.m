//
// Created by dpostigo on 12/18/12.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "NavigationBar.h"
#import "DDProgressView.h"


@implementation NavigationBar {
}


@synthesize pageControlContainer;
@synthesize pageControl;
@synthesize homeButton;
@synthesize progressView;


- (void) awakeFromNib {
    [super awakeFromNib];

    progressView.progress = 0;

//    progressView.emptyColor = [UIColor lightGrayColor];

}



@end