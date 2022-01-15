//
//  ColorSpectrumDrawer.m
//  iOSSpectriumColorPicker
//
//  Created by Jens Egeblad on 15/01/2022.
//

#import "ColorSpectrumDrawer.h"

@implementation ColorSpectrumDrawer


static void HSL2RGB(CGFloat h, CGFloat s, CGFloat l, CGFloat* outR, CGFloat* outG, CGFloat* outB)
{
	CGFloat temp1, temp2;
	CGFloat temp[3];
	int i;
	
	if (s == 0.0)
	{
		*outR = l;
		*outG = l;
		*outB = l;
		
		return;
	}
	
	if (l < 0.5)
	{
		temp2 = l * (1.0 + s);
	}
	else
	{
		temp2 = l + s - l * s;
	}
	temp1 = 2.0 * l - temp2;
	
	temp[0] = h + 1.0 / 3.0;
	temp[1] = h;
	temp[2] = h - 1.0 / 3.0;
	
	for (i = 0; i < 3; ++i)
	{
		if (temp[i] < 0.0)
		{
			temp[i] += 1.0;
		}
		if (temp[i] > 1.0)
		{
			temp[i] -= 1.0;
		}
		
		if (6.0 * temp[i] < 1.0)
		{
			temp[i] = temp1 + (temp2 - temp1) * 6.0 * temp[i];
		}
		else
		{
			if(2.0 * temp[i] < 1.0)
			{
				temp[i] = temp2;
			}
			else
			{
				if(3.0 * temp[i] < 2.0)
				{
					temp[i] = temp1 + (temp2 - temp1) * ((2.0 / 3.0) - temp[i]) * 6.0;
				}
				else
				{
					temp[i] = temp1;
				}
			}
		}
	}
	
	*outR = temp[0];
	*outG = temp[1];
	*outB = temp[2];
}


static void RGB2HSL(CGFloat r, CGFloat g, CGFloat b, CGFloat * outH, CGFloat * outS, CGFloat * outL)
{
	CGFloat max = fmax(r, fmax(g, b));
	CGFloat min = fmin(r, fmin(g, b));

	CGFloat lum = (max + min) / 2;
	CGFloat hue = 0.0;
	CGFloat sat = 0.0;
	CGFloat c = max - min;
	CGFloat eps = 0.5/256.0;

	if (c > eps)
	{
		sat = c / (1 - fabs(2 * lum - 1));

		if (fabs(max - r)<eps)
		{
			hue = (g - b) / c + 0.0;
		}
		else if (fabs(max - g)<eps)
		{
			hue = (b - r) / c + 2.0;
		}
		else if (fabs(max - b)<eps)
		{
			hue = (r - g) / c + 4.0;
		}
	}

	*outH = hue/6.0; // scale to [0,1]
	if (*outH < 0.0)
	{
		*outH += 1.0;
	}
	*outS = sat;
	*outL = lum;
}


+(void) generateSpectrumBitmap:(unsigned char *)bitmap width:(NSInteger) width height:(NSInteger) height
{
	for (NSInteger y = 0; y < height; y++)
	{
		CGFloat lum = 1.0 - (double)y/(double)height;
		NSInteger i = y * width * 4;
		for (NSInteger x = 0; x < width; x++)
		{
			CGFloat r, g, b;
			CGFloat hue = (double)x / (double)width;
			HSL2RGB(hue, 1.0, lum, &r, &g, &b);

			bitmap[i] = r * 0xff;
			bitmap[i+1] = g * 0xff;
			bitmap[i+2] = b * 0xff;
			bitmap[i+3] = 0xff; // alpha
			i += 4;
		}
	}
}


+(void) getForPoint:(CGPoint) point red:(CGFloat*)r green:(CGFloat*)g blue:(CGFloat*)b
{
	CGFloat hue = point.x;
	CGFloat lum = 1.0 - point.y;

	HSL2RGB(hue, 1.0, lum, r, g, b);
}


+(CGPoint) getPointForRed:(CGFloat)r green:(CGFloat)g blue:(CGFloat)b
{
	CGFloat hue, lum, sat;
	RGB2HSL(r, g, b, &hue, &sat, &lum);

	return CGPointMake(hue, 1.0 - lum);
}


+(UIImage*) createUIImageWithRGBAData:(CFDataRef) data width:(NSInteger)width andHeight:(NSInteger) height
{
	CGDataProviderRef dataProvider = CGDataProviderCreateWithCFData(data);
	CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
	CGImageRef imageRef = CGImageCreate(width, height, 8, 32, width * 4, colorSpace, (CGBitmapInfo)kCGImageAlphaLast, dataProvider, NULL, 0, kCGRenderingIntentDefault);
	UIImage *image = [[UIImage alloc] initWithCGImage:imageRef];
	CGDataProviderRelease(dataProvider);
	CGColorSpaceRelease(colorSpace);
	CGImageRelease(imageRef);
	
	return image;
}


+(UIImage*) createSpectrumImageWithWidth:(NSInteger) width andHeight:(NSInteger)height
{
	CFMutableDataRef bitmapData = CFDataCreateMutable(NULL, 0);
	CFDataSetLength(bitmapData, width * height * 4);

	[[self class] generateSpectrumBitmap:CFDataGetMutableBytePtr(bitmapData) width:width height:height];

	UIImage *image = [[self class] createUIImageWithRGBAData:bitmapData width:width andHeight:height];
	CFRelease(bitmapData);

	return image;
}


@end
