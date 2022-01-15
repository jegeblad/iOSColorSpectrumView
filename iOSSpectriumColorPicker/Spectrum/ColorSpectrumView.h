//
//  ColorSpectriumView.h
//  iOSSpectriumColorPicker
//
//  Created by Jens Egeblad on 15/01/2022.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol ColorSpectrumViewDelegate
-(void) pickedRed:(CGFloat) red green:(CGFloat) green blue:(CGFloat) blue;
@end


@interface ColorSpectrumView : UIView

@property (weak) IBOutlet id<ColorSpectrumViewDelegate>  delegate;

-(void) setCurrentColorRed:(CGFloat) red green:(CGFloat) green blue:(CGFloat) blue;

@end

NS_ASSUME_NONNULL_END
