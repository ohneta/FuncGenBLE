//
//  WaveEditViewController.h
//  FunctionGenBLE
//
//  Created by Takehisa Oneta on 2015/05/13.
//  Copyright (c) 2015年 Takehisa Oneta. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FGController.h"

@class WaveScreenView;
@class WaveFormView;

//----------------------------------------------------------------

@interface WaveEditViewController : UIViewController
{
	FGController	*fgController;

	CGRect		waveformScrollRect;
	CGRect		waveformRect;

	WaveScreenView	*waveScreenView;
	UIScrollView	*waveFormScrollView;
	WaveFormView	*waveFormView;
	
	UIActivityIndicatorView	*bleAccessActivityIndicatorView;
	
	int32_t		frequency;
}

//-----------------------------

- (void)scrollViewDidScroll:(UIScrollView *)scrollView;
- (void)scrollViewDidZoom:(UIScrollView *)scrollView;

- (void)updateBleIcons:(BOOL)connect;

- (IBAction)sineWaveButtonHandle:(id)sender;
- (IBAction)squareButtonHandle:(id)sender;
- (IBAction)triangeButtonHandle:(id)sender;
- (IBAction)sawtoothButtonHandle:(id)sender;
- (IBAction)freehandButtonHandle:(id)sender;
- (void)replaceBuffer;

- (void)waveBufferClear;
- (void)makeSineWave;
- (void)makeSquareWave;
- (void)makeTriangleWave;
- (void)makeSawtoothWave;

- (IBAction)connectButtonHandle:(id)sender;

- (IBAction)outputButtonHandle:(id)sender;

- (IBAction)sendButtonHandle:(id)sender;


- (IBAction)frequencyUpButtonHandle:(id)sender;
- (IBAction)frequencyDownButtonHandle:(id)sender;
- (void)updateFrequency:(BOOL)wantSend;


@end

//----------------------------------------------------------------
