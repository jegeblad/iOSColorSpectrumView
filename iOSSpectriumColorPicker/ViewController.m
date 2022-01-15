//
//  ViewController.m
//  iOSSpectriumColorPicker
//
//  Created by Jens Egeblad on 15/01/2022.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
	[super viewDidLoad];
}

-(void) pickedRed:(CGFloat) red green:(CGFloat) green blue:(CGFloat) blue
{
	// This is called from ColorSpectrumView when we select a color.
	// Just update background color in the example view with the new color
	self.colorPickedView.backgroundColor = [UIColor colorWithRed:red green:green blue:blue alpha:1.0];
}


-(void) viewDidAppear:(BOOL)animated
{
	[super viewDidAppear:animated];

	// Set some default color value
	[self.spectrumView setCurrentColorRed:0.0 green:0.25 blue:1.0];
	[self pickedRed:0.0 green:0.25 blue:1.0];
}



@end
