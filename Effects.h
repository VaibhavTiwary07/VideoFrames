//
//  Effects.h
//  VideoFrames
//
//  Created by Deepti's Mac on 1/20/14.
//
//

#import <Foundation/Foundation.h>

@interface Effects : NSObject
-(UIImage *)applyCurrentSelectedEffcect:(UIImage *)image withEffect:(int)effectNo;
-(UIImage *)getImageForItem:(int)itemNo;
-(NSString *)getNameOfEffect:(int )itemNo;
-(BOOL)getItemLockStatus:(int)itemNo;
@end
