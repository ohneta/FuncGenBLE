//
//  WavefFormView.m
//  FunctionGenBLE
//
//  Created by Takehisa Oneta on 2015/05/13.
//  Copyright (c) 2015年 Takehisa Oneta. All rights reserved.
//

#import "WaveFormView.h"

#import "Defines.h"
#import "Utils.h"

//----------------------------------------------------------------
//----------------------------------------------------------------

@implementation WaveFormView


- (instancetype)initWithFrame:(CGRect)frame
{
	self = [super initWithFrame:frame];
	if (self) {
		//waveformRect = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
		
		waveFormViewMode = WaveFormViewMode_WaveEdit;
		self.userInteractionEnabled = YES;

		// 一本指のダブルタップジェスチャを有効にする
		{
			singleFingerDoubleTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleDoubleTap:)];
			singleFingerDoubleTapGesture.numberOfTapsRequired = 2;
			[self addGestureRecognizer:singleFingerDoubleTapGesture];
		}
	}
	return self;
}

//----------------------------------------------------------------

- (void)setWaveBuffer:(double *)buffer
{
	_waveBuffer = buffer;
}

- (double *)getWaveBuffer
{
	return _waveBuffer;
}

//----------------------------------------------------------------

- (void)setWaveFormRect:(CGRect)rect
{
	self.frame = rect;
	//[self setNeedsDisplay];
}

//----------------------------------------------------------------

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
	
	NSLog(@"WaveFormView: drawRect");
	CGContextRef context = UIGraphicsGetCurrentContext();

	CGRect drawRect = CGRectMake(rect.origin.x, rect.origin.y,rect.size.width, rect.size.height);
	if (waveFormViewMode == WaveFormViewMode_WaveEdit) {
		CGContextSetRGBFillColor(context, 0.0f, 0.0f, 0.0f, 0.0f);
	} else if (waveFormViewMode == WaveFormViewMode_FrequencyEdit) {
		CGContextSetRGBFillColor(context, 0.4f, 0.4f, 0.7f, 0.7f);
	}
	CGContextFillRect(context, drawRect);
	CGContextStrokePath(context);

	[self drawWaveForm:context];
	CGContextStrokePath(context);
}

//----------------------------------------------------------------
/**
 * x = 0〜WAVE_BUFFER_SIZE を waveformRect.origin.x〜 + waveformRect.origin.x + waveformRect.size.width に変換する
 */
- (CGFloat)changeX:(CGFloat)x
{
	return self.frame.origin.x + (x * self.frame.size.width / WAVE_BUFFER_SIZE);
}

/**
 * y = -1〜1 を (waveformRect.origin.y + waveformRect.size.height) 〜 waveformRect.origin.y に変換する
 */
- (CGFloat)changeY:(CGFloat)y
{
	CGFloat yy = (y + 1.0) / 2.0;
	return self.frame.origin.y + self.frame.size.height - (yy * self.frame.size.height);
}

//----------------------------------------------------------------
/**
 * 波形描画
 */
- (void)drawWaveForm:(CGContextRef)context
{
	CGContextSetStrokeColorWithColor(context, UIColor.yellowColor.CGColor);
	CGContextSetLineWidth(context, 1.0);

	CGFloat fx = [self changeX:0];
	CGFloat fy = [self changeY:_waveBuffer[0]];
	CGContextMoveToPoint(context, fx, fy);
	
	for (int x = 1; x < WAVE_BUFFER_SIZE; x++) {
		fx = [self changeX:x];
		fy = [self changeY:_waveBuffer[x]];
		CGContextAddLineToPoint(context, fx, fy);

		//NSLog(@"%f:%f", fx, fy);
	}
	CGContextStrokePath(context);
}

