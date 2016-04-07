//
//  XLFBaseModel.h
//  Marike Jave
//
//  Created by XLF on 14-4-3.
//  Copyright (c) 2014年 XLF. All rights reserved.
//

#import <Foundation/Foundation.h>

#define Property(a)   @synthesize a=_##a

@protocol XLFBaseModelInterface <NSObject>

@required

@property (nonatomic , copy , setter = setAttributes:) NSDictionary* dictionary;

+ (id)model;
+ (id)modelWithAttributes:(NSDictionary* )attributes;

- (id)initWithAttributes:(NSDictionary* )attributes;

@optional

+ (Class)superEndClass;

//if this model has contained model array , this method must be overrided.
- (Class)modelClassWithPropertyNameForArray:(NSString*)propertyName;

@end

@interface NSObject (XLFBaseModel)

- (id)modelWithClass:(Class)_class;
- (id)modelWithClass:(Class)_class attribute:(NSDictionary*)attribute;

- (NSArray*)modelsWithClass:(Class)_class;
- (NSArray*)modelsWithClass:(Class)_class attributes:(NSArray*)attributes;

@end

@interface NSObject (RunTime)<XLFBaseModelInterface>

@property (nonatomic , copy , setter = setAttributes:) NSDictionary* dictionary;

//+ (id)superEndClass;

+ (id)model;
+ (id)modelWithAttributes:(NSDictionary* )attributes;

- (id)initWithAttributes:(NSDictionary* )attributes;

@end

//
//
//@interface NSNull (XLFBaseModel)
//
//- (id)modelWithClass:(Class)_class;
//- (id)modelWithClass:(Class)_class attribute:(NSDictionary*)attribute;
//
//- (NSArray*)modelsWithClass:(Class)_class;
//- (NSArray*)modelsWithClass:(Class)_class attributes:(NSArray*)attributes;
//
//@end

@interface NSDictionary (XLFBaseModel)

- (id)modelWithClass:(Class)_class;
+ (id)modelWithClass:(Class)_class attribute:(NSDictionary*)attribute;

@end

@interface NSDictionary (UnknownClass)

- (id)modelWithUnKnownClass:(Class)unknownClass;
+ (id)modelWithUnKnownClass:(Class)unknownClass attribute:(NSDictionary*)attribute;

@end

@interface NSArray (XLFBaseModel)

- (NSArray*)modelsWithClass:(Class)_class;
+ (NSArray*)modelsWithClass:(Class)_class attributes:(NSArray*)attributes;

@end

@interface XLFBaseModel : NSObject<XLFBaseModelInterface>

@property (nonatomic , copy , setter = setAttributes:) NSDictionary* dictionary;

+ (id)superEndClass;

+ (id)model;
+ (id)modelWithAttributes:(NSDictionary* )attributes;

- (id)init;
- (id)initWithAttributes:(NSDictionary* )attributes;

//if this model has contained model array , this method must be overrided.
- (Class)modelClassWithPropertyNameForArray:(NSString*)propertyName;

@end

@interface XLFBaseModel (Coding)<NSCoding>

- (id)initWithCoder:(NSCoder *)aDecoder;
- (void)encodeWithCoder:(NSCoder *)aCoder;

@end

@interface XLFBaseModel (Copying)<NSCopying>

- (id)copyWithZone:(NSZone*)zone;

@end

@interface XLFBaseModel (MutableCopying)<NSMutableCopying>

- (id)mutableCopyWithZone:(NSZone*)zone;

@end

@interface XLFBaseModel (KVO)

- (void)registerKVO;
- (void)unregisterKVO;

@end

@interface XLFBaseModel (KV)

- (void)removeObjectForKey:(NSString*)aKey;
- (void)setObject:(id)anObject forKey:(NSString*)aKey;
- (id)objectForKey:(NSString*)aKey;

@end


