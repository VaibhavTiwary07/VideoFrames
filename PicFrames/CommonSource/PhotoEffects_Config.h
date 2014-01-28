

#ifndef Instapicframes_PhotoEffects_Config_h
#define Instapicframes_PhotoEffects_Config_h


#define photoeffects_ProUpgradeProductId kInAppPurchaseProUpgradeProductId
#define photoeffects_AllEffects   kInAppPurchaseAllEffects
#define photoeffects_BokehPack    kInAppPurchaseBokehPack
#define photoeffects_CartoonPack  kInAppPurchaseCartoonPack
#define photoeffects_GrungePack   kInAppPurchaseGrungePack
#define photoeffects_SketchPack   kInAppPurchaseSketchPack
#define photoeffects_SpacePack    kInAppPurchaseSpacePack
#define photoeffects_TexturePack  kInAppPurchaseTexturePack
#define photoeffects_VintaePack   kInAppPurchaseVintaePack
#define photoeffects_FramePack    kInAppPurchaseFramePack
#define photoeffects_ColorPack    kInAppPurchaseColorPack

#define TAPPOINTS_TOUNLOCK_FILTER          5

#define PHOTOEFFECTS_MIRROR_SUPPORT        0
#define PHOTOEFFECTS_UPGRADES_SUPPORT      0
#define PHOTOEFFECTS_SHARE_SUPPORT         0
#define PHOTOEFFECTS_GPUIMAGE_SUPPORT      0
#define PHOTOEFFECTS_FLURRY_SUPPORT        0
#define PHOTOEFFECTS_INAPP_SUPPORT         0
#define PHOTOEFFECTS_ADSUPPORT             0
#define PHOTOEFFECTS_CONFORMATION_ONEXIT   1
#define PHOTOEFFECTS_LIVEIMAGE_FOR_FILTERS 0



    #define BOKEHGROUP_SUPPORT 0
    #define TEXTUREGROUP_SUPPORT 0
   #define FRAMEGROUP_SUPPORT 0
    #define COLORGROUP_SUPPORT 1
    #define VINTAGEGROUP_SUPPORT 0
    #define SKETCHGROUP_SUPPORT 0
    #define CARTOONGROUP_SUPPORT 0
    #define GRUNGEGROUP_SUPPORT 0
    #define  SPACEGROUP_SUPPORT 0
    #define TONEGROUP_SUPPORT   1



#define full_screen ([[UIScreen mainScreen]bounds])

#define tag_singleviewfinder     7001
#define tag_viewfinder           7002
#define tag_leftmirror           7003
#define tag_rightmirror          7004
#define tag_effecttoolbar        7005
#define tag_strengthslider       7006
#define tag_cameratoolbar        7007
#define tag_lockedcontenttoolbar 7008
#define tag_earnpointsalert       7009
#define tag_successfullunlockalert 7010
#define tag_discardchangesalert    7011
#define tag_holdingunlockedframe   7012
#define tag_holdinglockedframe   7013
#define tag_erasetoolbar          7014
#define tag_erasescrollbar          7015

#define toolbar_height    ((UIUserInterfaceIdiomPad == UI_USER_INTERFACE_IDIOM())?50.0:50.0)
#define bannerad_height   ((UIUserInterfaceIdiomPad == UI_USER_INTERFACE_IDIOM())?90.0:50.0)
#define scrollbar_height  ((full_screen.size.height > 480.0)?100.0:100.0)

#define SHARE_OPTIONS_COLOR ([UIColor colorWithRed:(44.0f/256.0f) green:(44.0f/256.0f) blue:(44.0f/256.0f) alpha:1.0])

#if PHOTOEFFECTS_MIRROR_SUPPORT
#define PHOTOEFFECTS_IMAGEDISPLAYVIEW_WIDTH   full_screen.size.width
#define PHOTOEFFECTS_IMAGEDISPLAYVIEW_HEIGHT  full_screen.size.width
#define PHOTOEFFECTS_CONTENT_MODE             UIViewContentModeScaleAspectFill
#define camera_y_calc_position (((full_screen.size.height - (bannerad_height-0) - toolbar_height - scrollbar_height)-full_screen.size.width)/2.0)
#define camera_y_position ((camera_y_calc_position < 0.0)?0.0:camera_y_calc_position)

#define bannerad_y_position  (full_screen.size.height - scrollbar_height - toolbar_height - bannerad_height)

#else
#define PHOTOEFFECTS_IMAGEDISPLAYVIEW_WIDTH   full_screen.size.width
#define PHOTOEFFECTS_IMAGEDISPLAYVIEW_HEIGHT  (full_screen.size.height - scrollbar_height -  toolbar_height)
#define PHOTOEFFECTS_CONTENT_MODE             UIViewContentModeScaleAspectFit
#define camera_y_calc_position (0.0)
#define camera_y_position (0.0)

#define bannerad_y_position  (full_screen.size.height - scrollbar_height - toolbar_height - bannerad_height)

#endif


#endif
