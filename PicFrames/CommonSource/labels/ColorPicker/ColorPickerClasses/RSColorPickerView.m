//
//  RSColorPickerView.m
//  RSColorPicker
//
//  Created by Ryan Sullivan on 8/12/11.
//  Copyright 2011 Freelance Web Developer. All rights reserved.
//

#import "RSColorPickerView.h"
#import "BGRSLoupeLayer.h"

@interface RSColorPickerView ()
{
    int ignoreCount;
}

@end
// point-related macros
#define INNER_P(x) (x < 0 ? ceil(x) : floor(x))
#define IS_INSIDE(p) (round(p.x) >= 0 && round(p.x) < self.frame.size.width && round(p.y) >= 0 && round(p.y) < self.frame.size.height)

// Concept-code from http://www.easyrgb.com/index.php?X=MATH&H=21#text21
BMPixel pixelFromHSV(CGFloat H, CGFloat S, CGFloat V) {
	if (S == 0) {
		return BMPixelMake(V, V, V, 1.0);
	}
	CGFloat var_h = H * 6.0;
	if (var_h == 6.0) {
		var_h = 0.0;
	}
	CGFloat var_i = floor(var_h);
	CGFloat var_1 = V * (1.0 - S);
	CGFloat var_2 = V * (1.0 - S * (var_h - var_i));
	CGFloat var_3 = V * (1.0 - S * (1.0 - (var_h - var_i)));
	
	if (var_i == 0) {
		return BMPixelMake(V, var_3, var_1, 1.0);
	} else if (var_i == 1) {
		return BMPixelMake(var_2, V, var_1, 1.0);
	} else if (var_i == 2) {
		return BMPixelMake(var_1, V, var_3, 1.0);
	} else if (var_i == 3) {
		return BMPixelMake(var_1, var_2, V, 1.0);
	} else if (var_i == 4) {
		return BMPixelMake(var_3, var_1, V, 1.0);
	}
	return BMPixelMake(V, var_1, var_2, 1.0);
}


@interface RSColorPickerView (Private)
-(void)updateSelectionLocation;
-(CGPoint)validPointForTouch:(CGPoint)touchPoint;
@end


@implementation RSColorPickerView

@synthesize brightness, cropToCircle, delegate;
@synthesize nvmSupport;

+(CGPoint)getSelectionPointOfFrame:(CGRect)fr forModule:(NSString*)modName
{
    NSData         *data;
	NSFileHandle   *fd;
	tRGBvalue      colorNvm;
	CGFloat sqr = fmin(fr.size.height, fr.size.width);
    
	/* Initialize the vars with default values */
	colorNvm.fRed   = _DEFAULT_RED_VALUE;
	colorNvm.fGreen = _DEFAULT_GREEN_VALUE;
	colorNvm.fBlue  = _DEFAULT_BLUE_VALUE;
	colorNvm.fAlpha = _DEFAULT_ALPHA_VALUE;
    colorNvm.selectionPoint = CGPointMake(sqr/2, sqr/2);
	
	if(YES == [[NSFileManager defaultManager] fileExistsAtPath:[RSColorPickerView storedColorFilePathForModule:modName]])
	{
		/* File exist so read the saved status from the file  */
		fd = [NSFileHandle fileHandleForReadingAtPath:[RSColorPickerView storedColorFilePathForModule:modName]];
		
		/* Read the data from the file */
		if([(data = [fd readDataOfLength:sizeof(tRGBvalue)]) length]>0)
		{			
			memcpy(&colorNvm, [data bytes], sizeof(tRGBvalue));
		}
		
		[fd closeFile];
	}
    else 
    {
        [RSColorPickerView setSelection:colorNvm.selectionPoint forModule:modName];
    }
    
	return colorNvm.selectionPoint;
}

