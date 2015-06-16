//
//  FrequencySlideView.h
//  FunctionGenBLE
//
//  Created by Takehisa Oneta on 2015/05/13.
//  Copyright (c) 2015年 Takehisa Oneta. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WaveEditViewController.h"
#import "Defines.h"
#import "Utils.h"

//----------------------------------------------------------------

@protocol FrequencySlideViewDelegate <NSObject>
- (void)didChangeValue:(int32_t)value;
@end

@interface FrequencySlideView : UIView
{
	int32_t		slideNum;
	CGPoint		lastTouchPoint;
}

- (int32_t)min;
- (int32_t)max;
- (int32_t)value;

@property (nonatomic, assign) id<FrequencySlideViewDelegate> delegate;

@end
