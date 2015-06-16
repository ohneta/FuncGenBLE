//
//  FrequencyTuneView.m
//  FunctionGenBLE
//
//  Created by Takehisa Oneta on 2015/05/13.
//  Copyright (c) 2015年 Takehisa Oneta. All rights reserved.
//

#import "FrequencyTuneView.h"

//----------------------------------------------------------------
//----------------------------------------------------------------

@implementation FrequencyTunePickerView

- (instancetype)initWithFrame:(CGRect)frame
{
	self = [super initWithFrame:frame];
	if (self) {
		self.backgroundColor = [UIColor lightGrayColor];

		khzPickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(2, 2, 68, 160)];
		khzPickerView.delegate = self;
		khzPickerView.dataSource = self;
		khzPickerView.showsSelectionIndicator = YES;
		khzPickerView.backgroundColor = [UIColor clearColor];
		[self addSubview:khzPickerView];

		hzPickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(70, 2, 68, 160)];
		hzPickerView.delegate = self;
		hzPickerView.dataSource = self;
		hzPickerView.showsSelectionIndicator = YES;
		hzPickerView.backgroundColor = [UIColor clearColor];
		[self addSubview:hzPickerView];

		
		UILabel *label;
		label = [[UILabel alloc] initWithFrame:CGRectMake(65, 88, 12, 12)];
		label.backgroundColor = [UIColor clearColor];
		label.textColor = [UIColor blueColor];
		label.font = [UIFont fontWithName:@"AppleGothic" size:12];
		label.textAlignment = NSTextAlignmentCenter;
		label.text = @",";
		[self addSubview:label];

		label = [[UILabel alloc] initWithFrame:CGRectMake(140, 88, 32, 12)];
		label.backgroundColor = [UIColor clearColor];
		label.textColor = [UIColor blueColor];
		label.font = [UIFont fontWithName:@"AppleGothic" size:12];
		label.textAlignment = NSTextAlignmentCenter;
		label.text = @"Hz";
		[self addSubview:label];


		UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
		button.frame = CGRectMake(158, 142, 20, 20);
		UIImage *img = [UIImage imageNamed:@"icon_return"];
		[button setImage:img forState:UIControlStateNormal];
		[button addTarget:self action:@selector(returnButtonHandle:) forControlEvents:UIControlEventTouchUpInside];
		[self addSubview:button];
		
		_delegate = nil;
	}

	return self;
}

- (void)returnButtonHandle:(UIButton *)button
{
	if ([_delegate respondsToSelector:@selector(didClose)]) {
		[_delegate didClose];
	}
}

//----------------------------------------------------------------

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}

//----------------------------------------------------------------
/**
 */
- (uint32_t)getFrequency
{
	return _frequency;
}

- (void)setFrequency:(uint32_t)val
{
	_frequency = val;
	
	{
		[khzPickerView selectRow:((_frequency / 100000) % 10) inComponent:0 animated:YES];
		[khzPickerView selectRow:((_frequency / 10000) % 10) inComponent:1 animated:YES];
		[khzPickerView selectRow:((_frequency / 1000) % 10) inComponent:2 animated:YES];

		[hzPickerView selectRow:((_frequency / 100) % 10) inComponent:0 animated:YES];
		[hzPickerView selectRow:((_frequency / 10) % 10) inComponent:1 animated:YES];
		[hzPickerView selectRow:(_frequency % 10) inComponent:2 animated:YES];
	}
	if ([_delegate respondsToSelector:@selector(didChangeFrequencyValue:)]) {
		[_delegate didChangeFrequencyValue:_frequency];
	}
}

//----------------------------------------------------------------
//----------------------------------------------------------------
#pragma mark -
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
	return 3;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
	return 10;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component
{
	return 8.0;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
	return 40.0;
}

- (NSAttributedString *)pickerView:(UIPickerView *)pickerView attributedTitleForRow:(NSInteger)row forComponent:(NSInteger)component
{
	NSDictionary *stringAttributes = @{	NSForegroundColorAttributeName : [UIColor blueColor],
										NSFontAttributeName : [UIFont systemFontOfSize:10.0f]	};
	NSAttributedString *tmp = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%d", (int)row] attributes:stringAttributes];
	return tmp;
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
	UILabel *label = (id)view;
	
	if (!label) {
		CGSize sz = [pickerView rowSizeForComponent:component];
		label = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, 0.0f, sz.width, sz.height)];
	}
	
	label.font = [UIFont systemFontOfSize:12];
	label.text = [NSString stringWithFormat:@"%d", (int)row];
	
	return label;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
	NSInteger khzRow3 = [khzPickerView selectedRowInComponent:0];
	NSInteger khzRow2 = [khzPickerView selectedRowInComponent:1];
	NSInteger khzRow1 = [khzPickerView selectedRowInComponent:2];
	NSInteger hzRow3  = [hzPickerView selectedRowInComponent:0];
	NSInteger hzRow2  = [hzPickerView selectedRowInComponent:1];
	NSInteger hzRow1  = [hzPickerView selectedRowInComponent:2];
	
	[self setFrequency:(khzRow3 * 100000 + khzRow2 * 10000 +  khzRow1 * 1000 + hzRow3 * 100 + hzRow2 * 10 +  hzRow1)];
}

/*
 - (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
 {
	if (component == 3)
 return @",";
 
	return [NSString stringWithFormat:@"%d", (int)row];
 }
 */

//----------------------------------------------------------------

@end
