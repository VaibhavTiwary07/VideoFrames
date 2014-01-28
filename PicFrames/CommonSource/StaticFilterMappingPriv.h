//
//  StaticFilterMappingPriv.h
//  MirroFx
//
//  Created by Vijaya kumar reddy Doddavala on 10/17/12.
//  Copyright (c) 2012 Cell Phone. All rights reserved.
//

#ifndef MirroFx_StaticFilterMappingPriv_h
#define MirroFx_StaticFilterMappingPriv_h

#import "StaticFilterMapping.h"
typedef struct
{
    char         name[50];
    int          eType;
    BOOL         locked;
}tTexture;

typedef struct
{
    int eFilter;
    CGBlendMode eMode;
}tBlendModeMapping;

typedef struct
{
    int grpId;
    NSString *prdId;
}tPrdIdmapping;


#if PHOTOEFFECTS_MIRROR_SUPPORT
static tTexture mirror_maping[MIRROR_LAST] = {
    {"Left",            MIRROR_LEFT_HORIZANTAL,NO},
    {"Top Left",        MIRROR_BOTTOM_RIGHT,NO},
    {"Up",              MIRROR_UP_VERTIVAL,NO},
    {"Top Right",       MIRROR_BOTTOM_LEFT,NO},
    {"Right",           MIRROR_RIGHT_HORIZANTAL,NO},
    {"Bottom Right",    MIRROR_TOP_LEFT,NO},
    {"Down",            MIRROR_DOWN_VERTIVAL,NO},
    {"Bottom Left",     MIRROR_TOP_RIGHT,NO},
    {"No Mirror",       MIRROR_NONE,NO}
};
#endif
#if VINTAGEGROUP_SUPPORT
static tTexture gpu_vintagemap[STATIC_GPU_FILTER_VINTAGE_EFFECT_LAST]= {
    {"Classic",             STATIC_GPU_FILTER_VINTAGE_EFFECT1,NO},
    {"Cool",       STATIC_GPU_FILTER_VINTAGE_EFFECT2,NO},
    {"Magical",       STATIC_GPU_FILTER_VINTAGE_EFFECT3,YES},
    {"Dream",       STATIC_GPU_FILTER_VINTAGE_EFFECT4,YES},
    {"Film",       STATIC_GPU_FILTER_VINTAGE_EFFECT5,YES},
    {"Summer",       STATIC_GPU_FILTER_VINTAGE_EFFECT6,YES},
    {"ATN",       STATIC_GPU_FILTER_VINTAGE_EFFECT7,YES},
};
#endif
#if TONEGROUP_SUPPORT
static tTexture gpu_tonemap[STATIC_GPU_FILTER_TONE_EFFECT_LAST]= {
    {"HardColor",          STATIC_GPU_FILTER_TONE_EFFECT1,NO},
    {"Beach",          STATIC_GPU_FILTER_TONE_EFFECT2,NO},
    {"Retro",       STATIC_GPU_FILTER_TONE_EFFECT3,YES},
    {"SoftLight",       STATIC_GPU_FILTER_TONE_EFFECT4,YES},
    {"80's",       STATIC_GPU_FILTER_TONE_EFFECT5,YES},
    {"Abbi",       STATIC_GPU_FILTER_TONE_EFFECT6,YES},
    {"Winter",       STATIC_GPU_FILTER_TONE_EFFECT7,YES},
};
#endif
#if COLORGROUP_SUPPORT
static tTexture gpu_colormap[STATIC_GPU_FILTER_COLOR_EFFECT_LAST]= {
    {"Lomo",            STATIC_GPU_FILTER_COLOR_EFFECT1,NO},
    {"Lomo Jeans",      STATIC_GPU_FILTER_COLOR_EFFECT2,NO},
    {"Lomo Pencil",     STATIC_GPU_FILTER_COLOR_EFFECT3,NO},
    {"Retro",           STATIC_GPU_FILTER_COLOR_EFFECT4,YES},
    {"B&W",             STATIC_GPU_FILTER_COLOR_EFFECT5,YES},
    {"Dramatic B&W",    STATIC_GPU_FILTER_COLOR_EFFECT6,YES},
    {"Green",           STATIC_GPU_FILTER_COLOR_EFFECT7,YES},
    {"Sepia",           STATIC_GPU_FILTER_COLOR_EFFECT8,YES},
    {"Old Photo",       STATIC_GPU_FILTER_COLOR_EFFECT9,YES},
    {"Aqua",            STATIC_GPU_FILTER_COLOR_EFFECT10,YES},
    {"1970's",          STATIC_GPU_FILTER_COLOR_EFFECT11,YES},
    {"Color less",      STATIC_GPU_FILTER_COLOR_EFFECT12,YES},
    {"Soft Focus",      STATIC_GPU_FILTER_COLOR_EFFECT13,YES},
};
#endif
#if CARTOONGROUP_SUPPORT
static tTexture gpu_cartoonmap[STATIC_GPU_FILTER_TOON_EFFECT_LAST]= {
    {"Plain Toon",      STATIC_GPU_FILTER_TOON_EFFECT1,NO},
    {"Toon Paper",      STATIC_GPU_FILTER_TOON_EFFECT2,NO},
    {"Pencil Toon",     STATIC_GPU_FILTER_TOON_EFFECT3,YES},
    {"Crayon Toon",     STATIC_GPU_FILTER_TOON_EFFECT4,YES},
    {"Grunge Toon1",    STATIC_GPU_FILTER_TOON_EFFECT5,YES},
    {"Grunge Toon2",    STATIC_GPU_FILTER_TOON_EFFECT6,YES},
    {"Toon Jeans",      STATIC_GPU_FILTER_TOON_EFFECT7,YES},
};
#endif
#if SKETCHGROUP_SUPPORT
static tTexture gpu_sketchmap[STATIC_GPU_FILTER_SKETCH_EFFECT_LAST]= {
    {"Tone 1",          STATIC_GPU_FILTER_SKETCH_EFFECT1,NO},
    {"Tone 2",          STATIC_GPU_FILTER_SKETCH_EFFECT2,NO},
    {"Vintage 3",       STATIC_GPU_FILTER_SKETCH_EFFECT3,YES},
    {"Vintage 4",       STATIC_GPU_FILTER_SKETCH_EFFECT4,YES},
    {"Vintage 5",       STATIC_GPU_FILTER_SKETCH_EFFECT5,YES},
    {"Vintage 6",       STATIC_GPU_FILTER_SKETCH_EFFECT6,YES},
    {"Vintage 7",       STATIC_GPU_FILTER_SKETCH_EFFECT7,YES},
};
#endif


