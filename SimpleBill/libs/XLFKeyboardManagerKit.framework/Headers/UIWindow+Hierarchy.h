//
//  UIWindow+Hierarchy.h
// https://github.com/hackiftekhar/IQKeyboardManager
// Copyright (c) 2013-14 Iftekhar Qurashi.
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

#import <UIKit/UIKit.h>

@class UIViewController;

@interface UIWindow (Hierarchy)

/*!
    @method topMostController
 
    @return Returns the current Top Most ViewController in hierarchy.
 */
@property(strong, nonatomic, readonly) UIViewController* topMostController;

/*!
    @method currentViewController
 
    @return Returns the topViewController in stack of topMostController.
 */
//@property(strong, nonatomic, readonly) UIViewController* currentViewController;

@end

@interface UIViewController (evVisibleViewController)

@property(strong, nonatomic, readonly) UIViewController* evVisibleViewController;

@end

@interface UINavigationController (evVisibleViewController)

@property(strong, nonatomic, readonly) UIViewController* evVisibleViewController;

@end

@interface UITabBarController (evVisibleViewController)

@property(strong, nonatomic, readonly) UIViewController* evVisibleViewController;

@end

@interface NSObject(evVisibleViewController)

@property(strong, nonatomic, readonly) UIViewController* evVisibleViewController;

@property(strong, nonatomic, readonly) UIView* textInputContainer;

@end

@interface UIView(evVisibleViewController)

@property(strong, nonatomic, readonly) UIViewController* evVisibleViewController;
@property(strong, nonatomic, readonly) UIView* textInputContainer;

@end

@interface UITextField(evVisibleViewContent)

@property(strong, nonatomic) UIView* textInputContainer;

@end

@interface UITextView(evVisibleViewContent)

@property(strong, nonatomic) UIView* textInputContainer;

@end