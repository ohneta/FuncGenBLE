//
//  SettingViewController.m
//  FunctionGenBLE
//
//  Created by Takehisa Oneta on 2015/06/12.
//  Copyright (c) 2015年 Takehisa Oneta. All rights reserved.
//

#import "SettingViewController.h"

@interface SettingViewController ()  <UIPickerViewDelegate, UIPickerViewDataSource>


@property (weak, nonatomic) IBOutlet UIPickerView *khzFreqPickerView;
@property (weak, nonatomic) IBOutlet UIPickerView *hzFreqPickerView;

@end

@implementation SettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
	
	{
		_khzFreqPickerView.delegate = self;
		_khzFreqPickerView.dataSource = self;
		_khzFreqPickerView.showsSelectionIndicator = YES;
/*
		{
			CGAffineTransform t0 = CGAffineTransformMakeTranslation(_khzFreqPickerView.bounds.size.width / 2, _khzFreqPickerView.bounds.size.height / 2);
			CGAffineTransform s0 = CGAffineTransformMakeScale(0.5, 0.5);
			CGAffineTransform t1 = CGAffineTransformMakeTranslation(-1 * _khzFreqPickerView.bounds.size.width / 2, -1 * _khzFreqPickerView.bounds.size.height / 2);
			_khzFreqPickerView.transform = CGAffineTransformConcat(t0, CGAffineTransformConcat(s0, t1));
		}
*/
		_hzFreqPickerView.delegate = self;
		_hzFreqPickerView.dataSource = self;
		_hzFreqPickerView.showsSelectionIndicator = YES;
/*
 		{
			CGAffineTransform t0 = CGAffineTransformMakeTranslation(_hzFreqPickerView.bounds.size.width / 2, _hzFreqPickerView.bounds.size.height / 2);
			CGAffineTransform s0 = CGAffineTransformMakeScale(0.5, 0.5);
			CGAffineTransform t1 = CGAffineTransformMakeTranslation(-1 * _hzFreqPickerView.bounds.size.width / 2, -1 * _hzFreqPickerView.bounds.size.height / 2);
			_hzFreqPickerView.transform = CGAffineTransformConcat(t0, CGAffineTransformConcat(s0, t1));
		}
*/
	}
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
	
}


/*
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
	if (component == 3)
		return @",";

	return [NSString stringWithFormat:@"%d", (int)row];
}
*/

@end
