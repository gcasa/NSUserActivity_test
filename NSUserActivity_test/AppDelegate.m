//
//  AppDelegate.m
//  NSUserActivity_test
//
//  Created by Gregory Casamento on 1/3/26.
//

#import "AppDelegate.h"
#import <CoreSpotlight/CoreSpotlight.h>
#if __has_include(<UniformTypeIdentifiers/UniformTypeIdentifiers.h>)
#import <UniformTypeIdentifiers/UniformTypeIdentifiers.h>
#endif
#if __has_include(<MobileCoreServices/MobileCoreServices.h>)
#import <MobileCoreServices/MobileCoreServices.h>
#endif

@interface AppDelegate ()

@property (strong) IBOutlet NSWindow *window;
@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    [self encodeAndSaveUserActivity];
}


- (void)applicationWillTerminate:(NSNotification *)aNotification {
    // Insert code here to tear down your application
}


- (BOOL)applicationSupportsSecureRestorableState:(NSApplication *)app {
    return YES;
}

#pragma mark - NSUserActivity Encoding

- (CSSearchableItemAttributeSet *)makeAttributeSet {
    CSSearchableItemAttributeSet *attributeSet = nil;
#if __has_include(<UniformTypeIdentifiers/UniformTypeIdentifiers.h>)
    if (@available(macOS 11.0, *)) {
        attributeSet = [[CSSearchableItemAttributeSet alloc] initWithContentType:UTTypeItem];
    }
#endif
    if (attributeSet == nil) {
#ifdef kUTTypeItem
        attributeSet = [[CSSearchableItemAttributeSet alloc] initWithItemContentType:(NSString *)kUTTypeItem];
#else
        attributeSet = [[CSSearchableItemAttributeSet alloc] initWithItemContentType:@"public.item"];
#endif
    }
    attributeSet.title = @"Sample Activity Title";
    attributeSet.contentDescription = @"Encoding a fully populated NSUserActivity for archival.";
    attributeSet.keywords = @[@"NSUserActivity", @"encoding", @"handoff"];
    return attributeSet;
}

- (NSUserActivity *)buildSampleActivity {
    NSUserActivity *activity = [[NSUserActivity alloc] initWithActivityType:@"com.example.nsuseractivity.test"];
    activity.title = @"NSUserActivity Encoding Sample";
    activity.webpageURL = [NSURL URLWithString:@"https://example.com/activity/1234"];
    activity.userInfo = @{ @"identifier": @"1234",
                           @"note": @"Testing NSUserActivity encoding" };
    activity.requiredUserInfoKeys = [NSSet setWithArray:@[@"identifier", @"note"]];
    activity.keywords = [NSSet setWithArray:@[@"sample", @"handoff", @"search"]];
    activity.persistentIdentifier = @"com.example.nsuseractivity.test.1234";
    activity.targetContentIdentifier = @"com.example.nsuseractivity.target";
    activity.expirationDate = [NSDate dateWithTimeIntervalSinceNow:3600];
    activity.needsSave = YES;
    activity.contentAttributeSet = [self makeAttributeSet];
    activity.eligibleForHandoff = YES;
    activity.eligibleForSearch = YES;
    if (@available(macOS 10.15, *)) {
        //activity.eligibleForPrediction = YES;
        activity.eligibleForPublicIndexing = YES;
        //activity.suggestedInvocationPhrase = @"Open the sample activity";
    }
    return activity;
}

- (void)encodeAndSaveUserActivity {
    NSUserActivity *activity = [self buildSampleActivity];
    NSError *error = nil;
    // NSUserActivity itself is not NSSecureCoding; archive a dictionary of its primitive values instead.
    NSMutableDictionary *payload = [NSMutableDictionary dictionary];

    if (activity.activityType) {
        payload[@"activityType"] = activity.activityType;
    }
    if (activity.title) {
        payload[@"title"] = activity.title;
    }
    if (activity.webpageURL) {
        payload[@"webpageURL"] = activity.webpageURL;
    }
    if (activity.userInfo) {
        payload[@"userInfo"] = activity.userInfo;
    }
    if (activity.requiredUserInfoKeys) {
        payload[@"requiredUserInfoKeys"] = activity.requiredUserInfoKeys.allObjects;
    }
    if (activity.keywords) {
        payload[@"keywords"] = activity.keywords.allObjects;
    }
    if (activity.persistentIdentifier) {
        payload[@"persistentIdentifier"] = activity.persistentIdentifier;
    }
    if (activity.targetContentIdentifier) {
        payload[@"targetContentIdentifier"] = activity.targetContentIdentifier;
    }
    if (activity.expirationDate) {
        payload[@"expirationDate"] = activity.expirationDate;
    }
    payload[@"eligibleForHandoff"] = @(activity.eligibleForHandoff);
    payload[@"eligibleForSearch"] = @(activity.eligibleForSearch);
    if (@available(macOS 10.15, *)) {
        // payload[@"eligibleForPrediction"] = @(activity.eligibleForPrediction);
        payload[@"eligibleForPublicIndexing"] = @(activity.eligibleForPublicIndexing);
    }
    if (activity.contentAttributeSet) {
        payload[@"contentAttributeSet"] = activity.contentAttributeSet;
    }

    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:payload requiringSecureCoding:YES error:&error];
    if (data == nil) {
        NSLog(@"Failed to encode NSUserActivity: %@", error);
        return;
    }

    NSString *archivePath = [NSTemporaryDirectory() stringByAppendingPathComponent:@"NSUserActivityArchive.data"];
    BOOL wrote = [data writeToFile:archivePath atomically:YES];
    if (!wrote) {
        NSLog(@"Failed to write encoded NSUserActivity to %@", archivePath);
        return;
    }

    NSLog(@"Encoded NSUserActivity saved to %@", archivePath);
}

@end