static tBlendModeMapping texture_modemap[STATIC_FILTER_TEXTURE_LAST] = {
    {STATIC_FILTER_TEXTURE_PAPER,kCGBlendModeOverlay},
    {STATIC_FILTER_TEXTURE_JEANS,kCGBlendModeOverlay},
    {STATIC_FILTER_TEXTURE_PAPER2,kCGBlendModeMultiply},
    {STATIC_FILTER_TEXTURE_COFFEE,kCGBlendModeMultiply},
    {STATIC_FILTER_TEXTURE_EARTH,kCGBlendModeMultiply},
    {STATIC_FILTER_TEXTURE_PAINTPEEL,kCGBlendModeMultiply},
    {STATIC_FILTER_TEXTURE_CONCRETE,kCGBlendModeOverlay},
    {STATIC_FILTER_TEXTURE_WALL,kCGBlendModeOverlay},
    {STATIC_FILTER_TEXTURE_STEEL,kCGBlendModeOverlay},
    {STATIC_FILTER_TEXTURE_OLDPAPER,kCGBlendModeOverlay},
    {STATIC_FILTER_TEXTURE_CARDBOARD,kCGBlendModeOverlay},
    {STATIC_FILTER_TEXTURE_PENCIL,kCGBlendModeOverlay},
    {STATIC_FILTER_TEXTURE_STROKES,kCGBlendModeOverlay}
};

static tTexture texture_maping[STATIC_FILTER_TEXTURE_LAST] = {
    {"Paper",           STATIC_FILTER_TEXTURE_PAPER,NO},
    {"Jeans",           STATIC_FILTER_TEXTURE_JEANS,NO},
    {"Paper2",          STATIC_FILTER_TEXTURE_PAPER2,NO},
    {"Coffee Stain",    STATIC_FILTER_TEXTURE_COFFEE,NO},
    {"Earth Crack",     STATIC_FILTER_TEXTURE_EARTH,NO},
    {"Peeling Paint",   STATIC_FILTER_TEXTURE_PAINTPEEL,YES},
    {"Concrete",        STATIC_FILTER_TEXTURE_CONCRETE,YES},
    {"Wall",            STATIC_FILTER_TEXTURE_WALL,YES},
    {"Steel",           STATIC_FILTER_TEXTURE_STEEL,YES},
    {"Old Paper",       STATIC_FILTER_TEXTURE_OLDPAPER,YES},
    {"Cardboard",       STATIC_FILTER_TEXTURE_CARDBOARD,YES},
    {"Pencil",          STATIC_FILTER_TEXTURE_PENCIL,YES},
    {"Pencilcross",     STATIC_FILTER_TEXTURE_STROKES,YES}
};