- (id)initWithFrame:(CGRect)frame forModule:(NSString*)mod
{
	CGFloat sqr = fmin(frame.size.height, frame.size.width);
	frame.size = CGSizeMake(sqr, sqr);
	
	self = [super initWithFrame:frame];
	if (self) {
        moduleName = [[NSString alloc]initWithString:mod];
		cropToCircle = YES;
		badTouch = NO;
		bitmapNeedsUpdate = YES;
		
		selection = [RSColorPickerView getSelectionPointOfFrame:frame forModule:mod];
		selectionView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, 18.0, 18.0)];
		selectionView.backgroundColor = [UIColor clearColor];
		selectionView.layer.borderWidth = 2.0;
		selectionView.layer.borderColor = [UIColor colorWithWhite:0.1 alpha:1.0].CGColor;
		selectionView.layer.cornerRadius = 9.0;
		[self updateSelectionLocation];
		[self addSubview:selectionView];
        
        ignoreCount = 0;
		
		self.brightness = 1.0;
		rep = [[ANImageBitmapRep alloc] initWithSize:BMPointFromSize(frame.size)];
	}
	return self;
}


-(void)setBrightness:(CGFloat)bright {
    
	brightness = bright;
	bitmapNeedsUpdate = YES;
	[self setNeedsDisplay];
    
    ignoreCount++;
    
    if(ignoreCount > 2)
    {
        [delegate colorPickerDidChangeSelection:self];
    }
}

-(void)setCropToCircle:(BOOL)circle {
	if (circle == cropToCircle) { return; }
	cropToCircle = circle;
	[self setNeedsDisplay];
}

-(void)genBitmap {
	if (!bitmapNeedsUpdate) return;
    
	CGFloat radius = (rep.bitmapSize.x / 2.0);
	CGFloat relX = 0.0;
	CGFloat relY = 0.0;
	
	for (int x = 0; x < rep.bitmapSize.x; x++) {
		relX = x - radius;
		
		for (int y = 0; y < rep.bitmapSize.y; y++) {
			relY = radius - y;
			
			CGFloat r_distance = sqrt((relX * relX)+(relY * relY));
			if (fabsf(r_distance) > radius && cropToCircle == YES) {
				[rep setPixel:BMPixelMake(0.0, 0.0, 0.0, 0.0) atPoint:BMPointMake(x, y)];
				continue;
			}
			r_distance = fmin(r_distance, radius);
			
			CGFloat angle = atan2(relY, relX);
			if (angle < 0.0) { angle = (2.0 * M_PI)+angle; }
			
			CGFloat perc_angle = angle / (2.0 * M_PI);
			BMPixel thisPixel = pixelFromHSV(perc_angle, r_distance/radius, self.brightness);
			[rep setPixel:thisPixel atPoint:BMPointMake(x, y)];
		}
	}
	bitmapNeedsUpdate = NO;
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
	[self genBitmap];
	[[rep image] drawInRect:rect];
}


-(UIColor*)selectionColor {
    UIColor *clr = UIColorFromBMPixel([rep getPixelAtPoint:BMPointFromPoint(selection)]);
	return clr;
}

-(CGPoint)selection {
	return selection;
}

/**
 * Hue saturation and briteness of the selected point
 * @Reference: Taken from ars/uicolor-utilities 
 * http://github.com/ars/uicolor-utilities
 */
-(void)selectionToHue:(CGFloat *)pH saturation:(CGFloat *)pS brightness:(CGFloat *)pV{
	
	//Get red green and blue from selection
	BMPixel pixel = [rep getPixelAtPoint:BMPointFromPoint(selection)];
	CGFloat r = pixel.red, b = pixel.blue, g = pixel.green;
	
	CGFloat h,s,v;
	
	// From Foley and Van Dam
	CGFloat max = MAX(r, MAX(g, b));
	CGFloat min = MIN(r, MIN(g, b));
	
	// Brightness
	v = max;
	
	// Saturation
	s = (max != 0.0f) ? ((max - min) / max) : 0.0f;
	
	if (s == 0.0f) {
		// No saturation, so undefined hue
		h = 0.0f;
	} else {
		// Determine hue
		CGFloat rc = (max - r) / (max - min);		// Distance of color from red
		CGFloat gc = (max - g) / (max - min);		// Distance of color from green
		CGFloat bc = (max - b) / (max - min);		// Distance of color from blue
		
		if (r == max) h = bc - gc;					// resulting color between yellow and magenta
		else if (g == max) h = 2 + rc - bc;			// resulting color between cyan and yellow
		else /* if (b == max) */ h = 4 + gc - rc;	// resulting color between magenta and cyan
		
		h *= 60.0f;									// Convert to degrees
		if (h < 0.0f) h += 360.0f;					// Make non-negative
		h /= 360.0f;                                // Convert to decimal
	}
	
	if (pH) *pH = h;
	if (pS) *pS = s;
	if (pV) *pV = v;
}

