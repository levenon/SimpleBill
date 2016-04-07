//
//  SBShareInfo
//  Gemini
//
//  Created by Marike Jave on 14-11-20.
//  Copyright (c) 2014年 Marike Jave. All rights reserved.
//

#import <XLFBaseModelKit/XLFBaseModelKit.h>
#import <UIKit/UIKit.h>

@interface SBShareInfo : XLFBaseModel

@property (nonatomic , copy  ) NSString *des;
@property (nonatomic , copy  ) NSString *url;
@property (nonatomic , copy  ) UIImage  *img;
@property (nonatomic , copy  ) NSString *imgUrl;
@property (nonatomic , copy  ) NSString *title;

@end
