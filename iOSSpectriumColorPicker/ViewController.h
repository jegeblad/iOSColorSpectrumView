//
//  ViewController.h
//  iOSSpectriumColorPicker
//
//  Created by Jens Egeblad on 15/01/2022.
//

#import <UIKit/UIKit.h>
#import "ColorSpectrumView.h"

@interface ViewController : UIViewController<ColorSpectrumViewDelegate>

@property (weak) IBOutlet UIView * colorPickedView; // <- We'll show example color by setting background color of this view
@property (weak) IBOutlet ColorSpectrumView * spectrumView; // This is the view that shows the spectrum

@end