static tTexture grunge_maping[STATIC_FILTER_GRUNGE_LAST] = {
    {"grunge1",         STATIC_FILTER_GRUNGE1,NO},
    {"grunge2",         STATIC_FILTER_GRUNGE2,NO},
    {"grunge3",         STATIC_FILTER_GRUNGE3,NO},
    {"grunge4",         STATIC_FILTER_GRUNGE4,YES},
    {"grunge5",         STATIC_FILTER_GRUNGE5,YES},
    {"grunge6",         STATIC_FILTER_GRUNGE6,NO},
    {"grunge7",         STATIC_FILTER_GRUNGE7,YES},
    {"grunge8",         STATIC_FILTER_GRUNGE8,YES},
    {"grunge9",         STATIC_FILTER_GRUNGE9,NO},
    {"grunge10",        STATIC_FILTER_GRUNGE10,YES},
    {"grunge11",        STATIC_FILTER_GRUNGE11,YES},
    {"grunge12",        STATIC_FILTER_GRUNGE12,NO},
    {"grunge13",        STATIC_FILTER_GRUNGE13,YES},
    {"grunge14",        STATIC_FILTER_GRUNGE14,YES},
    {"grunge15",        STATIC_FILTER_GRUNGE15,NO},
    {"grunge16",        STATIC_FILTER_GRUNGE16,YES},
    {"grunge17",        STATIC_FILTER_GRUNGE17,YES},
    {"grunge18",        STATIC_FILTER_GRUNGE18,YES},
    {"grunge19",        STATIC_FILTER_GRUNGE19,NO},
    {"grunge20",        STATIC_FILTER_GRUNGE20,YES},
    {"grunge21",        STATIC_FILTER_GRUNGE21,YES},
    {"grunge22",        STATIC_FILTER_GRUNGE22,NO}
};

#if BOKEHGROUP_SUPPORT
static tTexture bokeh_maping[STATIC_FILTER_BOKEH_LAST] = {
    {"bokeh1",          STATIC_FILTER_BOKEH1,NO},
    {"bokeh2",          STATIC_FILTER_BOKEH2,NO},
    {"bokeh3",          STATIC_FILTER_BOKEH3,NO},
    {"bokeh4",          STATIC_FILTER_BOKEH4,YES},
    {"bokeh5",          STATIC_FILTER_BOKEH5,YES},
    {"bokeh6",          STATIC_FILTER_BOKEH6,NO},
    {"bokeh7",          STATIC_FILTER_BOKEH7,YES},
    {"bokeh8",          STATIC_FILTER_BOKEH8,YES},
    {"bokeh9",          STATIC_FILTER_BOKEH9,YES},
    {"bokeh10",         STATIC_FILTER_BOKEH10,YES},
    {"bokeh11",         STATIC_FILTER_BOKEH11,YES},
    {"bokeh12",         STATIC_FILTER_BOKEH12,YES},
    {"bokeh13",         STATIC_FILTER_BOKEH13,NO},
    {"bokeh14",         STATIC_FILTER_BOKEH14,NO},
    {"bokeh15",         STATIC_FILTER_BOKEH15,NO},
    {"bokeh16",         STATIC_FILTER_BOKEH16,YES},
    {"bokeh17",         STATIC_FILTER_BOKEH17,YES},
    {"bokeh18",          STATIC_FILTER_BOKEH18,NO},
    {"bokeh19",          STATIC_FILTER_BOKEH19,YES},
    {"bokeh20",          STATIC_FILTER_BOKEH20,NO},
    {"bokeh21",          STATIC_FILTER_BOKEH21,YES},
    {"bokeh22",          STATIC_FILTER_BOKEH22,YES},
    {"bokeh23",          STATIC_FILTER_BOKEH23,YES},
    {"bokeh24",          STATIC_FILTER_BOKEH24,YES},
    {"bokeh25",          STATIC_FILTER_BOKEH25,YES},
    {"bokeh26",          STATIC_FILTER_BOKEH26,YES},
    {"bokeh27",          STATIC_FILTER_BOKEH27,YES},
    {"bokeh28",          STATIC_FILTER_BOKEH28,NO},
    {"bokeh29",          STATIC_FILTER_BOKEH29,YES},
    {"bokeh30",          STATIC_FILTER_BOKEH30,YES},
    
};
#endif

