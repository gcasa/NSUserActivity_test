//
//  AppDelegate.m
//  NSUserActivity_test
//
//  Created by Gregory Casamento on 5/27/23.
//

#import "AppDelegate.h"

@interface AppDelegate ()

@property (strong) IBOutlet NSWindow *window;
@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
  // Insert code here to initialize your application
  NSUserActivity *activity = [[NSUserActivity alloc] initWithActivityType: @"INStartAudioCallIntent"];

  activity.title = @"title";
  activity.delegate = self;
  activity.needsSave = YES;
  activity.webpageURL = [NSURL URLWithString:@"https://www.google.com"];
  activity.userInfo = @{@"name": @"test", @"deep_link": @"test"};
  // set requiredUserInfoKeys if you're also setting webPageURL !!
  // otherwise, userInfo will be nil !!
  activity.requiredUserInfoKeys = [NSSet setWithArray:@[@"name", @"deep_link"]];
  activity.eligibleForSearch = YES;
  activity.eligibleForPublicIndexing = YES;

  [activity becomeCurrent];
}


- (void)applicationWillTerminate:(NSNotification *)aNotification {
  // Insert code here to tear down your application
}


- (BOOL)applicationSupportsSecureRestorableState:(NSApplication *)app {
  return YES;
}

- (BOOL)application:(NSApplication *)application willContinueUserActivityWithType:(NSString *)userActivityType
{
  return YES;
}

- (BOOL)application:(NSApplication *)application continueUserActivity:(NSUserActivity *)userActivity restorationHandler:(void (^)(NSArray<id<NSUserActivityRestoring>> * _Nonnull))restorationHandler
{
  NSLog(@" Userinfo Data==>%@  useractivityTitle ==>%@  activityType-->%@ webpage-->%@",userActivity.userInfo , userActivity.title,userActivity.activityType,userActivity.webpageURL );
  return YES;
}

- (void)application:(NSApplication *)application didUpdateUserActivity:(NSUserActivity *)userActivity
{
  NSLog(@"didUpdateUserActivity");
}

// Save activity...

- (void)userActivityWillSave:(NSUserActivity *)userActivity
{
  userActivity.userInfo = @{@"name": @"test", @"deep_link": @"test"};
  NSLog(@"userActivityWillSave");
}

- (void)updateUserActivityState:(NSUserActivity *)userActivity
{
  NSLog(@"updateUserActivityState");
  [userActivity addUserInfoEntriesFromDictionary:@{@"name": @"test", @"deep_link": @"test"}];
}
@end
