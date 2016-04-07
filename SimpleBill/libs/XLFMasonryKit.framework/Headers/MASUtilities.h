//
//  MASUtilities.h
//  Masonry
//
//  Created by Jonas Budelmann on 19/08/13.
//  Copyright (c) 2013 Jonas Budelmann. All rights reserved.
//

//#if TARGET_OS_IPHONE

    #import <Foundation/Foundation.h>
    #import <UIKit/UIKit.h>
    #define MAS_VIEW UIView
    #define MASEdgeInsets UIEdgeInsets

    enum {
        MASLayoutPriorityRequired = (NSInteger)UILayoutPriorityRequired,
        MASLayoutPriorityDefaultHigh = (NSInteger)UILayoutPriorityDefaultHigh,
        MASLayoutPriorityDefaultMedium = 500,
        MASLayoutPriorityDefaultLow = (NSInteger)UILayoutPriorityDefaultLow,
        MASLayoutPriorityFittingSizeLevel = (NSInteger)UILayoutPriorityFittingSizeLevel,
    };
    typedef float MASLayoutPriority;

//#elif TARGET_OS_MAC
//
//    #import <AppKit/AppKit.h>
//    #define MAS_VIEW NSView
//    #define MASEdgeInsets NSEdgeInsets
//
//    enum {
//        MASLayoutPriorityRequired = (NSInteger)NSLayoutPriorityRequired,
//        MASLayoutPriorityDefaultHigh = (NSInteger)NSLayoutPriorityDefaultHigh,
//        MASLayoutPriorityDragThatCanResizeWindow = (NSInteger)NSLayoutPriorityDragThatCanResizeWindow,
//        MASLayoutPriorityDefaultMedium = 501,
//        MASLayoutPriorityWindowSizeStayPut = (NSInteger)NSLayoutPriorityWindowSizeStayPut,
//        MASLayoutPriorityDragThatCannotResizeWindow = (NSInteger)NSLayoutPriorityDragThatCannotResizeWindow,
//        MASLayoutPriorityDefaultLow = (NSInteger)NSLayoutPriorityDefaultLow,
//        MASLayoutPriorityFittingSizeCompression = (NSInteger)NSLayoutPriorityFittingSizeCompression,
//    };
//    typedef float MASLayoutPriority;
//
//#endif

/**
 *	Allows you to attach keys to objects matching the variable names passed.
 *
 *  view1.mas_key = @"view1", view2.mas_key = @"view2";
 *
 *  is equivalent to:
 *
 *  MASAttachKeys(view1, view2);
 */
#define MASAttachKeys(...)                                                    \
    NSDictionary *keyPairs = NSDictionaryOfVariableBindings(__VA_ARGS__);     \
    for (id key in keyPairs.allKeys) {                                        \
        id obj = keyPairs[key];                                               \
        NSAssert([obj respondsToSelector:@selector(setMas_key:)],             \
                 @"Cannot attach mas_key to %@", obj);                        \
        [obj setMas_key:key];                                                 \
    }

/**
 *  Used to create object hashes
 *  Based on http://www.mikeash.com/pyblog/friday-qa-2010-06-18-implementing-equality-and-hashing.html
 */
#define MAS_NSUINT_BIT (CHAR_BIT * sizeof(NSUInteger))
#define MAS_NSUINTROTATE(val, howmuch) ((((NSUInteger)val) << howmuch) | (((NSUInteger)val) >> (MAS_NSUINT_BIT - howmuch)))

#define XLFLoadCategory(UNIQUE_NAME) @interface FORCELOAD_##UNIQUE_NAME :NSObject @end @implementation FORCELOAD_##UNIQUE_NAME @end
