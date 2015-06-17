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


//----------------------------------------------------------------
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

//----------------------------------------------------------------

+ (void)appSettingValues
{
	
}

+ (void)initialAppSettingValues
{
	NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];  // 取得
	NSMutableDictionary *defaults = [NSMutableDictionary dictionary];

	[defaults setObject:@"99" forKey:@"KEY_I"];  // をKEY_Iというキーの初期値は99
	[defaults setObject:@"99.99" forKey:@"KEY_F"];  // をKEY_Fというキーの初期値は99.99
	[defaults setObject:@"88.88" forKey:@"KEY_D"];  // をKEY_Dというキーの初期値は88.88
	[defaults setObject:@"YES" forKey:@"KEY_B"];  // をKEY_Bというキーの初期値はYES
	[defaults setObject:@"hoge" forKey:@"KEY_S"];  // をKEY_Sというキーの初期値はhoge
	[ud registerDefaults:defaults];
}



//----------------------------------------------------------------

@end