-(UIColor*)colorAtPoint:(CGPoint)point {
    if (IS_INSIDE(point)){
        return UIColorFromBMPixel([rep getPixelAtPoint:BMPointFromPoint(point)]);
    }
    return self.backgroundColor;
}

-(CGPoint)validPointForTouch:(CGPoint)touchPoint {
	if (!cropToCircle) {
		//Constrain point to inside of bounds
		touchPoint.x = MIN(CGRectGetMaxX(self.bounds)-1, touchPoint.x);
		touchPoint.x = MAX(CGRectGetMinX(self.bounds),   touchPoint.x);
		touchPoint.y = MIN(CGRectGetMaxX(self.bounds)-1, touchPoint.y);
		touchPoint.y = MAX(CGRectGetMinX(self.bounds),   touchPoint.y);
		return touchPoint;
	}
	
	BMPixel pixel = BMPixelMake(0.0, 0.0, 0.0, 0.0);
	if (IS_INSIDE(touchPoint)) {
		pixel = [rep getPixelAtPoint:BMPointFromPoint(touchPoint)];
	}
	
	if (pixel.alpha > 0.0) {
		return touchPoint;
	}
	
	// the point is invalid, so we will put it in a valid location.
	CGFloat radius = (self.frame.size.width / 2.0);
	CGFloat relX = touchPoint.x - radius;
	CGFloat relY = radius - touchPoint.y;
	CGFloat angle = atan2(relY, relX);
	
	if (angle < 0) { angle = (2.0 * M_PI) + angle; }
	relX = INNER_P(cos(angle) * radius);
	relY = INNER_P(sin(angle) * radius);
	
	while (relX >= radius)  { relX -= 1; }
	while (relX <= -radius) { relX += 1; }
	while (relY >= radius)  { relY -= 1; }
	while (relY <= -radius) { relY += 1; }
	return CGPointMake(round(relX + radius), round(radius - relY));
}


-(void)updateSelectionLocation {
   selectionView.center = selection;

    [RSColorPickerView setSelection:selection forModule:moduleName];
   [CATransaction setDisableActions:YES];
   loupeLayer.position = selection;
   [loupeLayer setNeedsDisplay];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
   
   //Lazily load loupeLayer
    if (!loupeLayer){
        loupeLayer = [[BGRSLoupeLayer layer] retain];
    }
    
	CGPoint point = [[touches anyObject] locationInView:self];
	CGPoint circlePoint = [self validPointForTouch:point];
	
	BMPixel checker = [rep getPixelAtPoint:BMPointFromPoint(point)];
	if (!(checker.alpha > 0.0)) {
		badTouch = YES;
		return;
	}
	badTouch = NO;
	
	BMPixel pixel = [rep getPixelAtPoint:BMPointFromPoint(circlePoint)];
    pixel = pixel;
	NSAssert(pixel.alpha >= 0.0, @"-validPointForTouch: returned invalid point.");
	
	selection = circlePoint;
	[delegate colorPickerDidChangeSelection:self];
    [loupeLayer appearInColorPicker:self];
	
    [self updateSelectionLocation];
    

    [RSColorPickerView setCurColor:self.selectionColor forModule:moduleName];

}
-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
	if (badTouch) return;
	
	CGPoint point = [[touches anyObject] locationInView:self];
	CGPoint circlePoint = [self validPointForTouch:point];
	
	BMPixel pixel = [rep getPixelAtPoint:BMPointFromPoint(circlePoint)];
    pixel = pixel;
	NSAssert(pixel.alpha >= 0.0, @"-validPointForTouch: returned invalid point.");
	
	selection = circlePoint;
	[delegate colorPickerDidChangeSelection:self];
	[self updateSelectionLocation];
    
    [RSColorPickerView setCurColor:self.selectionColor forModule:moduleName];
    
}
-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
	if (badTouch) return;
	
	CGPoint point = [[touches anyObject] locationInView:self];
	CGPoint circlePoint = [self validPointForTouch:point];
	
	BMPixel pixel = [rep getPixelAtPoint:BMPointFromPoint(circlePoint)];
    pixel = pixel;
	NSAssert(pixel.alpha >= 0.0, @"-validPointForTouch: returned invalid point.");
	
	selection = circlePoint;
	[delegate colorPickerDidChangeSelection:self];

    [RSColorPickerView setCurColor:self.selectionColor forModule:moduleName];

    [self updateSelectionLocation];
    [loupeLayer disapear];
}



