//
//  StaticFilterMapping.m
//  MirroFx
//
//  Created by Vijaya kumar reddy Doddavala on 10/16/12.
//  Copyright (c) 2012 Cell Phone. All rights reserved.
//

#import "StaticFilterMapping.h"
#import "StaticFilterMappingPriv.h"
#import "PhotoEffects_Config.h"
@implementation StaticFilterMapping

static BOOL lockstatus[GROUP_STATIC_FILTER_LAST][30];

+(void)setLockStatusOfFilter:(int)fil group:(int)grp to:(BOOL)newstatus
{
    if(lockstatus[grp][fil] == newstatus)
    {
        return;
    }
    
    lockstatus[grp][fil] = newstatus;
    NSData *data = [NSData dataWithBytes:&lockstatus[0] length:(sizeof(BOOL) * GROUP_STATIC_FILTER_LAST * 30)];
    [[NSUserDefaults standardUserDefaults] setObject:data forKey:@"lockstatus"];
    
    return;
}

#if 0
+(void)synchronizeLockStatus
{
    NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:@"lockstatus"];
    if(nil == data)
    {
        return;
    }
    
    memcpy(&lockstatus, data.bytes, data.length);
    
    for(int i = 0; i < STATIC_GPU_FILTER_VINTAGE_EFFECT_LAST; i++)
    {
        if((lockstatus[GROUP_STATIC_GPU_FILTER_VINTAGE][i] != gpu_vintagemap[i].locked)&&())
        {
            
        }
    }
}
#endif

+(int)getLockStatusOfFilter:(int)fil group:(int)grp
{
    NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:@"lockstatus"];
    if(nil == data)
    {
        memset(&lockstatus[0],1,sizeof(BOOL) * GROUP_STATIC_FILTER_LAST * 30);
        
        /* store the values in lockstatus and upload to defaults */
#if VINTAGEGROUP_SUPPORT
        for(int i = 0; i < STATIC_GPU_FILTER_VINTAGE_EFFECT_LAST; i++)
        {
            lockstatus[GROUP_STATIC_GPU_FILTER_VINTAGE][i] = gpu_vintagemap[i].locked;
        }
#endif
        
#if TONEGROUP_SUPPORT
        for(int i = 0; i < STATIC_GPU_FILTER_TONE_EFFECT_LAST; i++)
        {
            lockstatus[GROUP_STATIC_GPU_FILTER_TONE][i] = gpu_tonemap[i].locked;
        }
#endif
#if COLORGROUP_SUPPORT
        for(int i = 0; i < STATIC_GPU_FILTER_COLOR_EFFECT_LAST; i++)
        {
            lockstatus[GROUP_STATIC_GPU_FILTER_COLOR][i] = gpu_colormap[i].locked;
        }
#endif
#if SKETCHGROUP_SUPPORT
        for(int i = 0; i < STATIC_GPU_FILTER_SKETCH_EFFECT_LAST; i++)
        {
            lockstatus[GROUP_STATIC_GPU_FILTER_SKETCH][i] = gpu_sketchmap[i].locked;
        }
#endif
#if CARTOONGROUP_SUPPORT

        for(int i = 0; i < STATIC_GPU_FILTER_TOON_EFFECT_LAST; i++)
        {
            lockstatus[GROUP_STATIC_GPU_FILTER_CARTOON][i] = gpu_cartoonmap[i].locked;
        }
#endif
#if TEXTUREGROUP_SUPPORT
        for(int i = 0; i < STATIC_FILTER_TEXTURE_LAST; i++)
        {
            lockstatus[GROUP_STATIC_FILTER_TEXTURE][i] = texture_maping[i].locked;
        }
#endif
#if GRUNGEGROUP_SUPPORT
        for(int i = 0; i < STATIC_FILTER_GRUNGE_LAST; i++)
        {
            lockstatus[GROUP_STATIC_FILTER_GRUNGE][i] = grunge_maping[i].locked;
        }
#endif
#if BOKEHGROUP_SUPPORT
        for(int i = 0; i < STATIC_FILTER_BOKEH_LAST; i++)
        {
            lockstatus[GROUP_STATIC_FILTER_BOKEH][i] = bokeh_maping[i].locked;
        }

#endif
#if SPACEGROUP_SUPPORT
        for(int i = 0; i < STATIC_FILTER_SPACE_LAST; i++)
        {
            lockstatus[GROUP_STATIC_FILTER_SPACE][i] = space_maping[i].locked;
        }
#endif
#if FRAMEGROUP_SUPPORT
        for(int i = 0; i < STATIC_FILTER_FRAME_LAST; i++)
        {
            lockstatus[GROUP_STATIC_FILTER_FRAME][i] = frame_maping[i].locked;
        }
#endif
        /* update in defaults */
        NSData *data = [NSData dataWithBytes:&lockstatus[0] length:(sizeof(BOOL) * GROUP_STATIC_FILTER_LAST * 30)];
        [[NSUserDefaults standardUserDefaults] setObject:data forKey:@"lockstatus"];
    }
    else
    {
        memcpy(&lockstatus[0], data.bytes, data.length);
    }
    
    return lockstatus[grp][fil];
}

