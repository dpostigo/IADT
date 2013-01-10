//
// Created by dpostigo on 12/17/12.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>


@interface GameIntroView : UIView {

    IBOutlet UILabel *textLabel;
    IBOutlet UILabel *detailTextLabel;
    __unsafe_unretained id delegate;
}


@property(nonatomic, strong) UILabel *textLabel;
@property(nonatomic, strong) UILabel *detailTextLabel;
@property(nonatomic, assign) id delegate;
- (IBAction) fadeAndRemove: (id) sender;
- (void) show: (UIView *) onView;

@end