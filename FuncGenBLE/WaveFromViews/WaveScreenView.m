//
//  WaveScreenView.m
//  FunctionGenBLE
//
//  Created by Takehisa Oneta on 2015/05/13.
//  Copyright (c) 2015年 Takehisa Oneta. All rights reserved.
//

#import "WaveScreenView.h"
#import "FGController.h"

//----------------------------------------------------------------
//----------------------------------------------------------------

@implementation WaveScreenView

- (instancetype)initWithFrame:(CGRect)frame
{
	self = [super initWithFrame:frame];
	if (self) {
		_waveFormRect = self.frame;		// TODO: これ自身はたぶん一回り大きいので、ちゃんと設定した値を元にすること

		_frequency = WAVE_BUFFER_SIZE;
	}
	return self;
}

/*
- (void)setWaveFormRect:(CGRect)waveFormRect
{
	_waveFormRect = waveFormRect;
	//[self setNeedsDisplay];
}
*/

- (void)setFrequency:(int32_t)frequency
{
	_frequency = frequency;
	[self setNeedsDisplay];
}

//----------------------------------------------------------------
//----------------------------------------------------------------

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
	
	//NSLog(@"WaveScreenView: drawRect");

	CGContextRef context = UIGraphicsGetCurrentContext();
	
	//CGRect drawRect = CGRectMake(rect.origin.x, rect.origin.y, rect.size.width, rect.size.height);
	CGRect drawRect = rect;
	CGContextSetRGBFillColor(context, 0.0f, 0.0f, 0.0f, 0.0f);
	CGContextFillRect(context, drawRect);
	CGContextStrokePath(context);
	
	[self drawGridline:context];
}

//----------------------------------------------------------------
/**
 */
- (CGFloat)changeX:(CGFloat)x
{
	return _waveFormRect.origin.x + x;
}

/**
 * y = -1〜1 を (waveformRect.origin.y + waveformRect.size.height) 〜 waveformRect.origin.y に変換する
 */
- (CGFloat)changeY:(CGFloat)y
{
	CGFloat yy = (y + 1.0) / 2.0;
	return _waveFormRect.origin.y + _waveFormRect.size.height - (yy * _waveFormRect.size.height);
}

//----------------------------------------------------------------
/**
 * フレームと目盛を描画
 */
- (void)drawGridline:(CGContextRef)context
{
	// 外枠
	CGContextSetStrokeColorWithColor(context, UIColor.greenColor.CGColor);
	CGContextSetLineWidth(context, 1.0);
	{
		CGContextMoveToPoint(context,    [self changeX:-8], [self changeY:1]);
		CGContextAddLineToPoint(context, [self changeX:-8], [self changeY:-1]);

		CGContextMoveToPoint(context,	 [self changeX:_waveFormRect.size.width + 8], [self changeY:1]);
		CGContextAddLineToPoint(context, [self changeX:_waveFormRect.size.width + 8], [self changeY:-1]);
	}
	CGContextStrokePath(context);

	
	CGContextSetStrokeColorWithColor(context, UIColor.greenColor.CGColor);
	CGContextSetLineWidth(context, 0.2);
	{
		// Y軸 目盛 (10個)
		for (double y = -1; y <= 1; y += 0.2) {
			CGContextMoveToPoint(context,		[self changeX:-8],							 [self changeY:y]);
			CGContextAddLineToPoint(context,	[self changeX:_waveFormRect.size.width + 8], [self changeY:y]);
		}
		
		// X軸 目盛
		{
			// 分割サイズ
			double divVal = 1.0;
			if ((1 < _frequency) && (_frequency <= 5000)) {
				divVal = 1000.0;
			} else if ((5001 < _frequency) && (_frequency <= 50000)) {
				divVal = 10000.0;
			} else if ((50001 < _frequency) && (_frequency <= 500000)) {
				divVal = 100000.0;
			} else if ((500001 < _frequency) && (_frequency <= 5000000)) {
				divVal = 1000000.0;
			} else if ((5000001 < _frequency) && (_frequency <= 50000000)) {
				divVal = 10000000.0;
			}
			int oneWidth = (int)((double)WAVE_BUFFER_SIZE / 10.0) / ((double)_frequency / divVal);
			
			NSLog(@"freq:%d, divVal:%f,  oneWidth: %d", _frequency, divVal, oneWidth);
			if (oneWidth > 2) {
				for (int x = 0; x <= WAVE_BUFFER_SIZE; x += oneWidth) {
			 		CGContextMoveToPoint(context,    [self changeX:x], [self changeY:1]);
					CGContextAddLineToPoint(context, [self changeX:x], [self changeY:-1]);
		 		}
			}
		}
	}
	CGContextStrokePath(context);

	// センターライン
	CGContextSetStrokeColorWithColor(context, UIColor.greenColor.CGColor);
	CGContextSetLineWidth(context, 0.5);
	CGContextMoveToPoint(context, self.frame.origin.x + 2, [self changeY:0]);
	CGContextAddLineToPoint(context, self.frame.origin.x + self.frame.size.width - 2, [self changeY:0]);
	CGContextStrokePath(context);

}

//----------------------------------------------------------------
//----------------------------------------------------------------

@end
