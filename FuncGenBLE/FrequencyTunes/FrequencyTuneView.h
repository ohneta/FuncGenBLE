//
//  FrequencyTuneView.h
//  FunctionGenBLE
//
//  Created by Takehisa Oneta on 2015/05/13.
//  Copyright (c) 2015年 Takehisa Oneta. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Defines.h"
#import "Utils.h"

//----------------------------------------------------------------
@protocol FrequencyTunePickerViewDelegate <NSObject>
- (void)didChangeFrequencyValue:(int32_t)value;
- (void)didClose;
@end

//----------------------------------------------------------------

@interface FrequencyTunePickerView : UIView <UIPickerViewDelegate, UIPickerViewDataSource>
{
	UIPickerView	*khzPickerView;
	UIPickerView	*hzPickerView;
}

@property (nonatomic, assign) id<FrequencyTunePickerViewDelegate> delegate;

@property	uint32_t frequency;

@end