//----------------------------------------------------------------
//----------------------------------------------------------------
/**
 *
 */
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
	if (waveFormViewMode != WaveFormViewMode_WaveEdit) {
		return;
	}

	WaveBufferOne	one;

	UITouch *touch = [touches anyObject];
	CGPoint location = [touch locationInView:self];

	if ([self bufferPointFromViewPoint:location bufferPoint:&one]) {
NSLog(@"touchesBegan: x:%d y:%f", one.x, one.y);
		//_waveBuffer[one.x] = one.y;
		lastOne = one;
		//[self setNeedsDisplay];
	}

	lastTouchPoint = location;
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
	if (waveFormViewMode != WaveFormViewMode_WaveEdit) {
		return;
	}

	WaveBufferOne	one;

	UITouch *touch = [touches anyObject];
	CGPoint location = [touch locationInView:self];
	
	if ([self bufferPointFromViewPoint:location bufferPoint:&one]) {
		//NSLog(@"touchesMoved: x:%d y:%f", one.x, one.y);
		_waveBuffer[one.x] = one.y;

		{
			// one.x と lastOne.xが連続でない場合、その間にある値を補完する
			if (abs(one.x - lastOne.x) >= 1) {
				if (one.x < lastOne.x) {
					for (int x = one.x; x < lastOne.x; x++) {
						_waveBuffer[x] = one.y;
					}
				} else if (one.x > lastOne.x) {
					for (int x = lastOne.x; x < one.x; x++) {
						_waveBuffer[x] = one.y;
					}
				}
			}
		}
		
		lastOne = one;
		[self setNeedsDisplay];
	}


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

- (BOOL)bufferPointFromViewPoint:(CGPoint)point bufferPoint:(WaveBufferOne *)bufferPoint
{
	if ((point.x < self.frame.origin.x) ||
		(self.frame.origin.x + self.frame.size.width < point.x)	) {
		return NO;
	}
	if ((point.y < self.frame.origin.y) ||
		(self.frame.origin.y + self.frame.size.height < point.y)	) {
		return NO;
	}
	
	int x = (point.x - self.frame.origin.x) * (self.frame.size.width / WAVE_BUFFER_SIZE);
	double y = ((point.y - self.frame.origin.y) / self.frame.size.height) * -2.0 + 1.0;

	bufferPoint->x = x;
	bufferPoint->y = y;

	return YES;
}


//----------------------------------------------------------------
//----------------------------------------------------------------

- (void)useFrequencyGestureRecognizers
{
	panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanGesture:)];
	panGesture.minimumNumberOfTouches = 1;
	panGesture.maximumNumberOfTouches = 1;
	[self addGestureRecognizer:panGesture];
}

- (void)unuseFrequencyGestureRecognizers
{
	[self removeGestureRecognizer:panGesture];
}

- (void)handleSingleDoubleTap:(id)sender
{
	NSLog(@"double tap.");
	
	if (waveFormViewMode == WaveFormViewMode_WaveEdit) {
		// 周波数設定モードに入る
		waveFormViewMode = WaveFormViewMode_FrequencyEdit;
		[self useFrequencyGestureRecognizers];

	} else if (waveFormViewMode == WaveFormViewMode_FrequencyEdit) {
		// 波形設定モードに入る
		waveFormViewMode = WaveFormViewMode_WaveEdit;
		[self unuseFrequencyGestureRecognizers];
	}

	[self setNeedsDisplay];
}

- (void)handlePanGesture:(id)sender
{
	UIPanGestureRecognizer *pan = (UIPanGestureRecognizer*)sender;
	CGPoint point = [pan translationInView:self];
	//CGPoint velocity = [pan velocityInView:self];

	static uint32_t frequency = 440;	// TODO: !!
	static CGPoint beginPoint;
	if (pan.state == UIGestureRecognizerStateBegan) {
		if ([_delegate respondsToSelector:@selector(requestFrequencyValue)]) {
			frequency = [_delegate requestFrequencyValue];
		}
		beginPoint = point;

	} else if ((pan.state == UIGestureRecognizerStateChanged) || (pan.state == UIGestureRecognizerStateEnded)) {
		int hzF1 = 0;
		int hzF2 = 0;
		if (fabs(beginPoint.x - point.x) < fabs(beginPoint.y - point.y)) {
			hzF1 = (int)point.y;
		} else {
			hzF2 = (int)point.x;
		}
		int hzF = hzF1 * -100 + hzF2;

		if (pan.state == UIGestureRecognizerStateChanged) {
			if ([_delegate respondsToSelector:@selector(changeFrequencyValue:)]) {
				[_delegate changeFrequencyValue:(frequency + hzF)];
			}
		} else if (pan.state == UIGestureRecognizerStateEnded) {
			if ([_delegate respondsToSelector:@selector(didChangeFrequencyValue:)]) {
				[_delegate didChangeFrequencyValue:(frequency + hzF)];
			}
		}
	}

}

@end
