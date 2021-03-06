//
// Created by dpostigo on 12/6/12.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <QuartzCore/QuartzCore.h>
#import "BasicWhiteView.h"
#import "UIColor+Utils.h"


@implementation BasicWhiteView {
}


- (void) awakeFromNib {
    [super awakeFromNib];

    self.backgroundColor = [UIColor colorWithWhite: 0.98 alpha: 1.0];
    self.backgroundColor = [UIColor colorWithString: @"f4f4f4"];
    self.clipsToBounds = NO;
    self.layer.shadowColor = [UIColor blackColor].CGColor;
    self.layer.shadowOffset = CGSizeMake(0, 1);
    self.layer.shadowOpacity = 0.5;
    self.layer.shadowRadius = 1.0;
    self.layer.masksToBounds = NO;
    self.layer.borderColor = [UIColor whiteColor].CGColor;
    self.layer.borderWidth = 1.0;
}


- (id) initWithCoder: (NSCoder *) aDecoder {
    self = [super initWithCoder: aDecoder];
    if (self) {
    }

    return self;
}

@end