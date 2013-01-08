//
// Created by dpostigo on 12/18/12.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>
#import "BasicViewController.h"
//#import "SA_OAuthTwitterController.h"


@interface ResultsViewController : BasicViewController {

    IBOutlet UILabel *resultLabel;
    IBOutlet UIImageView *badgeView;
}


- (IBAction) handleTwitter: (id) sender;
- (IBAction) handleFacebook: (id) sender;

@end