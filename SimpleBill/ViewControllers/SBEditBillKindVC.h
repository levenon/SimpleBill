//
//  SBEditBillKindVC.h
//  SimpleBill
//
//  Created by Marike Jave on 15/4/5.
//  Copyright (c) 2015年 Marike Jave. All rights reserved.
//

#import "SBBaseModalViewController.h"
#import "SBConstants.h"

@class SBEditBillKindVC;
@class SBBillKind;

@protocol SBEditBillKindVCDelegate <NSObject>

- (void)epEditBillKindVC:(SBEditBillKindVC*)selector billKind:(SBBillKind*)billKind;

@end

@interface SBEditBillKindVC : SBBaseModalViewController

@property(nonatomic, assign) id<SBEditBillKindVCDelegate> evDelegate;

@property(nonatomic, strong) SBBillKind *evBillKind;

@property(nonatomic, assign) SBEditType evEditType;

@property(nonatomic, strong, readonly) XLFFormTextField *evtxfName;

- (BOOL)efSave;

@end
