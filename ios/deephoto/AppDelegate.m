/**
 * Copyright (c) 2015-present, Facebook, Inc.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 */

#import "AppDelegate.h"
#import "VCARViewManager.h"
#import "deephoto-Swift.h"

#import <React/RCTBundleURLProvider.h>
#import <React/RCTRootView.h>
#import <ARKit/ARKit.h>

@implementation AppDelegate

RCTRootView *rootView;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
  if (!ARWorldTrackingConfiguration.isSupported) {
    printf("AR Not supported");
  }
  
  NSURL *jsCodeLocation;

  #ifdef DEBUG
    jsCodeLocation = [[RCTBundleURLProvider sharedSettings] jsBundleURLForBundleRoot:@"index" fallbackResource:nil];
  #else
    jsCodeLocation = [[NSBundle mainBundle] URLForResource:@"main" withExtension:@"jsbundle"];
  #endif
  
  self.rootView = [[RCTRootView alloc] initWithBundleURL:jsCodeLocation
                                                      moduleName:@"deephoto"
                                               initialProperties:nil
                                                   launchOptions:launchOptions];
  self.rootView.backgroundColor = [[UIColor alloc] initWithRed:1.0f green:1.0f blue:1.0f alpha: 0.0f];
  
//  VCARViewManager

//  UIViewController *rootViewController = [UIViewController new];
//  rootViewController.view = rootView;
  self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
  
  ViewController* arViewController = [VCARViewManager sharedInstance];
  self.window.rootViewController = arViewController;
  
  [self.window makeKeyAndVisible];
  
  return YES;
}

@end
