//
//  ColorPickerView.h
//  Instacolor Splash
//
//  Created by Vijaya kumar reddy Doddavala on 8/29/12.
//  Copyright (c) 2012 motorola. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol ColorPickerViewDelegate
-(void)colorPickerViewDidChangeSelection:(UIColor*)clr;
@end

@interface ColorPickerView : UIPickerView <UIPickerViewDelegate,UIPickerViewDataSource>
{
    
}

@property(nonatomic,assign)id<ColorPickerViewDelegate> del;

@end