+(NSString*)nameOfTheGroup:(int)grpId
{
    NSString *filterName = nil;
    
    switch(grpId)
    {
#if MIRRORSET_SUPPORT
        case GROUP_STATIC_FILTER_MIRROR:
        {
            filterName = @"Mirror";
            break;
        }
#endif
#if VINTAGEGROUP_SUPPORT
        
        case GROUP_STATIC_GPU_FILTER_VINTAGE:
        {
            filterName = @"Vintage";
            break;
        }
#endif
#if TONEGROUP_SUPPORT
        case GROUP_STATIC_GPU_FILTER_TONE:
        {
            filterName = @"Tone";
            break;
        }
#endif
#if SKETCHGROUP_SUPPORT
        case GROUP_STATIC_GPU_FILTER_SKETCH:
        {
            filterName = @"Sketch";
            break;
        }
#endif
#if CARTOONGROUP_SUPPORT
        case GROUP_STATIC_GPU_FILTER_CARTOON:
        {
            filterName = @"Cartoon";
            break;
        }
#endif
#if COLORGROUP_SUPPORT
        case GROUP_STATIC_GPU_FILTER_COLOR:
        {
            filterName = @"Color";
            break;
        }
#endif
#if GRUNGEGROUP_SUPPORT
        case GROUP_STATIC_FILTER_GRUNGE:
        {
            filterName = @"Grunge";
            break;
        }
#endif
#if BOKEHGROUP_SUPPORT
        case GROUP_STATIC_FILTER_BOKEH:
        {
            filterName = @"Bokeh";
            break;
        }
#endif
#if SPACEGROUP_SUPPORT
        case GROUP_STATIC_FILTER_SPACE:
        {
            filterName = @"Space";
            break;
        }
#endif
#if NOISESET_SUPPORT
        case GROUP_STATIC_FILTER_NOISE:
        {
            filterName = @"Noise";
            break;
        }
#endif
#if TEXTUREGROUP_SUPPORT
        case GROUP_STATIC_FILTER_TEXTURE:
        {
            filterName = @"Texture";
            break;
        }
#endif
#if FRAMEGROUP_SUPPORT
        case  GROUP_STATIC_FILTER_FRAME:
        {
            filterName = @"Frame";
            break;
        }
#endif
        default:
        {
            break;
        }
    }
    
    return filterName;
}

