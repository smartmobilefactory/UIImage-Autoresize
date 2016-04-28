//
//  UIImage_MainBundleTests.m
//  UIImage+Autoresize
//
//  Created by kevin delord on 27/04/16.
//  Copyright © 2016 Smart Mobile Factory. All rights reserved.
//

#import <XCTest/XCTest.h>

@interface UIImage (Autoresize)

+ (UIImage * _Nullable)imageNamed:(NSString * _Nonnull)imageName withTransitionSize:(CGSize)size NS_AVAILABLE_IOS(8.0);
+ (UIImage * _Nullable)imageNamed:(NSString * _Nonnull)imageName withTransitionSize:(CGSize)size inBundle:(NSBundle * _Nullable)bundle NS_AVAILABLE_IOS(8.0);

@end

@interface UIImage_MainBundleTests : XCTestCase

@end

@implementation UIImage_MainBundleTests

- (void)testShouldReturnNilFromMainBundleInTestTarget {
	UIImage *image = [UIImage imageNamed:@"test.bg@2x.png"];
	XCTAssert(image != nil);
	XCTAssertNotNil(image);
	UIImage *imageinBundle = [UIImage imageNamed:@"test.bg@2x.png" inBundle:[NSBundle mainBundle] compatibleWithTraitCollection:nil];
	XCTAssert(imageinBundle != nil);
	XCTAssertNotNil(imageinBundle);
}

- (void)testShouldReturnNilWhenUsingMainBundleOnTestTarget {
	UIImage *imageTestBundle = [UIImage imageNamed:@"test.bg.png" withTransitionSize:CGSizeMake(320.0f, 480.0f) inBundle:[NSBundle mainBundle]];
	XCTAssertNil(imageTestBundle);
	UIImage *imageMainBundle = [UIImage imageNamed:@"test.bg.png" withTransitionSize:CGSizeMake(568.0f, 320.0f) inBundle:[NSBundle mainBundle]];
	XCTAssertNil(imageMainBundle);
}

- (void)testShouldReturnNilFromMainBundleInTestTargetWithTransitionSize {
	UIImage *image = [UIImage imageNamed:@"test.bg.png" withTransitionSize:CGSizeMake(320.0f, 480.0f)];
	XCTAssertNil(image);
}

@end
