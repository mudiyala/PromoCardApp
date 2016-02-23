//
//  ThemeManager.m
//  PromoCard
//
//  Created by Krishna Mudiyala on 22/02/16.
//  Copyright (c) 2016 Krishna Mudiyala. All rights reserved.
//

#import "ThemeManager.h"
#import <sys/utsname.h>

@implementation ThemeManager

+ (BOOL)isIPad
{
    return UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad;
}

+ (BOOL)isIPhone
{
    return UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone;
}


+ (BOOL)isPortrait
{
    UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
    return UIInterfaceOrientationIsPortrait(orientation);
}

+ (UIColor*)headerBarBackgroundColor
{
    return [UIColor colorWithRed:0.0 green:0. blue:0.0 alpha:1.0];
}

+ (UIFont*)navigationBarFont
{
    return [ThemeManager isIPad] ? [UIFont fontWithName:@"HelveticaNeue" size:18] : [UIFont fontWithName:@"HelveticaNeue" size:14];
}

+ (UIFont*)summaryTextFont
{
    return [ThemeManager isIPad] ? [UIFont fontWithName:@"HelveticaNeue" size:20.0] : [UIFont fontWithName:@"HelveticaNeue" size:16.0];
}

+ (UIFont*)buttonTextFont
{
    return [ThemeManager isIPad] ? [UIFont fontWithName:@"HelveticaNeue" size:18.0f] : [UIFont fontWithName:@"Helvetica" size:16.0f];
}

+(UIFont*)footerTextFont
{
    return [ThemeManager isIPad] ? [UIFont fontWithName:@"HelveticaNeue-Thin" size:16.0] : [UIFont fontWithName:@"HelveticaNeue" size:14.0];
}

@end
