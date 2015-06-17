//
//  SettingViewController.m
//  FunctionGenBLE
//
//  Created by Takehisa Oneta on 2015/06/12.
//  Copyright (c) 2015年 Takehisa Oneta. All rights reserved.
//

#import "SettingViewController.h"

@interface SettingViewController ()

@property (weak, nonatomic) IBOutlet UISwitch *transferWaveformBeforeOutputOffButton;
@property (weak, nonatomic) IBOutlet UISwitch *transferWaveformAfterOutputOnButton;
@property (weak, nonatomic) IBOutlet UISwitch *transferWaveformWithFrequencyButton;

@property (weak, nonatomic) IBOutlet UISwitch *frequencyWithPanGestureButton;
@end

@implementation SettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
	}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


//----------------------------------------------------------------
/**
 */

- (IBAction)transferWaveformBeforeOutputOffButtonHandle:(id)sender {
}

- (IBAction)transferWaveformAfterOutputOnButtonHandle:(id)sender {
}

- (IBAction)transferWaveformWithFrequencyButtonHandle:(id)sender {
}

- (IBAction)frequencyWithPanGestureButtonHandle:(id)sender {
}

@end