+(NSString*)nameOfFilterInGroup:(int)grpId atIndex:(int)index
{
    NSString *filterName = nil;
    
    switch(grpId)
    {
#if MIRRORSET_SUPPORT
        case GROUP_STATIC_FILTER_MIRROR:
        {
            filterName = [NSString stringWithFormat:@"%s",mirror_maping[index].name];
            break;
        }
#endif
#if TONEGROUP_SUPPORT
        case GROUP_STATIC_GPU_FILTER_TONE:
        {
            filterName = [NSString stringWithFormat:@"%s",gpu_tonemap[index].name];
            break;
        }
#endif
#if SKETCHGROUP_SUPPORT
        case GROUP_STATIC_GPU_FILTER_SKETCH:
        {
            filterName = [NSString stringWithFormat:@"%s",gpu_sketchmap[index].name];
            break;
        }
#endif
#if CARTOONGROUP_SUPPORT
        case GROUP_STATIC_GPU_FILTER_CARTOON:
        {
            filterName = [NSString stringWithFormat:@"%s",gpu_cartoonmap[index].name];
            break;
        }
#endif
#if COLORGROUP_SUPPORT
        case GROUP_STATIC_GPU_FILTER_COLOR:
        {
            filterName = [NSString stringWithFormat:@"%s",gpu_colormap[index].name];
            break;
        }
#endif
#if VINTAGEGROUP_SUPPORT
        case GROUP_STATIC_GPU_FILTER_VINTAGE:
        {
            filterName = [NSString stringWithFormat:@"%s",gpu_vintagemap[index].name];
            break;
        }
#endif
#if GRUNGEGROUP_SUPPORT
        case GROUP_STATIC_FILTER_GRUNGE:
        {
            filterName = [NSString stringWithFormat:@"%s",grunge_maping[index].name];
            break;
        }
#endif
#if BOKEHGROUP_SUPPORT
        case GROUP_STATIC_FILTER_BOKEH:
        {
            filterName = [NSString stringWithFormat:@"%s",bokeh_maping[index].name];
            //filterName = [NSString stringWithFormat:@"%s",tone_maping[index].name];
            break;
        }
#endif
#if SPACEGROUP_SUPPORT
        case GROUP_STATIC_FILTER_SPACE:
        {
            filterName = [NSString stringWithFormat:@"%s",space_maping[index].name];
            //filterName = [NSString stringWithFormat:@"%s",color_maping[index].name];
            break;
        }
#endif
#if NOISESET_SUPPORT
        case GROUP_STATIC_FILTER_NOISE:
        {
            break;
        }
#endif
#if TEXTUREGROUP_SUPPORT
        case GROUP_STATIC_FILTER_TEXTURE:
        {
            filterName = [NSString stringWithFormat:@"%s",texture_maping[index].name];
            break;
        }
#endif
#if FRAMEGROUP_SUPPORT
        case  GROUP_STATIC_FILTER_FRAME:
        {
            filterName = [NSString stringWithFormat:@"%s",frame_maping[index].name];
            break;
        }
#endif
        case GROUP_STATIC_FILTER_LAST:
        default:
        {
            break;
        }
    }
    
    return filterName;
}

+(NSString*)productIdForGroup:(int)grpId
{
    return nil;
}

+(BOOL)isFilterLockedOfGroup:(int)grpId atIndex:(int)index
{
    
    /* check if the user upgraded to pro version */
    if(bought_allpackages)
    {
        return NO;
    }
    
    /* check if the user bought all photo effects packages */
    if(bought_staticfilters)
    {
        return NO;
    }
    
    /* check if the user bough this group's package */
    NSString *key = nil;
    if(nil != key)
    {
        BOOL isAlreadyBought = [[NSUserDefaults standardUserDefaults]boolForKey:key];
        if(isAlreadyBought)
        {
            return NO;
        }
    }
    
#if 0
    BOOL locked = YES;
    switch(grpId)
    {
#if MIRRORSET_SUPPORT
        case GROUP_STATIC_FILTER_MIRROR:
        {
            locked     = mirror_maping[index].locked;
            //filterName = [NSString stringWithFormat:@"%s",mirror_maping[index].name];
            break;
        }
#endif
        case GROUP_STATIC_GPU_FILTER_TONE:
        {
            locked = gpu_tonemap[index].locked;
            break;
        }
        case GROUP_STATIC_GPU_FILTER_SKETCH:
        {
            locked = gpu_sketchmap[index].locked;
            break;
        }
        case GROUP_STATIC_GPU_FILTER_CARTOON:
        {
            locked = gpu_cartoonmap[index].locked;
            break;
        }
        case GROUP_STATIC_GPU_FILTER_COLOR:
        {
            locked = gpu_colormap[index].locked;
            break;
        }
        case GROUP_STATIC_GPU_FILTER_VINTAGE:
        {
            locked = gpu_vintagemap[index].locked;
            break;
        }
        case GROUP_STATIC_FILTER_GRUNGE:
        {
            locked     = grunge_maping[index].locked;
            //filterName = [NSString stringWithFormat:@"%s",grunge_maping[index].name];
            break;
        }
        case GROUP_STATIC_FILTER_BOKEH:
        {
            locked = bokeh_maping[index].locked;
            //filterName = [NSString stringWithFormat:@"%s",tone_maping[index].name];
            break;
        }
        case GROUP_STATIC_FILTER_SPACE:
        {
            locked = space_maping[index].locked;
            //filterName = [NSString stringWithFormat:@"%s",color_maping[index].name];
            break;
        }
#if NOISESET_SUPPORT
        case GROUP_STATIC_FILTER_NOISE:
        {
            break;
        }
#endif
        case GROUP_STATIC_FILTER_TEXTURE:
        {
            locked     = texture_maping[index].locked;
            //filterName = [NSString stringWithFormat:@"%s",texture_maping[index].name];
            break;
        }
        case  GROUP_FILTER_STATIC_FRAME:
        {
            locked     = frame_maping[index].locked;
            //filterName = [NSString stringWithFormat:@"%s",texture_maping[index].name];
            break;
        }
        case GROUP_STATIC_FILTER_LAST:
        default:
        {
            break;
        }
    }
    
    return locked;
#else
    return [self getLockStatusOfFilter:index group:grpId];
#endif
}