- (void)dealloc
{
    NSLog(@"RSColorPickerview release!!!!!!!");
    [rep release];
    [selectionView release];
    [loupeLayer release];
    [moduleName release];
    loupeLayer = nil;
    
    [super dealloc];
}

#pragma mark nvm
+(NSString *)storedColorFilePathForModule:(NSString*)modName
{
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docDirectory = [paths objectAtIndex:0];
	NSString *pFileName = nil;
	
	//pFileName = @"storedcolors.txt";
    pFileName = [NSString stringWithFormat:@"storedcolor_%@.txt",modName];
	
	/* Return the path to the puzzle status information */
	return [docDirectory stringByAppendingPathComponent:pFileName];
}

+(tRGBvalue)colorToRgb:(UIColor*)clr
{
    UIColor *color = clr;
    tRGBvalue rgb;
    //CGFloat red = 0.0, green = 0.0, blue = 0.0, alpha = 0.0;
    
    //if ([color respondsToSelector:@selector(getRed:green:blue:alpha:)]) {
    //    [color getRed:&rgb.fRed green:&rgb.fGreen blue:&rgb.fBlue alpha:&rgb.fAlpha];
    //} else 
    {
        const CGFloat *components = CGColorGetComponents(color.CGColor);
        rgb.fRed = components[0]*255.0;
        rgb.fGreen = components[1]*255.0;
        rgb.fBlue = components[2]*255.0;
        rgb.fAlpha = components[3];
    }
    
    
    return rgb;
}

+(tRGBvalue)getCurrentNvmDataForModule:(NSString*)modName
{
    NSData         *data;
	NSFileHandle   *fd;
	tRGBvalue      colorNvm;
	
	/* Initialize the vars with default values */
	colorNvm.fRed   = _DEFAULT_RED_VALUE;
	colorNvm.fGreen = _DEFAULT_GREEN_VALUE;
	colorNvm.fBlue  = _DEFAULT_BLUE_VALUE;
	colorNvm.fAlpha = _DEFAULT_ALPHA_VALUE;
	
	if(YES == [[NSFileManager defaultManager] fileExistsAtPath:[RSColorPickerView storedColorFilePathForModule:modName]])
	{
		/* File exist so read the saved status from the file  */
		fd = [NSFileHandle fileHandleForReadingAtPath:[RSColorPickerView storedColorFilePathForModule:modName]];
		
		/* Read the data from the file */
		if([(data = [fd readDataOfLength:sizeof(tRGBvalue)]) length]>0)
		{			
			memcpy(&colorNvm, [data bytes], sizeof(tRGBvalue));
		}
		
		[fd closeFile];
	}
    
	return colorNvm;
}

