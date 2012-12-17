//
// Created by dpostigo on 12/17/12.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>


@interface GameIntroView : UIView {

    IBOutlet UILabel *textLabel;
    IBOutlet UILabel *detailTextLabel;
}


@property(nonatomic, strong) UILabel *textLabel;
@property(nonatomic, strong) UILabel *detailTextLabel;
- (IBAction) fadeAndRemove: (id) sender;

@end