//
//  AppDelegate.m
//  Household Draft
//
//  Created by Daniela Postigo on 10/16/12.
//  Copyright (c) 2012 Daniela Postigo. All rights reserved.
//

#import <FacebookSDK/FacebookSDK.h>
#import "AppDelegate.h"
#import "ReconcileCSV.h"
#import "DebugLog.h"


@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    NSDictionary *appDefaults = [NSDictionary dictionaryWithObject:[NSNumber numberWithBool:YES] forKey:@"user_data_enabled"];
    [[NSUserDefaults standardUserDefaults] registerDefaults:appDefaults];

#ifdef TESTFLIGHT_ENABLED
    [TestFlight setDeviceIdentifier:[[UIDevice currentDevice] uniqueIdentifier]];
    [TestFlight takeOff:@"44a2eeaa-a91a-4178-b51a-4d7584bef7dc"];
#endif

    NSOperationQueue *queue = [NSOperationQueue new];
    [queue addOperation:[[ReconcileCSV alloc] init]];


    return YES;
}


- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {

//    NSSetUncaughtExceptionHandler(&uncaughtExceptionHandler);

    // attempt to extract a token from the url
    return [FBSession.activeSession handleOpenURL:url];
}


- (void)applicationWillResignActive:(UIApplication *)application {
    NSLog(@"%s", __PRETTY_FUNCTION__);
}

- (void)applicationDidBecomeActive:(UIApplication *)application {

}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    NSLog(@"%s", __PRETTY_FUNCTION__);
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
}

- (void)applicationWillTerminate:(UIApplication *)application {
}


@end
