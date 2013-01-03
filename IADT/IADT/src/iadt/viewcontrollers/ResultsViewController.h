//
// Created by dpostigo on 12/18/12.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>
#import "BasicViewController.h"
#import "SA_OAuthTwitterController.h"


@interface ResultsViewController : BasicViewController <SA_OAuthTwitterControllerDelegate> {

    IBOutlet UILabel *resultLabel;
}


- (IBAction) handleTwitter: (id) sender;

@end