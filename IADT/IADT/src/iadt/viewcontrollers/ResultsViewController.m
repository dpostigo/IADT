//
// Created by dpostigo on 12/18/12.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Twitter/Twitter.h>
#import <FacebookSDK/FacebookSDK.h>
#import "ResultsViewController.h"
#import "Model.h"
#import "UpdateToDocuments.h"
#import "SocialHandler.h"
#import "DEFacebookComposeViewController.h"
#import "DETweetComposeViewController.h"
#import "Reachability.h"


@implementation ResultsViewController {
    NSString *badgeName;
    NSString *messageString;
}


- (void) loadView {
    [super loadView];

    messageString = [NSString stringWithFormat: @"My digital DNA."];

    NSLog(@"%s", __PRETTY_FUNCTION__);

    NSArray *points = [_model.pointScores allValues];
    CGPoint monsterPoint = CGPointMake(0, 0);
    for (NSValue *value in points) {
        CGPoint point = [value CGPointValue];
        monsterPoint.x += point.x;
        monsterPoint.y += point.y;
    }

    NSUInteger numGames = [[_model.pointScores allKeys] count];
    CGPoint resultPoint = CGPointMake(monsterPoint.x / numGames, monsterPoint.y / numGames);
    NSInteger base = 0;
    if (resultPoint.y > 0) {
        if (resultPoint.x < 0) {
            base = 1;
            base = base + [self chooseTriangle: monsterPoint switch: NO];
        } else {
            base = 3;
            base = base + [self chooseTriangle: monsterPoint switch: YES];
        }
    } else {
        if (resultPoint.x > 0) {
            base = 5;
            base = base + [self chooseTriangle: monsterPoint switch: NO];
        } else {
            base = 7;
            base = base + [self chooseTriangle: monsterPoint switch: YES];
        }
    }

    badgeName = [NSString stringWithFormat: @"badge%i", base];
    badgeView.image = [UIImage imageNamed: badgeName];

    NSLog(@"NSStringFromCGPoint(resultPoint) = %@", NSStringFromCGPoint(resultPoint));
    NSLog(@"badgeName = %@", badgeName);
}


- (NSInteger) chooseTriangle: (CGPoint) monsterPoint switch: (BOOL) shouldSwitch {

    NSInteger ret = 0;
    if (abs((int) monsterPoint.x) > abs((int) monsterPoint.y)) {
        ret = 0;
    } else {
        ret = 1;
    }

    if (shouldSwitch) {
        ret = (ret == 0) ? 1: 0;
    }
    return ret;
}


- (void) viewWillAppear: (BOOL) animated {
    [super viewWillAppear: animated];

    if ([[_model.scores allValues] count] > 0) {
        NSString *string = [[_model.scores allValues] componentsJoinedByString: @", "];
        NSLog(@"string = %@", string);
        resultLabel.text = string;

        string = [[_model.scores allValues] componentsJoinedByString: @" "];
        [_queue addOperation: [[UpdateToDocuments alloc] initWithResult: string]];
    }
}


- (IBAction) handleTwitter: (id) sender {

    if (!self.isNetworkAvailable) {
        [self showNoNetwork];
        return;
    }

    DETweetComposeViewControllerCompletionHandler completionHandler = ^(DETweetComposeViewControllerResult result) {
        switch (result) {
            case DETweetComposeViewControllerResultCancelled:
                NSLog(@"Twitter Result: Cancelled");
                break;
            case DETweetComposeViewControllerResultDone:
                NSLog(@"Twitter Result: Sent");
                break;
        }

        [self dismissViewControllerAnimated: YES completion: nil];

        NSHTTPCookie *cookie;
        NSHTTPCookieStorage *storage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
        for (cookie in [storage cookies]) {
            [storage deleteCookie: cookie];
        }
        [[NSUserDefaults standardUserDefaults] synchronize];
    };
    DETweetComposeViewController *controller = [[DETweetComposeViewController alloc] init];
    self.modalPresentationStyle = UIModalPresentationCurrentContext;
    [controller setInitialText: messageString];
    [controller addImage: [UIImage imageNamed: badgeName]];
    controller.alwaysUseDETwitterCredentials = YES;
    controller.completionHandler = completionHandler;
    [self presentViewController: controller animated: YES completion: nil];
}


- (IBAction) handleFacebook: (id) sender {

    if (!self.isNetworkAvailable) {
        [self showNoNetwork];
        return;
    }

    DEFacebookComposeViewControllerCompletionHandler completionHandler = ^(DEFacebookComposeViewControllerResult result) {
        switch (result) {
            case DEFacebookComposeViewControllerResultCancelled:
                NSLog(@"Facebook Result: Cancelled");
                break;
            case DEFacebookComposeViewControllerResultDone:
                NSLog(@"Facebook Result: Sent");
                break;
        }

        [[FBSession activeSession] closeAndClearTokenInformation];
        [self clearCookies];
        [self dismissViewControllerAnimated: YES completion: NULL];
    };
    DEFacebookComposeViewController *controller = [[DEFacebookComposeViewController alloc] init];
    [self setModalPresentationStyle: UIModalPresentationCurrentContext];
    controller.modalPresentationStyle = UIModalPresentationFullScreen;
    //    self.navigationController.modalPresentationStyle = UIModalPresentationCurrentContext;
    [controller setInitialText: messageString];
    [controller addImage: [UIImage imageNamed: badgeName]];
    [controller setCompletionHandler: completionHandler];

    [self presentViewController: controller animated: YES completion: nil];
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
        [self clearCookies];

        [self dismissViewControllerAnimated: YES completion: nil];
    }];

    [self presentViewController: controller animated: YES completion: nil];
}


- (void) clearCookies {
    NSHTTPCookie *cookie;
    NSHTTPCookieStorage *storage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    for (cookie in [storage cookies]) {
        [storage deleteCookie: cookie];
    }
    [[NSUserDefaults standardUserDefaults] synchronize];
}


- (void) touchesBegan: (NSSet *) touches withEvent: (UIEvent *) event {

    NSLog(@"%s", __PRETTY_FUNCTION__);
}


- (BOOL) isNetworkAvailable {

    Reachability *curReach = [Reachability reachabilityForInternetConnection];
    NetworkStatus netStatus = [curReach currentReachabilityStatus];
    BOOL connectionRequired = [curReach connectionRequired];
    NSString *statusString = @"";

    if (netStatus == NotReachable) {
        return false;
    }

    return true;
}


- (void) showNoNetwork {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle: @"No Internet Connection" message: @"Your device is not connected to the Internet." delegate: nil cancelButtonTitle: @"OK" otherButtonTitles: nil];
    [alert show];
}

@end