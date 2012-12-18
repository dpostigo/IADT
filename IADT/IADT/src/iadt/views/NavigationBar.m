//
// Created by dpostigo on 12/18/12.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "NavigationBar.h"


@implementation NavigationBar {
}


@synthesize pageControlContainer;
@synthesize pageControl;




- (void) awakeFromNib {
    [super awakeFromNib];

    pageControl = [[SMPageControl alloc] initWithFrame: pageControlContainer.bounds];
    [self.pageControlContainer addSubview: pageControl];
    pageControl.width = 300;
    pageControl.right = pageControlContainer.width;
    pageControl.userInteractionEnabled = NO;

    pageControl.numberOfPages = 9;
    pageControl.indicatorMargin = 20.0f;
    pageControl.indicatorDiameter = 10.0f;
    [pageControl setPageIndicatorImage: [UIImage imageNamed: @"pageDot.png"]];
    [pageControl setCurrentPageIndicatorImage: [UIImage imageNamed: @"pageDot-selected.png"]];
}



@end