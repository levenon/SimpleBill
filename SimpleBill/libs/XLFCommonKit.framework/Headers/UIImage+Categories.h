//
//  UIImage+Extended.h
//  XLFCommonKit
//
//  Created by Marike Jave on 13-6-10.
//  Copyright (c) 2014年 Marike Jave. All rights reserved.
//
#import <UIKit/UIKit.h>

@interface UIImage (Extended)

+(UIImage *)imageWithSize:(CGSize)imageSize imageColor:(UIColor *)imageColor;

// 将UIImage缩放到指定大小尺寸
- (UIImage *)scaleToSize:(CGSize)size;
- (UIImage *)scaleToSize:(CGSize)size stretch:(BOOL)stretch;

- (UIImage *)subImage:(CGRect)rect;

+ (UIImage *)mergeImage:(UIImage *)backgroundImgae point:(CGPoint)point frontImage:(UIImage *)frontImage;

- (UIImage *)mergeImageWithPoint:(CGPoint)point image:(UIImage *)image;

- (UIImage *)mergeImageWithFrame:(CGRect)frame image:(UIImage *)image;

+ (UIImage *)superposition:(UIImage *)image withInsets:(UIEdgeInsets)insets andShadowImage:(UIImage *)shadowImage;

+ (UIImage *)imageFromLabel:(UILabel *)label;

- (UIImage *)mergeImageWithLabel:(UILabel *)label inRect:(CGRect)rect;

- (UIImage *)mergeImageWithText:(NSString *)text color:(UIColor *)color font:(UIFont *)font inRect:(CGRect)rect;

+ (NSInteger)RGBAFromUIColor:(UIColor *)color;

+ (UIImage *)mergeImageWithSize:(CGSize)size point1:(CGPoint)point1 image1:(UIImage *)image1 point2:(CGPoint)point2 image2:(UIImage *)image2;

+ (UIImage *)mergeImageWithSize:(CGSize)size frame1:(CGRect)frame1 image1:(UIImage *)image1 frame2:(CGRect)frame2 image2:(UIImage *)image2;

+ (UIImage *)mergeImageWithSize:(CGSize)size frame1:(CGRect)frame1 image1File:(NSString *)image1File frame2:(CGRect)frame2 image2File:(NSString *)image2File;

+ (UIImage *)imageWithSize:(CGSize)imageSize color:(UIColor *)color;

+ (UIImage *)imageWithImageFilePath:(NSString *)imageFilePath inset:(UIEdgeInsets)insets;

+ (UIImage *)image:(UIImage *)image inset:(UIEdgeInsets)insets;

+ (UIImage *)imageWithImageName:(NSString*)imageName insets:(UIEdgeInsets)insets;

+ (UIImage *)imageWithImage:(UIImage *)image insets:(UIEdgeInsets)insets;

+ (UIImage *)imageWithUIColor:(UIColor*)color;

+ (UIImage *)bundleImageName:(NSString *)imageName;

//图片剪切
- (UIImage *)cutImageWithRadius:(int)radius;

+ (UIImage *)screenBlurImage;

+ (UIImage *)applyLightEffect:(UIImage *)sourceImage;

+ (UIImage *)applyExtraLightEffect:(UIImage *)sourceImage;

+ (UIImage *)applyDarkEffect:(UIImage *)sourceImage;

+ (UIImage *)applyTintEffectWithColor:(UIColor *)tintColor sourceImage:(UIImage *)sourceImage;

+ (UIImage *)applyBlurWithRadius:(CGFloat)blurRadius
                       tintColor:(UIColor *)tintColor
           saturationDeltaFactor:(CGFloat)saturationDeltaFactor
                       maskImage:(UIImage *)maskImage
                     sourceImage:(UIImage *)sourceImage;

+ (UIImage *)videoThumbImage:(NSString *)videoUrl;
+ (UIImage *)audioThumbImage:(NSString *)songUrl;

@end
