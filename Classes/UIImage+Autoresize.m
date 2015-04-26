//
//  UIImage+Autoresize.m
//  UIImage+Autoresize
//
//  Created by kevin delord on 24/04/14.
//  Copyright (c) 2014 Kevin Delord. All rights reserved.
//

#import "UIImage+Autoresize.h"
#import <objc/runtime.h>

#define __K_DEBUG_LOG_UIIMAGE_AUTORESIZE_ENABLED__      false

@implementation UIImage (Autoresize)

#pragma mark - UIImage Initializer

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Method origImageNamedMethod = class_getClassMethod(self.class, @selector(imageNamed:));
        method_exchangeImplementations(origImageNamedMethod, class_getClassMethod(self.class, @selector(dynamicImageNamed:)));
    });
}

+ (NSString *)verticalExtensionForHeight:(CGFloat)h width:(CGFloat)w {
    // Get the current device scale
    CGFloat scale = [UIScreen mainScreen].scale;

    if (__K_DEBUG_LOG_UIIMAGE_AUTORESIZE_ENABLED__) {
        NSLog(@"---------------  VERTICAL  ----------------------");
        NSLog(@"h: %f", h);
        NSLog(@"w: %f", w);
        NSLog(@"scale: %f", scale);
        NSLog(@"-------------------------------------------------");
    }

    // generate the current valid file extension depending on the current device screen size.
    NSString *extension = @"";
    if (scale == 3.f) {
        extension = @"@3x";    // iPhone 6+
    } else if (scale == 2.f && h == 568.0f && w == 320.0f) {
        extension = @"-568h@2x";    // iPhone 5, 5S, 5C
    } else if (scale == 2.f && h == 667.0f && w == 375.0f) {
        extension = @"-667h@2x";    // iPhone 6
    } else if (scale == 2.f && h == 480.0f && w == 320.0f) {
        extension = @"@2x";         // iPhone 4, 4S
    } else if (scale == 1.f && h == 1024.0f && w == 768.0f) {
        extension = @"-512h";       // iPad Mini, iPad 2, iPad 1
    } else if (scale == 2.f && h == 1024.0f && w == 768.0f) {
        extension = @"-1024h@2x";   // iPad Mini 3, iPad Mini 2, iPad Air, iPad Air 2
    }
    return extension;
}

+ (NSString *)horizontalExtensionForHeight:(CGFloat)h width:(CGFloat)w {
    // Get the current device scale
    CGFloat scale = [UIScreen mainScreen].scale;

    if (__K_DEBUG_LOG_UIIMAGE_AUTORESIZE_ENABLED__) {
        NSLog(@"---------------  HORIZONTAL  --------------------");
        NSLog(@"h: %f", h);
        NSLog(@"w: %f", w);
        NSLog(@"scale: %f", scale);
        NSLog(@"-------------------------------------------------");
    }

    // Generate the current valid file extension depending on the current device screen size.
    NSString *extension = @"";
    if (scale == 3.f) {
        extension = @"-l@3x";    // iPhone 6+
    } else if (scale == 2.f && w == 568.0f && h == 320.0f) {
        extension = @"-320h-l@2x";    // iPhone 5, 5S, 5C
    } else if (scale == 2.f && w == 667.0f && h == 375.0f) {
        extension = @"-375h-l@2x";    // iPhone 6
    } else if (scale == 2.f && w == 480.0f && h == 320.0f) {
        extension = @"-l@2x";    // iPhone 4, 4S
    } else if (scale == 1.f && w == 1024.0f && h == 768.0f) {
        extension = @"-384h-l";       // iPad Mini, iPad 2, iPad 1
    } else if (scale == 2.f && w == 1024.0f && h == 768.0f) {
        extension = @"-768h-l@2x";   // iPad Mini 3, iPad Mini 2, iPad Air, iPad Air 2
    }
    return extension;
}

+ (UIImage *)dynamicImageNamed:(NSString *)imageName {
    // only change the name if no '@2x' or '@3x' are specified
    if ([imageName rangeOfString:@"@"].location == NSNotFound) {

        UIInterfaceOrientation interfaceOrientation = [UIApplication sharedApplication].statusBarOrientation;
        CGSize size = [UIScreen mainScreen].bounds.size;
        // less than
        if ([[[UIDevice currentDevice] systemVersion] compare:@"8.0" options:NSNumericSearch] == NSOrderedAscending) {
            if (interfaceOrientation == UIInterfaceOrientationLandscapeLeft || interfaceOrientation == UIInterfaceOrientationLandscapeRight) {
                CGFloat temp = size.width;
                size.width = size.height;
                size.height = temp;
            }
        }
        return [self imageNamed:imageName withTransitionSize:size];
    }

    // otherwise returns an UIImage with the original filename.
    return [UIImage dynamicImageNamed:imageName];
}

+ (UIImage *)imageNamed:(NSString *)imageName withTransitionSize:(CGSize)size {
    // only change the name if no '@2x' or '@3x' are specified
    if ([imageName rangeOfString:@"@"].location == NSNotFound) {

        NSString *extension = @"";
        if (size.height >= size.width) {
            extension = [self verticalExtensionForHeight:size.height width:size.width];
        } else {
            extension = [self horizontalExtensionForHeight:size.height width:size.width];
        }

        // add the extension to the image name
        NSRange dot = [imageName rangeOfString:@"."];
        NSMutableString *imageNameMutable = [imageName mutableCopy];
        if (dot.location != NSNotFound)
            [imageNameMutable insertString:extension atIndex:dot.location];
        else
            [imageNameMutable appendString:extension];

        // if exist returns the corresponding UIImage
        if ([[NSBundle mainBundle] pathForResource:imageNameMutable ofType:@""]) {
            return [UIImage dynamicImageNamed:imageNameMutable];
        }
    }
    // otherwise returns an UIImage with the original filename.
    return [UIImage dynamicImageNamed:imageName];
}

@end