+(void)setSelection:(CGPoint)pnt forModule:(NSString*)modName
{
    NSFileHandle *fd;
	NSData       *data;
    /* First get the current nvm data */
    tRGBvalue rgb = [RSColorPickerView getCurrentNvmDataForModule:modName];
    
    /* update selection point */
    rgb.selectionPoint = pnt;

    if(YES == [[NSFileManager defaultManager] fileExistsAtPath:[RSColorPickerView storedColorFilePathForModule:modName]])
    {
        /* Open the File */
        fd = [NSFileHandle fileHandleForWritingAtPath:[RSColorPickerView storedColorFilePathForModule:modName]];
        
        /* write the default status information to the file */
        data = [[NSData alloc] initWithBytes:&rgb length:sizeof(tRGBvalue)];
        
        /* Write the data to the file */
        [fd writeData:data];
        
        /* Release the data */
        [data release];
        
        /* Close the file */
        [fd closeFile];
    }
    else 
    {
        /* write the default status information to the file */
        data = [[NSData alloc] initWithBytes:&rgb length:sizeof(tRGBvalue)];
        
        if(NO == [[NSFileManager defaultManager] createFileAtPath:[RSColorPickerView storedColorFilePathForModule:modName] contents:data attributes:nil])
        {
            [data release];
            return;
        }
        
        [data release];
    }
}

+(void)setCurColor:(UIColor*)clr forModule:(NSString*)modName
{
    tRGBvalue rgb = [RSColorPickerView colorToRgb:clr];
    tRGBvalue sel = [RSColorPickerView getCurrentNvmDataForModule:modName];
    NSFileHandle *fd;
	NSData       *data;
    rgb.selectionPoint = sel.selectionPoint;
    
    if(YES == [[NSFileManager defaultManager] fileExistsAtPath:[RSColorPickerView storedColorFilePathForModule:modName]])
	{
		/* Open the File */
		fd = [NSFileHandle fileHandleForWritingAtPath:[RSColorPickerView storedColorFilePathForModule:modName]];
		
		/* write the default status information to the file */
		data = [[NSData alloc] initWithBytes:&rgb length:sizeof(tRGBvalue)];
		
		/* Write the data to the file */
		[fd writeData:data];
		
		/* Release the data */
		[data release];
		
		/* Close the file */
		[fd closeFile];
	}
    else 
    {
        /* write the default status information to the file */
		data = [[NSData alloc] initWithBytes:&rgb length:sizeof(tRGBvalue)];
        
        if(NO == [[NSFileManager defaultManager] createFileAtPath:[RSColorPickerView storedColorFilePathForModule:modName] contents:data attributes:nil])
		{
            [data release];
			return;
		}
        
        [data release];
    }
}

+(UIColor*)getCurrentColorForModule:(NSString*)modName
{
	NSData         *data;
	NSFileHandle   *fd;
	UIColor        *pColor;
	tRGBvalue      colorNvm;
	
	/* Initialize the vars with default values */
	colorNvm.fRed   = _DEFAULT_RED_VALUE;
	colorNvm.fGreen = _DEFAULT_GREEN_VALUE;
	colorNvm.fBlue  = _DEFAULT_BLUE_VALUE;
	colorNvm.fAlpha = _DEFAULT_ALPHA_VALUE;
	
	if(YES == [[NSFileManager defaultManager] fileExistsAtPath:[RSColorPickerView storedColorFilePathForModule:modName]])
	{
		/* File exist so read the saved status from the file  */
		fd = [NSFileHandle fileHandleForReadingAtPath:[RSColorPickerView storedColorFilePathForModule:modName]];
		
		/* Read the data from the file */
		if([(data = [fd readDataOfLength:sizeof(tRGBvalue)]) length]>0)
		{			
			memcpy(&colorNvm, [data bytes], sizeof(tRGBvalue));
		}
		
		[fd closeFile];
	}
	
	pColor = [[UIColor alloc]initWithRed:colorNvm.fRed/255.0 
								   green:colorNvm.fGreen/255.0 
									blue:colorNvm.fBlue/255.0
								   alpha:colorNvm.fAlpha];
    [pColor autorelease];
    
	return pColor;
}

@end