static tTexture frame_maping[STATIC_FILTER_FRAME_LAST] = {
    {"frame1",          STATIC_FILTER_FRAME1,NO},
    {"frame2",          STATIC_FILTER_FRAME2,NO},
    {"frame3",          STATIC_FILTER_FRAME3,NO},
    {"frame4",          STATIC_FILTER_FRAME4,YES},
    {"frame5",          STATIC_FILTER_FRAME5,YES},
    {"frame6",          STATIC_FILTER_FRAME6,NO},
    {"frame7",          STATIC_FILTER_FRAME7,NO},
    {"frame8",          STATIC_FILTER_FRAME8,YES},
    {"frame9",          STATIC_FILTER_FRAME9,YES},
    {"frame10",         STATIC_FILTER_FRAME10,YES},
    {"frame11",         STATIC_FILTER_FRAME11,NO},
    {"frame12",         STATIC_FILTER_FRAME12,NO},
    {"frame13",         STATIC_FILTER_FRAME13,YES},
    {"frame14",         STATIC_FILTER_FRAME14,YES},
    {"frame15",         STATIC_FILTER_FRAME15,YES},
    {"frame16",         STATIC_FILTER_FRAME16,NO},
    {"frame17",         STATIC_FILTER_FRAME17,YES},
    {"frame18",         STATIC_FILTER_FRAME18,NO},
    {"frame19",         STATIC_FILTER_FRAME19,YES},
    {"frame20",         STATIC_FILTER_FRAME20,NO},
    {"frame21",         STATIC_FILTER_FRAME21,NO},
    {"frame22",         STATIC_FILTER_FRAME22,YES},
    {"frame23",         STATIC_FILTER_FRAME23,NO},
    {"frame24",         STATIC_FILTER_FRAME24,YES},
    {"frame25",         STATIC_FILTER_FRAME25,YES},
    {"NoFrame",         STATIC_FILTER_FRAME26,NO},
    
};
#if SPACEGROUP_SUPPORT
static tTexture space_maping[STATIC_FILTER_SPACE_LAST] = {
    {"Asteroid",        STATIC_FILTER_SPACE_ASTEROID,NO},
    {"Dark Red",        STATIC_FILTER_SPACE_DARKRED,NO},
    {"Deep Sky",        STATIC_FILTER_SPACE_DEEPSKY,NO},
    {"Rays",            STATIC_FILTER_SPACE_RAYS,YES},
    {"Space Lights",    STATIC_FILTER_SPACE_LIGHTS,YES},
    {"Sparkles",        STATIC_FILTER_SPACE_SPARKLES,YES},
    {"Golden Red",      STATIC_FILTER_SPACE_GOLDENRED,YES},
    {"Mixed Color",     STATIC_FILTER_SPACE_MIXEDCOLOR,YES},
    {"Nebula Storm",    STATIC_FILTER_SPACE_NEBULASTORM,YES},
    {"Orange Space",    STATIC_FILTER_SPACE_ORANGESPACE,YES},
    {"Space Dust",      STATIC_FILTER_SPACE_DUST,YES},
    {"Space Grunge",    STATIC_FILTER_SPACE_GRUNGE1,YES},
    {"Space Grunge2",   STATIC_FILTER_SPACE_GRUNGE2,YES}
    
};


static tBlendModeMapping space_modemap[STATIC_FILTER_SPACE_LAST] = {
    {STATIC_FILTER_SPACE_ASTEROID,kCGBlendModeOverlay},
    {STATIC_FILTER_SPACE_DARKRED,kCGBlendModeOverlay},
    {STATIC_FILTER_SPACE_DEEPSKY,kCGBlendModePlusLighter},
    {STATIC_FILTER_SPACE_RAYS,kCGBlendModePlusLighter},
    {STATIC_FILTER_SPACE_LIGHTS,kCGBlendModePlusLighter},
    {STATIC_FILTER_SPACE_SPARKLES,kCGBlendModePlusLighter},
    {STATIC_FILTER_SPACE_GOLDENRED,kCGBlendModeOverlay},
    {STATIC_FILTER_SPACE_MIXEDCOLOR,kCGBlendModeOverlay},
    {STATIC_FILTER_SPACE_NEBULASTORM,kCGBlendModeOverlay},
    {STATIC_FILTER_SPACE_ORANGESPACE,kCGBlendModeOverlay},
    {STATIC_FILTER_SPACE_DUST,kCGBlendModeOverlay},
    {STATIC_FILTER_SPACE_GRUNGE1,kCGBlendModePlusLighter},
    {STATIC_FILTER_SPACE_GRUNGE2,kCGBlendModePlusLighter}
    
};
#endif
#endif
