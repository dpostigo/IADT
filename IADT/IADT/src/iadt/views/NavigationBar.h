//
// Created by dpostigo on 12/18/12.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>
#import "SMPageControl.h"


@interface NavigationBar : UIView {

    IBOutlet UIView *pageControlContainer;
    SMPageControl *pageControl;
    IBOutlet UIButton *homeButton;


}


@property(nonatomic, strong) UIView *pageControlContainer;
@property(nonatomic, strong) SMPageControl *pageControl;
@property(nonatomic, strong) UIButton *homeButton;

@end