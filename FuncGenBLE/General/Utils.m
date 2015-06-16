//
//  Utils.m
//  FunctionGenBLE
//
//  Created by Takehisa Oneta on 2015/05/13.
//  Copyright (c) 2015年 Takehisa Oneta. All rights reserved.
//

#import "Utils.h"
#import "Defines.h"

@implementation Utils


/**
 * 波形の文字列表記
 */
+ (NSString *)waveKindString:(WaveKind)waveKind
{
	if ((waveKind < WaveKind_None) || (WaveKind_Freehand < waveKind)) {
		return nil;
	}
	
	const NSString *waveKindName[] = {@"Fixed", @"Sine", @"Square", @"Triangle", @"Sawtooth", @"Freehand"};
	return (NSString *)waveKindName[waveKind];
}

@end
