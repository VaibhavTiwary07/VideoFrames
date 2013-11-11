//
//  RSColorPickerView.h
//  RSColorPicker
//
//  Created by Ryan Sullivan on 8/12/11.
//  Copyright 2011 Freelance Web Developer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

#import "ANImageBitmapRep.h"

#define _DEFAULT_RED_VALUE   255.0
#define _DEFAULT_GREEN_VALUE 0.0
#define _DEFAULT_BLUE_VALUE  0.0
#define _DEFAULT_ALPHA_VALUE 1.0

typedef struct
{
	float fRed;
	float fGreen;
	float fBlue;
	float fAlpha;
	int   isValid;
    CGPoint selectionPoint;
}tRGBvalue;

@class RSColorPickerView, BGRSLoupeLayer;
@protocol RSColorPickerViewDelegate <NSObject>
-(void)colorPickerDidChangeSelection:(RSColorPickerView*)cp;
@end

@interface RSColorPickerView : UIView {
	ANImageBitmapRep *rep;
	CGFloat brightness;
	BOOL cropToCircle;
	
	UIView *selectionView;
    BGRSLoupeLayer* loupeLayer;
	CGPoint selection;
	
	BOOL badTouch;
	BOOL bitmapNeedsUpdate;
	
	id<RSColorPickerViewDelegate> delegate;
    NSString *moduleName;
}

-(UIColor*)selectionColor;
-(CGPoint)selection;

@property (nonatomic,readwrite)BOOL nvmSupport;
@property (nonatomic, assign) BOOL cropToCircle;
@property (nonatomic, assign) CGFloat brightness;
@property (assign) id<RSColorPickerViewDelegate> delegate;

/**
 * Hue, saturation and briteness of the selected point
 * @Reference: Taken From ars/uicolor-utilities 
 * http://github.com/ars/uicolor-utilities
 */

-(void)selectionToHue:(CGFloat *)pH saturation:(CGFloat *)pS brightness:(CGFloat *)pV;
-(UIColor*)colorAtPoint:(CGPoint)point; //Returns UIColor at a point in the RSColorPickerView
+(void)setCurColor:(UIColor*)clr forModule:(NSString*)modName;
+(UIColor*)getCurrentColorForModule:(NSString*)modName;
- (id)initWithFrame:(CGRect)frame forModule:(NSString*)mod;
+(void)setSelection:(CGPoint)pnt forModule:(NSString*)modName;
@end