+(int)filterCountInGroup:(int)grpId
{
    int count = 0;
    switch(grpId)
    {
#if MIRRORSET_SUPPORT
        case GROUP_STATIC_FILTER_MIRROR:
        {
            count = MIRROR_LAST;
            break;
        }
#endif
#if TONEGROUP_SUPPORT
        case GROUP_STATIC_GPU_FILTER_TONE:
        {
            count = STATIC_GPU_FILTER_TONE_EFFECT_LAST;
            break;
        }
#endif
#if SKETCHGROUP_SUPPORT
        case GROUP_STATIC_GPU_FILTER_SKETCH:
        {
            count = STATIC_GPU_FILTER_SKETCH_EFFECT_LAST;
            break;
        }
#endif
#if COLORGROUP_SUPPORT
        case GROUP_STATIC_GPU_FILTER_COLOR:
        {
            count = STATIC_GPU_FILTER_COLOR_EFFECT_LAST;
            break;
        }
#endif
#if VINTAGEGROUP_SUPPORT
        case GROUP_STATIC_GPU_FILTER_VINTAGE:
        {
            count = STATIC_GPU_FILTER_VINTAGE_EFFECT_LAST;
            break;
        }
#endif
#if CARTOONGROUP_SUPPORT
        case GROUP_STATIC_GPU_FILTER_CARTOON:
        {
            count = STATIC_GPU_FILTER_TOON_EFFECT_LAST;
            break;
        }
#endif
#if GRUNGEGROUP_SUPPORT
        case GROUP_STATIC_FILTER_GRUNGE:
        {
            count = STATIC_FILTER_GRUNGE_LAST;
            break;
        }
#endif
#if BOKEHGROUP_SUPPORT
        case GROUP_STATIC_FILTER_BOKEH:
        {
            count = STATIC_FILTER_BOKEH_LAST;
            break;
        }
#endif
#if SPACEGROUP_SUPPORT
        case GROUP_STATIC_FILTER_SPACE:
        {
            count = STATIC_FILTER_SPACE_LAST;
            break;
        }
#endif
#if NOISESET_SUPPORT
        case GROUP_STATIC_FILTER_NOISE:
        {
            count = STATIC_FILTER_NOISE_LAST;
            break;
        }
#endif
#if TEXTUREGROUP_SUPPORT
        case GROUP_STATIC_FILTER_TEXTURE:
        {
            count = STATIC_FILTER_TEXTURE_LAST;
            break;
        }
#endif
#if FRAMEGROUP_SUPPORT
        case GROUP_STATIC_FILTER_FRAME:
        {
            count = STATIC_FILTER_FRAME_LAST;
            break;
        }
#endif
        case GROUP_STATIC_FILTER_LAST:
        {
            break;
        }
    }
    
    return count;
}

+(int)staticFilterGroupCount
{
    return GROUP_STATIC_FILTER_LAST;
}

@end
