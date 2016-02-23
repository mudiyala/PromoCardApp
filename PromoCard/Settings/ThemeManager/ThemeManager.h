//
//  ThemeManager.h
//  PromoCard
//
//  Created by Krishna Mudiyala on 22/02/16.
//  Copyright (c) 2016 Krishna Mudiyala. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface ThemeManager : NSObject

+ (BOOL)isIPad;

+ (BOOL)isIPhone;

+ (BOOL)isPortrait;

+ (UIColor*)headerBarBackgroundColor;

+ (UIFont*)navigationBarFont;

+ (UIFont*)footerTextFont;

+ (UIFont*)summaryTextFont;

+ (UIFont*)buttonTextFont;

@end
