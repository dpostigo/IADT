//
// Created by dpostigo on 12/18/12.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Accounts/Accounts.h>
#import <Twitter/Twitter.h>
#import <FacebookSDK/FacebookSDK.h>
#import "ResultsViewController.h"
#import "Model.h"
#import "UpdateToDocuments.h"
#import "MGTwitterEngine.h"
#import "SA_OAuthTwitterEngine.h"
#import "SA_OAuthTwitterController.h"
#import "SocialHandler.h"
#import "DEFacebookComposeViewController.h"




@implementation ResultsViewController {
    SA_OAuthTwitterController *authController;
    SA_OAuthTwitterEngine *_engine;
}


- (void) loadView {
    [super loadView];
}


- (void) viewWillAppear: (BOOL) animated {
    [super viewWillAppear: animated];

    if (!DEBUG) {

        NSString *string = [[_model.scores allValues] componentsJoinedByString: @", "];

        NSLog(@"string = %@", string);
        resultLabel.text = string;

        string = [[_model.scores allValues] componentsJoinedByString: @" "];
        [_queue addOperation: [[UpdateToDocuments alloc] initWithResult: string]];
    }
}


- (IBAction) handleTwitter: (id) sender {

    if (DEBUG) {

        _engine = [[SA_OAuthTwitterEngine alloc] initOAuthWithDelegate: self];
        _engine.consumerKey = kOAuthTwitterConsumerKey;
        _engine.consumerSecret = kOAuthTwitterConsumerSecret;

        authController = [SA_OAuthTwitterController controllerToEnterCredentialsWithTwitterEngine: _engine delegate: self forOrientation: self.interfaceOrientation];

        if (authController) {

            authController.modalPresentationStyle = UIModalPresentationFormSheet;
            authController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
            [self presentViewController: authController animated: YES completion: nil];
        }

        else {
            NSLog(@"Already updated.");
            [_engine sendUpdate: [NSString stringWithFormat: @"Already Updated. %@", [NSDate date]]];
        }
    }
}


- (void) tweet {

    SLComposeViewController *controller = [SLComposeViewController composeViewControllerForServiceType: SLServiceTypeTwitter];
    [controller setInitialText: @"Hello. This is a tweet."];

    [controller setCompletionHandler: ^(TWTweetComposeViewControllerResult result) {
        NSString *output;

        switch (result) {
            case TWTweetComposeViewControllerResultCancelled:
                // The cancel button was tapped.
                output = @"Tweet cancelled.";
                break;
            case TWTweetComposeViewControllerResultDone:
                // The tweet was sent.
                output = @"Tweet done.";
                break;
            default:
                break;
        }

        [SocialHandler removeTwitterAccounts];
        [self dismissViewControllerAnimated: YES completion: nil];
    }];

    [self presentViewController: controller animated: YES completion: nil];
}



- (IBAction) handleFacebook: (id) sender {

    NSLog(@"%s", __PRETTY_FUNCTION__);

    if (DEBUG) {


        DEFacebookComposeViewController *facebookViewComposer = [[DEFacebookComposeViewController alloc] init];

        self.modalPresentationStyle = UIModalPresentationCurrentContext;
        [facebookViewComposer setInitialText:@"Hello. This is a Facebook post."];
        // [facebookViewComposer addImage:[UIImage imageNamed:@"1.jpg"]];
        // [facebookViewComposer addURL:[NSURL URLWithString:@"http://applications.3d4medical.com/heart_pro.php"]];

        [facebookViewComposer setCompletionHandler:^(DEFacebookComposeViewControllerResult result) {
            switch (result) {
                case DEFacebookComposeViewControllerResultCancelled:
                    NSLog(@"Facebook Result: Cancelled");
                    break;
                case DEFacebookComposeViewControllerResultDone:
                    NSLog(@"Facebook Result: Sent");
                    break;
            }

            [self dismissViewControllerAnimated: YES completion: nil];

            [[FBSession activeSession] closeAndClearTokenInformation];
        }];

        [self presentViewController:facebookViewComposer animated:YES completion:^{ }];


    }

}




#pragma mark SA_OAuthTwitterEngineDelegate

- (void) storeCachedTwitterOAuthData: (NSString *) data forUsername: (NSString *) username {
    [SocialHandler saveTwitterAccountWithDataString: data];
}

- (NSString *) cachedTwitterOAuthDataForUsername: (NSString *) username {
    return nil;
}


#pragma mark SA_OAuthTwitterControllerDelegate
- (void) OAuthTwitterController: (SA_OAuthTwitterController *) controller authenticatedWithUsername: (NSString *) username {
    [authController dismissViewControllerAnimated: YES completion: ^{
        [self tweet];
    }];
}


- (void) OAuthTwitterControllerFailed: (SA_OAuthTwitterController *) controller {
    NSLog(@"Authentication Failed!");
}


- (void) OAuthTwitterControllerCanceled: (SA_OAuthTwitterController *) controller {
    NSLog(@"Authentication Canceled.");
}




@end