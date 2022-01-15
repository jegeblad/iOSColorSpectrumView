//
//  ColorSpectrumDrawer.h
//  iOSSpectriumColorPicker
//
//  Created by Jens Egeblad on 15/01/2022.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIkit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ColorSpectrumDrawer : NSObject

// Returns a spectrum image as UIImage
+(UIImage*) createSpectrumImageWithWidth:(NSInteger) width andHeight:(NSInteger)height;

// Returns red, green, blue values for a normalized point ([0,1]x[0,1]) in the spectrum image
+(void) getForPoint:(CGPoint) point red:(CGFloat*)r green:(CGFloat*)g blue:(CGFloat*)b;

// Returns normalized position [0,1]x[0,1] for red, green, blue values
+(CGPoint) getPointForRed:(CGFloat)r green:(CGFloat)g blue:(CGFloat)b;

@end

NS_ASSUME_NONNULL_END
