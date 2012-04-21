//
//  ESAppDelegate.m
//  iOSFontList
//
//  Created by Elf Sundae on 4/21/12.
//  Copyright (c) 2012 www.0x123.com. All rights reserved.
//

#import "ESAppDelegate.h"
#import "FontListViewController.h"

@implementation ESAppDelegate

@synthesize window = _window;

- (void)dealloc
{
    [_window release];
    [super dealloc];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
    self.window.backgroundColor = [UIColor blackColor];
    [self.window makeKeyAndVisible];
    FontListViewController *fontController = [[FontListViewController alloc] init];
    self.window.rootViewController = fontController;
    [fontController release];
    return YES;
}


@end
