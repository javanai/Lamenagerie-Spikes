//
//  DrawingIpadAppDelegate.h
//  DrawingIpad
//
//  Created by javanai on 1/8/11.
//  Copyright Javanais 2011. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RootViewController;

@interface DrawingIpadAppDelegate : NSObject <UIApplicationDelegate> {
	UIWindow			*window;
	RootViewController	*viewController;
}

@property (nonatomic, retain) UIWindow *window;

@end
