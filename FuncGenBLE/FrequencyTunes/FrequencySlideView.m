//
//  FrequencySlideView.m
//  FunctionGenBLE
//
//  Created by Takehisa Oneta on 2015/05/13.
//  Copyright (c) 2015年 Takehisa Oneta. All rights reserved.
//

#import "FrequencySlideView.h"

#import "Defines.h"
#import "Utils.h"

//----------------------------------------------------------------
//----------------------------------------------------------------

@implementation FrequencySlideView


- (instancetype)initWithFrame:(CGRect)frame
{
	self = [super initWithFrame:frame];
	if (self) {
		slideNum = 50;
	}
	return self;
}

//----------------------------------------------------------------
//----------------------------------------------------------------
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
	
	CGContextRef context = UIGraphicsGetCurrentContext();
	{
		CGRect leftBarRect = rect;
		leftBarRect.size.width = slideNum;
		
		CGContextSetRGBFillColor(context, 0.0f, 1.0f, 0.0f, 1.0f);
		CGContextFillRect(context, leftBarRect);
		CGContextStrokePath(context);
	}
	{
		CGRect rightBarRect = rect;
		rightBarRect.origin.x = slideNum;
		rightBarRect.size.width = self.frame.size.width - slideNum;

		CGContextSetRGBFillColor(context, 0.0f, 0.0f, 1.0f, 1.0f);
		CGContextFillRect(context, rightBarRect);
		CGContextStrokePath(context);
	}

	//NSLog(@"FrequencySlideView: leftBarRect : %@", NSStringFromCGRect(leftBarRect));
	//NSLog(@"FrequencySlideView: rightBarRect: %@", NSStringFromCGRect(rightBarRect));
}

//----------------------------------------------------------------
//----------------------------------------------------------------
/**
 *
 */
- (void)changeSlideNumValue:(int32_t)value
{
	slideNum = value;
	if ([_delegate respondsToSelector:@selector(didChangeValue:)]) {
		[_delegate didChangeValue:slideNum];
	}
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
	UITouch *touch = [touches anyObject];
	CGPoint location = [touch locationInView:self];

	//NSLog(@"FrequencySlideView - touchesBegan:%@", NSStringFromCGPoint(location));

	int32_t x = (int32_t)location.x;
	if (x > self.frame.size.width) {
		x = self.frame.size.width;
	}
	if (x < 0) {
		x = 0;
	}
	[self changeSlideNumValue:x];
	[self setNeedsDisplay];
	
	lastTouchPoint = location;
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
	UITouch *touch = [touches anyObject];
	CGPoint location = [touch locationInView:self];
	
	//NSLog(@"FrequencySlideView - touchesMoved:%@", NSStringFromCGPoint(location));
	
	int32_t x = (int32_t)location.x;
	if (x > self.frame.size.width) {
		x = self.frame.size.width;
	}
	if (x < 0) {
		x = 0;
	}
	[self changeSlideNumValue:x];
	[self setNeedsDisplay];

	lastTouchPoint = location;
}
/*
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
	WaveBufferOne	one;

	UITouch *touch = [touches anyObject];
	CGPoint location = [touch locationInView:self];
	if ([self bufferPointFromViewPoint:location bufferPoint:&one]) {
		NSLog(@"touchesEnded: x:%f y:%f = x:%d y:%f", location.x, location.y, one.x, one.y);
	}
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
	WaveBufferOne	one;

	UITouch *touch = [touches anyObject];
	CGPoint location = [touch locationInView:self];
	NSLog(@"touchesCancelled: x:%f y:%f", location.x, location.y);
	
	if ([self bufferPointFromViewPoint:location bufferPoint:&one]) {
		NSLog(@"touchesEnded: x:%f y:%f = x:%d y:%f", location.x, location.y, one.x, one.y);
	}
}
*/

//----------------------------------------------------------------
- (int32_t)min
{
	return 0;
}

- (int32_t)max
{
	return self.frame.size.width;
}

- (int32_t)value
{
	return slideNum;
}

//----------------------------------------------------------------

@end
