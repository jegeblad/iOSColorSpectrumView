//
//  ColorSpectriumView.m
//  iOSSpectriumColorPicker
//
//  Created by Jens Egeblad on 15/01/2022.
//

#import "ColorSpectrumDrawer.h"
#import "ColorSpectrumView.h"

@interface ColorSpectrumView()
{
	UIImageView * selectedRectangleView; // <- Selection marker
	CGPoint normalizedSelectedColor; // <- Current selected color in Hue/Lum normalized [0:1]x[0:1] color space (i.e. normalized position in spectrum image)
}

@end

@implementation ColorSpectrumView


-(id) initWithFrame:(CGRect) frame
{
	self = [super initWithFrame:frame];
	if (self)
	{
		normalizedSelectedColor = CGPointMake(0.5, 0.5);
		[self setupSubviews];
	}

	return self;
}


-(void) awakeFromNib
{
	[super awakeFromNib];
	[self setupSubviews];
}


-(CGSize) selectionRectangleSize
{
	return CGSizeMake(8.0, 8.0);
}


-(UIImage*) rectangleImage
{
	// Create marker image
	CGSize s = [self selectionRectangleSize];
	CGRect selectionRectangle = CGRectMake(0.0, 0.0, s.width, s.height);
	
	UIGraphicsBeginImageContextWithOptions(s, NO, 0.0);
	{
		CGContextRef ctx = UIGraphicsGetCurrentContext();
		CGContextSetLineWidth(ctx, 1.0);
		CGContextSetRGBStrokeColor(ctx, 0.0, 0.0, 0.0, 1.0);
		CGContextStrokeRect(ctx, CGRectInset(selectionRectangle, 0.5, 0.5));

		CGContextSetRGBStrokeColor(ctx, 0.0, 0.0, 0.0, 1.0);
		CGContextStrokeRect(ctx, CGRectInset(selectionRectangle, 2.5, 2.5));

		CGContextSetRGBStrokeColor(ctx, 1.0, 1.0, 1.0, 1.0);
		CGContextStrokeRect(ctx, CGRectInset(selectionRectangle, 1.5, 1.5));
	}
	UIImage * result = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	
	return result;
}

-(void) setupSubviews
{
	// Add an image view on top of this view to show which color
	// we have currently selected
	CGSize s = [self selectionRectangleSize];
	selectedRectangleView = [[UIImageView alloc] initWithFrame:CGRectMake(0.0, 0.0, s.width, s.height)];
	[self addSubview:selectedRectangleView];
	selectedRectangleView.image = [self rectangleImage];
}


-(void) layoutSubviews
{
	[super layoutSubviews];

	// Reposition the marker view to fit the new size
	selectedRectangleView.center = [self selectedPoint];
}


-(CGPoint) selectedPoint
{
	CGFloat width = (int)CGRectGetWidth(self.bounds);
	CGFloat height = (int)CGRectGetHeight(self.bounds);

	return CGPointMake(normalizedSelectedColor.x * width, normalizedSelectedColor.y * height);
}


-(void) drawRect:(CGRect)rect
{
	// Simply draw the spectrum image
	CGFloat width = (int)CGRectGetWidth(self.bounds);
	CGFloat height = (int)CGRectGetHeight(self.bounds);
	UIImage * spectrumImage = [ColorSpectrumDrawer createSpectrumImageWithWidth:width andHeight:height];
	[spectrumImage drawInRect:self.bounds];
}


-(void) pickColorAt:(CGPoint) p
{
	CGFloat r, g, b;
	CGFloat width = (int)CGRectGetWidth(self.bounds);
	CGFloat height = (int)CGRectGetHeight(self.bounds);

	// Cap to coordinates inside the spectrum
	p.x = fmax(0.0, fmin(p.x, width));
	p.y = fmax(0.0, fmin(p.y, height));

	// Convert point to "normalized" position in the spectrum image
	normalizedSelectedColor = CGPointMake(p.x / width, p.y / height);

	// Determine the RGB values of the position
	[ColorSpectrumDrawer getForPoint:normalizedSelectedColor red:&r green:&g blue:&b];
	[self.delegate pickedRed:r green:g blue:b];
	
	// Update marker's position
	selectedRectangleView.center = p;
}


-(void) setCurrentColorRed:(CGFloat) red green:(CGFloat) green blue:(CGFloat) blue
{
	// Determine the color position in Hue/Lum [0:1]x[0:1] "color space" (this is the position in the spectrum image
	normalizedSelectedColor = [ColorSpectrumDrawer getPointForRed:red green:green blue:blue];

	// Position the selection marker
	selectedRectangleView.center = [self selectedPoint];
}


-(void) touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
	CGPoint p = [[touches anyObject] locationInView:self];
	[self pickColorAt:p];
}

-(void) touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
	CGPoint p = [[touches anyObject] locationInView:self];
	[self pickColorAt:p];
}

-(void) touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
	CGPoint p = [[touches anyObject] locationInView:self];
	[self pickColorAt:p];
}

@end
