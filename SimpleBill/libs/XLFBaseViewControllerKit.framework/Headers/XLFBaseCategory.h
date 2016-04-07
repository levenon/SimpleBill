//
//  XLFBaseCategory.h
//  XLFCommonKit
//
//  Created by Marike Jave on 15/3/18.
//  Copyright (c) 2015年 Marike Jave. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface UINavigationController (XLFBaseViewControllerKit)

@property(strong, nonatomic, readonly) UIViewController*    evVisibleViewController;
@property(assign, nonatomic, readonly) CGRect               evNavigationBarFrame;
@property(assign, nonatomic, readonly) CGRect               evTabBarFrame;
@property(assign, nonatomic, readonly) CGRect               evToolBarFrame;

@end

@interface UITabBarController (XLFBaseViewControllerKit)

@property(strong, nonatomic, readonly) UIViewController*    evVisibleViewController;
@property(assign, nonatomic, readonly) CGRect               evNavigationBarFrame;
@property(assign, nonatomic, readonly) CGRect               evTabBarFrame;
@property(assign, nonatomic, readonly) CGRect               evToolBarFrame;

@end

@interface UIViewController (XLFBaseViewControllerKit)<UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property(strong, nonatomic, readonly) UIViewController*    evVisibleViewController;
@property(assign, nonatomic, readonly) CGRect               evNavigationBarFrame;
@property(assign, nonatomic, readonly) CGRect               evTabBarFrame;
@property(assign, nonatomic, readonly) CGRect               evToolBarFrame;

- (void)efBack;

- (void)efShowImagePickerWithSourceType:(UIImagePickerControllerSourceType)sourceType
                          allowsEditing:(BOOL)allowsEditing;;

- (void)efShowCameraWithCaptureMode:(UIImagePickerControllerCameraCaptureMode)cameraCaptureMode
                        qualityType:(UIImagePickerControllerQualityType)qualityType
                       cameraDevice:(UIImagePickerControllerCameraDevice)cameraDevice
                    cameraFlashMode:(UIImagePickerControllerCameraFlashMode)cameraFlashMode
                      allowsEditing:(BOOL)allowsEditing;

- (void)efRefresh;

@end

@interface UIView(XLFBaseViewControllerKit)

@property(strong, nonatomic, readonly) UIViewController*    evVisibleViewController;
@property(assign, nonatomic, readonly) CGRect               evNavigationBarFrame;
@property(assign, nonatomic, readonly) CGRect               evTabBarFrame;
@property(assign, nonatomic, readonly) CGRect               evToolBarFrame;


- (void)efRefresh;

@end

@interface NSObject(XLFBaseViewControllerKit)

@property(strong, nonatomic, readonly) UIViewController*    evVisibleViewController;
@property(assign, nonatomic, readonly) CGRect               evNavigationBarFrame;
@property(assign, nonatomic, readonly) CGRect               evTabBarFrame;
@property(assign, nonatomic, readonly) CGRect               evToolBarFrame;

- (void)efDeregisterNotification;

- (void)efRefresh;

@end
