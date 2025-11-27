import Foundation
#if canImport(AppKit)
import AppKit
#endif
#if canImport(UIKit)
import UIKit
#endif
#if canImport(SwiftUI)
import SwiftUI
#endif
#if canImport(DeveloperToolsSupport)
import DeveloperToolsSupport
#endif

#if SWIFT_PACKAGE
private let resourceBundle = Foundation.Bundle.module
#else
private class ResourceBundleClass {}
private let resourceBundle = Foundation.Bundle(for: ResourceBundleClass.self)
#endif

// MARK: - Color Symbols -

@available(iOS 11.0, macOS 10.13, tvOS 11.0, *)
extension ColorResource {

    /// The "rw-dark" asset catalog color resource.
    static let rwDark = ColorResource(name: "rw-dark", bundle: resourceBundle)

    /// The "rw-green" asset catalog color resource.
    static let rwGreen = ColorResource(name: "rw-green", bundle: resourceBundle)

    /// The "rw-light" asset catalog color resource.
    static let rwLight = ColorResource(name: "rw-light", bundle: resourceBundle)

}

// MARK: - Image Symbols -

@available(iOS 11.0, macOS 10.7, tvOS 11.0, *)
extension ImageResource {

    /// The "16_9" asset catalog image resource.
    static let _16_9 = ImageResource(name: "16_9", bundle: resourceBundle)

    /// The "1_1" asset catalog image resource.
    static let _1_1 = ImageResource(name: "1_1", bundle: resourceBundle)

    /// The "1_2" asset catalog image resource.
    static let _1_2 = ImageResource(name: "1_2", bundle: resourceBundle)

    /// The "1gridPopupBg2" asset catalog image resource.
    static let _1GridPopupBg2 = ImageResource(name: "1gridPopupBg2", bundle: resourceBundle)

    /// The "2_1" asset catalog image resource.
    static let _2_1 = ImageResource(name: "2_1", bundle: resourceBundle)

    /// The "2_3" asset catalog image resource.
    static let _2_3 = ImageResource(name: "2_3", bundle: resourceBundle)

    /// The "3_2" asset catalog image resource.
    static let _3_2 = ImageResource(name: "3_2", bundle: resourceBundle)

    /// The "3_4" asset catalog image resource.
    static let _3_4 = ImageResource(name: "3_4", bundle: resourceBundle)

    /// The "4_3" asset catalog image resource.
    static let _4_3 = ImageResource(name: "4_3", bundle: resourceBundle)

    /// The "4_5" asset catalog image resource.
    static let _4_5 = ImageResource(name: "4_5", bundle: resourceBundle)

    /// The "4_6" asset catalog image resource.
    static let _4_6 = ImageResource(name: "4_6", bundle: resourceBundle)

    /// The "5_4" asset catalog image resource.
    static let _5_4 = ImageResource(name: "5_4", bundle: resourceBundle)

    /// The "5_7" asset catalog image resource.
    static let _5_7 = ImageResource(name: "5_7", bundle: resourceBundle)

    /// The "7Wonders_1_ChichenItzaMexico" asset catalog image resource.
    static let _7Wonders1ChichenItzaMexico = ImageResource(name: "7Wonders_1_ChichenItzaMexico", bundle: resourceBundle)

    /// The "7Wonders_2_MachuPicchuPeru" asset catalog image resource.
    static let _7Wonders2MachuPicchuPeru = ImageResource(name: "7Wonders_2_MachuPicchuPeru", bundle: resourceBundle)

    /// The "7Wonders_3_Colosseumtaly" asset catalog image resource.
    static let _7Wonders3Colosseumtaly = ImageResource(name: "7Wonders_3_Colosseumtaly", bundle: resourceBundle)

    /// The "7Wonders_4_petraJordan" asset catalog image resource.
    static let _7Wonders4PetraJordan = ImageResource(name: "7Wonders_4_petraJordan", bundle: resourceBundle)

    /// The "7Wonders_5_GreatWallofChina" asset catalog image resource.
    static let _7Wonders5GreatWallofChina = ImageResource(name: "7Wonders_5_GreatWallofChina", bundle: resourceBundle)

    /// The "7Wonders_6_TajMahalndia" asset catalog image resource.
    static let _7Wonders6TajMahalndia = ImageResource(name: "7Wonders_6_TajMahalndia", bundle: resourceBundle)

    /// The "7Wonders_7_ChristRedeemerBrazil" asset catalog image resource.
    static let _7Wonders7ChristRedeemerBrazil = ImageResource(name: "7Wonders_7_ChristRedeemerBrazil", bundle: resourceBundle)

    /// The "8_10" asset catalog image resource.
    static let _8_10 = ImageResource(name: "8_10", bundle: resourceBundle)

    /// The "9_16" asset catalog image resource.
    static let _9_16 = ImageResource(name: "9_16", bundle: resourceBundle)

    /// The "Gallery" asset catalog image resource.
    static let gallery = ImageResource(name: "Gallery", bundle: resourceBundle)

    /// The "Gradients_0" asset catalog image resource.
    static let gradients0 = ImageResource(name: "Gradients_0", bundle: resourceBundle)

    /// The "Gradients_1" asset catalog image resource.
    static let gradients1 = ImageResource(name: "Gradients_1", bundle: resourceBundle)

    /// The "Gradients_10" asset catalog image resource.
    static let gradients10 = ImageResource(name: "Gradients_10", bundle: resourceBundle)

    /// The "Gradients_11" asset catalog image resource.
    static let gradients11 = ImageResource(name: "Gradients_11", bundle: resourceBundle)

    /// The "Gradients_12" asset catalog image resource.
    static let gradients12 = ImageResource(name: "Gradients_12", bundle: resourceBundle)

    /// The "Gradients_13" asset catalog image resource.
    static let gradients13 = ImageResource(name: "Gradients_13", bundle: resourceBundle)

    /// The "Gradients_14" asset catalog image resource.
    static let gradients14 = ImageResource(name: "Gradients_14", bundle: resourceBundle)

    /// The "Gradients_15" asset catalog image resource.
    static let gradients15 = ImageResource(name: "Gradients_15", bundle: resourceBundle)

    /// The "Gradients_16" asset catalog image resource.
    static let gradients16 = ImageResource(name: "Gradients_16", bundle: resourceBundle)

    /// The "Gradients_17" asset catalog image resource.
    static let gradients17 = ImageResource(name: "Gradients_17", bundle: resourceBundle)

    /// The "Gradients_18" asset catalog image resource.
    static let gradients18 = ImageResource(name: "Gradients_18", bundle: resourceBundle)

    /// The "Gradients_19" asset catalog image resource.
    static let gradients19 = ImageResource(name: "Gradients_19", bundle: resourceBundle)

    /// The "Gradients_2" asset catalog image resource.
    static let gradients2 = ImageResource(name: "Gradients_2", bundle: resourceBundle)

    /// The "Gradients_20" asset catalog image resource.
    static let gradients20 = ImageResource(name: "Gradients_20", bundle: resourceBundle)

    /// The "Gradients_3" asset catalog image resource.
    static let gradients3 = ImageResource(name: "Gradients_3", bundle: resourceBundle)

    /// The "Gradients_4" asset catalog image resource.
    static let gradients4 = ImageResource(name: "Gradients_4", bundle: resourceBundle)

    /// The "Gradients_5" asset catalog image resource.
    static let gradients5 = ImageResource(name: "Gradients_5", bundle: resourceBundle)

    /// The "Gradients_6" asset catalog image resource.
    static let gradients6 = ImageResource(name: "Gradients_6", bundle: resourceBundle)

    /// The "Gradients_7" asset catalog image resource.
    static let gradients7 = ImageResource(name: "Gradients_7", bundle: resourceBundle)

    /// The "Gradients_8" asset catalog image resource.
    static let gradients8 = ImageResource(name: "Gradients_8", bundle: resourceBundle)

    /// The "Gradients_9" asset catalog image resource.
    static let gradients9 = ImageResource(name: "Gradients_9", bundle: resourceBundle)

    /// The "Home" asset catalog image resource.
    static let home = ImageResource(name: "Home", bundle: resourceBundle)

    /// The "ItunesArtwork" asset catalog image resource.
    static let itunesArtwork = ImageResource(name: "ItunesArtwork", bundle: resourceBundle)

    /// The "MoreIconNew" asset catalog image resource.
    static let moreIconNew = ImageResource(name: "MoreIconNew", bundle: resourceBundle)

    /// The "ProBadge" asset catalog image resource.
    static let proBadge = ImageResource(name: "ProBadge", bundle: resourceBundle)

    /// The "Ratio" asset catalog image resource.
    static let ratio = ImageResource(name: "Ratio", bundle: resourceBundle)

    /// The "Ratio_Fill" asset catalog image resource.
    static let ratioFill = ImageResource(name: "Ratio_Fill", bundle: resourceBundle)

    /// The "Ratio_Fill_active" asset catalog image resource.
    static let ratioFillActive = ImageResource(name: "Ratio_Fill_active", bundle: resourceBundle)

    /// The "Ratio_active" asset catalog image resource.
    static let ratioActive = ImageResource(name: "Ratio_active", bundle: resourceBundle)

    /// The "Res_button" asset catalog image resource.
    static let resButton = ImageResource(name: "Res_button", bundle: resourceBundle)

    /// The "Resume_screen" asset catalog image resource.
    static let resumeScreen = ImageResource(name: "Resume_screen", bundle: resourceBundle)

    /// The "Sidecon" asset catalog image resource.
    static let sidecon = ImageResource(name: "Sidecon", bundle: resourceBundle)

    /// The "VideoCollagelogo" asset catalog image resource.
    static let videoCollagelogo = ImageResource(name: "VideoCollagelogo", bundle: resourceBundle)

    /// The "add" asset catalog image resource.
    static let add = ImageResource(name: "add", bundle: resourceBundle)

    /// The "add_05" asset catalog image resource.
    static let add05 = ImageResource(name: "add_05", bundle: resourceBundle)

    /// The "adjust2" asset catalog image resource.
    static let adjust2 = ImageResource(name: "adjust2", bundle: resourceBundle)

    /// The "adjust_active2" asset catalog image resource.
    static let adjustActive2 = ImageResource(name: "adjust_active2", bundle: resourceBundle)

    /// The "album2" asset catalog image resource.
    static let album2 = ImageResource(name: "album2", bundle: resourceBundle)

    /// The "album_active2" asset catalog image resource.
    static let albumActive2 = ImageResource(name: "album_active2", bundle: resourceBundle)

    /// The "alphabets_10_j" asset catalog image resource.
    static let alphabets10J = ImageResource(name: "alphabets_10_j", bundle: resourceBundle)

    /// The "alphabets_11_k" asset catalog image resource.
    static let alphabets11K = ImageResource(name: "alphabets_11_k", bundle: resourceBundle)

    /// The "alphabets_12_l" asset catalog image resource.
    static let alphabets12L = ImageResource(name: "alphabets_12_l", bundle: resourceBundle)

    /// The "alphabets_13_m" asset catalog image resource.
    static let alphabets13M = ImageResource(name: "alphabets_13_m", bundle: resourceBundle)

    /// The "alphabets_14_n" asset catalog image resource.
    static let alphabets14N = ImageResource(name: "alphabets_14_n", bundle: resourceBundle)

    /// The "alphabets_15_o" asset catalog image resource.
    static let alphabets15O = ImageResource(name: "alphabets_15_o", bundle: resourceBundle)

    /// The "alphabets_16_p" asset catalog image resource.
    static let alphabets16P = ImageResource(name: "alphabets_16_p", bundle: resourceBundle)

    /// The "alphabets_17_q" asset catalog image resource.
    static let alphabets17Q = ImageResource(name: "alphabets_17_q", bundle: resourceBundle)

    /// The "alphabets_18_r" asset catalog image resource.
    static let alphabets18R = ImageResource(name: "alphabets_18_r", bundle: resourceBundle)

    /// The "alphabets_19_s" asset catalog image resource.
    static let alphabets19S = ImageResource(name: "alphabets_19_s", bundle: resourceBundle)

    /// The "alphabets_1_a" asset catalog image resource.
    static let alphabets1A = ImageResource(name: "alphabets_1_a", bundle: resourceBundle)

    /// The "alphabets_20_t" asset catalog image resource.
    static let alphabets20T = ImageResource(name: "alphabets_20_t", bundle: resourceBundle)

    /// The "alphabets_21_u" asset catalog image resource.
    static let alphabets21U = ImageResource(name: "alphabets_21_u", bundle: resourceBundle)

    /// The "alphabets_22_v" asset catalog image resource.
    static let alphabets22V = ImageResource(name: "alphabets_22_v", bundle: resourceBundle)

    /// The "alphabets_23_w" asset catalog image resource.
    static let alphabets23W = ImageResource(name: "alphabets_23_w", bundle: resourceBundle)

    /// The "alphabets_24_x" asset catalog image resource.
    static let alphabets24X = ImageResource(name: "alphabets_24_x", bundle: resourceBundle)

    /// The "alphabets_25_y" asset catalog image resource.
    static let alphabets25Y = ImageResource(name: "alphabets_25_y", bundle: resourceBundle)

    /// The "alphabets_26_z" asset catalog image resource.
    static let alphabets26Z = ImageResource(name: "alphabets_26_z", bundle: resourceBundle)

    /// The "alphabets_2_b" asset catalog image resource.
    static let alphabets2B = ImageResource(name: "alphabets_2_b", bundle: resourceBundle)

    /// The "alphabets_3_c" asset catalog image resource.
    static let alphabets3C = ImageResource(name: "alphabets_3_c", bundle: resourceBundle)

    /// The "alphabets_4_d" asset catalog image resource.
    static let alphabets4D = ImageResource(name: "alphabets_4_d", bundle: resourceBundle)

    /// The "alphabets_5_e" asset catalog image resource.
    static let alphabets5E = ImageResource(name: "alphabets_5_e", bundle: resourceBundle)

    /// The "alphabets_6_f" asset catalog image resource.
    static let alphabets6F = ImageResource(name: "alphabets_6_f", bundle: resourceBundle)

    /// The "alphabets_7_g" asset catalog image resource.
    static let alphabets7G = ImageResource(name: "alphabets_7_g", bundle: resourceBundle)

    /// The "alphabets_8_h" asset catalog image resource.
    static let alphabets8H = ImageResource(name: "alphabets_8_h", bundle: resourceBundle)

    /// The "alphabets_9_i" asset catalog image resource.
    static let alphabets9I = ImageResource(name: "alphabets_9_i", bundle: resourceBundle)

    /// The "animals_1_panda" asset catalog image resource.
    static let animals1Panda = ImageResource(name: "animals_1_panda", bundle: resourceBundle)

    /// The "animals_2_bearwithredhearteyesmiling" asset catalog image resource.
    static let animals2Bearwithredhearteyesmiling = ImageResource(name: "animals_2_bearwithredhearteyesmiling", bundle: resourceBundle)

    /// The "animals_3_mouse" asset catalog image resource.
    static let animals3Mouse = ImageResource(name: "animals_3_mouse", bundle: resourceBundle)

    /// The "animals_4_rabbit" asset catalog image resource.
    static let animals4Rabbit = ImageResource(name: "animals_4_rabbit", bundle: resourceBundle)

    /// The "animals_5_pig" asset catalog image resource.
    static let animals5Pig = ImageResource(name: "animals_5_pig", bundle: resourceBundle)

    /// The "animals_6_cat" asset catalog image resource.
    static let animals6Cat = ImageResource(name: "animals_6_cat", bundle: resourceBundle)

    /// The "animals_7_angrybear" asset catalog image resource.
    static let animals7Angrybear = ImageResource(name: "animals_7_angrybear", bundle: resourceBundle)

    /// The "animals_8_cowwithblackspects" asset catalog image resource.
    static let animals8Cowwithblackspects = ImageResource(name: "animals_8_cowwithblackspects", bundle: resourceBundle)

    /// The "animals_9_frog" asset catalog image resource.
    static let animals9Frog = ImageResource(name: "animals_9_frog", bundle: resourceBundle)

    /// The "apple" asset catalog image resource.
    static let apple = ImageResource(name: "apple", bundle: resourceBundle)

    /// The "autumn" asset catalog image resource.
    static let autumn = ImageResource(name: "autumn", bundle: resourceBundle)

    /// The "autumn_0" asset catalog image resource.
    static let autumn0 = ImageResource(name: "autumn_0", bundle: resourceBundle)

    /// The "autumn_1" asset catalog image resource.
    static let autumn1 = ImageResource(name: "autumn_1", bundle: resourceBundle)

    /// The "autumn_2" asset catalog image resource.
    static let autumn2 = ImageResource(name: "autumn_2", bundle: resourceBundle)

    /// The "autumn_3" asset catalog image resource.
    static let autumn3 = ImageResource(name: "autumn_3", bundle: resourceBundle)

    /// The "autumn_4" asset catalog image resource.
    static let autumn4 = ImageResource(name: "autumn_4", bundle: resourceBundle)

    /// The "autumn_5" asset catalog image resource.
    static let autumn5 = ImageResource(name: "autumn_5", bundle: resourceBundle)

    /// The "autumn_6" asset catalog image resource.
    static let autumn6 = ImageResource(name: "autumn_6", bundle: resourceBundle)

    /// The "autumn_7" asset catalog image resource.
    static let autumn7 = ImageResource(name: "autumn_7", bundle: resourceBundle)

    /// The "autumn_8" asset catalog image resource.
    static let autumn8 = ImageResource(name: "autumn_8", bundle: resourceBundle)

    /// The "baby_10_welcomebaby" asset catalog image resource.
    static let baby10Welcomebaby = ImageResource(name: "baby_10_welcomebaby", bundle: resourceBundle)

    /// The "baby_11_welcomebaby" asset catalog image resource.
    static let baby11Welcomebaby = ImageResource(name: "baby_11_welcomebaby", bundle: resourceBundle)

    /// The "baby_12_welcomebaby" asset catalog image resource.
    static let baby12Welcomebaby = ImageResource(name: "baby_12_welcomebaby", bundle: resourceBundle)

    /// The "baby_13_welcomeboybaby" asset catalog image resource.
    static let baby13Welcomeboybaby = ImageResource(name: "baby_13_welcomeboybaby", bundle: resourceBundle)

    /// The "baby_14_itsagirlbaby" asset catalog image resource.
    static let baby14Itsagirlbaby = ImageResource(name: "baby_14_itsagirlbaby", bundle: resourceBundle)

    /// The "baby_15_itsaboybaby" asset catalog image resource.
    static let baby15Itsaboybaby = ImageResource(name: "baby_15_itsaboybaby", bundle: resourceBundle)

    /// The "baby_16_welcomegirlbaby" asset catalog image resource.
    static let baby16Welcomegirlbaby = ImageResource(name: "baby_16_welcomegirlbaby", bundle: resourceBundle)

    /// The "baby_17_welcomebaby" asset catalog image resource.
    static let baby17Welcomebaby = ImageResource(name: "baby_17_welcomebaby", bundle: resourceBundle)

    /// The "baby_18_welcomebaby" asset catalog image resource.
    static let baby18Welcomebaby = ImageResource(name: "baby_18_welcomebaby", bundle: resourceBundle)

    /// The "baby_19_hellobaby" asset catalog image resource.
    static let baby19Hellobaby = ImageResource(name: "baby_19_hellobaby", bundle: resourceBundle)

    /// The "baby_1_helobabydolphin" asset catalog image resource.
    static let baby1Helobabydolphin = ImageResource(name: "baby_1_helobabydolphin", bundle: resourceBundle)

    /// The "baby_20_itsagirl" asset catalog image resource.
    static let baby20Itsagirl = ImageResource(name: "baby_20_itsagirl", bundle: resourceBundle)

    /// The "baby_21_babyshower" asset catalog image resource.
    static let baby21Babyshower = ImageResource(name: "baby_21_babyshower", bundle: resourceBundle)

    /// The "baby_2_babyshower" asset catalog image resource.
    static let baby2Babyshower = ImageResource(name: "baby_2_babyshower", bundle: resourceBundle)

    /// The "baby_3_welcomebaby" asset catalog image resource.
    static let baby3Welcomebaby = ImageResource(name: "baby_3_welcomebaby", bundle: resourceBundle)

    /// The "baby_4_babyshowerelement" asset catalog image resource.
    static let baby4Babyshowerelement = ImageResource(name: "baby_4_babyshowerelement", bundle: resourceBundle)

    /// The "baby_5_welcomebbabysocks" asset catalog image resource.
    static let baby5Welcomebbabysocks = ImageResource(name: "baby_5_welcomebbabysocks", bundle: resourceBundle)

    /// The "baby_6_welcomebaby" asset catalog image resource.
    static let baby6Welcomebaby = ImageResource(name: "baby_6_welcomebaby", bundle: resourceBundle)

    /// The "baby_7_hellobaby" asset catalog image resource.
    static let baby7Hellobaby = ImageResource(name: "baby_7_hellobaby", bundle: resourceBundle)

    /// The "baby_8_babyshower" asset catalog image resource.
    static let baby8Babyshower = ImageResource(name: "baby_8_babyshower", bundle: resourceBundle)

    /// The "baby_9_itsaboybaby" asset catalog image resource.
    static let baby9Itsaboybaby = ImageResource(name: "baby_9_itsaboybaby", bundle: resourceBundle)

    /// The "back2" asset catalog image resource.
    static let back2 = ImageResource(name: "back2", bundle: resourceBundle)

    /// The "back_svg" asset catalog image resource.
    static let backSvg = ImageResource(name: "back_svg", bundle: resourceBundle)

    /// The "backsub" asset catalog image resource.
    static let backsub = ImageResource(name: "backsub", bundle: resourceBundle)

    /// The "balloons" asset catalog image resource.
    static let balloons = ImageResource(name: "balloons", bundle: resourceBundle)

    /// The "banner_Image2" asset catalog image resource.
    static let bannerImage2 = ImageResource(name: "banner_Image2", bundle: resourceBundle)

    /// The "beach_10_lemonadeinglassjarwithstraw" asset catalog image resource.
    static let beach10Lemonadeinglassjarwithstraw = ImageResource(name: "beach_10_lemonadeinglassjarwithstraw", bundle: resourceBundle)

    /// The "beach_11_tendercoconutwithstrawumbrella" asset catalog image resource.
    static let beach11Tendercoconutwithstrawumbrella = ImageResource(name: "beach_11_tendercoconutwithstrawumbrella", bundle: resourceBundle)

    /// The "beach_12_pineapplewithsunglassescartoon" asset catalog image resource.
    static let beach12Pineapplewithsunglassescartoon = ImageResource(name: "beach_12_pineapplewithsunglassescartoon", bundle: resourceBundle)

    /// The "beach_1_watermelon" asset catalog image resource.
    static let beach1Watermelon = ImageResource(name: "beach_1_watermelon", bundle: resourceBundle)

    /// The "beach_2_tree" asset catalog image resource.
    static let beach2Tree = ImageResource(name: "beach_2_tree", bundle: resourceBundle)

    /// The "beach_3_pineapplewithredheartsunglasses" asset catalog image resource.
    static let beach3Pineapplewithredheartsunglasses = ImageResource(name: "beach_3_pineapplewithredheartsunglasses", bundle: resourceBundle)

    /// The "beach_4_yellowUmbrella" asset catalog image resource.
    static let beach4YellowUmbrella = ImageResource(name: "beach_4_yellowUmbrella", bundle: resourceBundle)

    /// The "beach_5_blackhearteyesunglasses" asset catalog image resource.
    static let beach5Blackhearteyesunglasses = ImageResource(name: "beach_5_blackhearteyesunglasses", bundle: resourceBundle)

    /// The "beach_6_chocolateicecreame" asset catalog image resource.
    static let beach6Chocolateicecreame = ImageResource(name: "beach_6_chocolateicecreame", bundle: resourceBundle)

    /// The "beach_7_slippers" asset catalog image resource.
    static let beach7Slippers = ImageResource(name: "beach_7_slippers", bundle: resourceBundle)

    /// The "beach_8_tendercoconutwithstrawflower" asset catalog image resource.
    static let beach8Tendercoconutwithstrawflower = ImageResource(name: "beach_8_tendercoconutwithstrawflower", bundle: resourceBundle)

    /// The "beach_9_duckballon" asset catalog image resource.
    static let beach9Duckballon = ImageResource(name: "beach_9_duckballon", bundle: resourceBundle)

    /// The "bg_1stscreen" asset catalog image resource.
    static let bg1Stscreen = ImageResource(name: "bg_1stscreen", bundle: resourceBundle)

    /// The "birthday" asset catalog image resource.
    static let birthday = ImageResource(name: "birthday", bundle: resourceBundle)

    /// The "birthday_0" asset catalog image resource.
    static let birthday0 = ImageResource(name: "birthday_0", bundle: resourceBundle)

    /// The "birthday_1" asset catalog image resource.
    static let birthday1 = ImageResource(name: "birthday_1", bundle: resourceBundle)

    /// The "birthday_10" asset catalog image resource.
    static let birthday10 = ImageResource(name: "birthday_10", bundle: resourceBundle)

    /// The "birthday_2" asset catalog image resource.
    static let birthday2 = ImageResource(name: "birthday_2", bundle: resourceBundle)

    /// The "birthday_3" asset catalog image resource.
    static let birthday3 = ImageResource(name: "birthday_3", bundle: resourceBundle)

    /// The "birthday_4" asset catalog image resource.
    static let birthday4 = ImageResource(name: "birthday_4", bundle: resourceBundle)

    /// The "birthday_5" asset catalog image resource.
    static let birthday5 = ImageResource(name: "birthday_5", bundle: resourceBundle)

    /// The "birthday_6" asset catalog image resource.
    static let birthday6 = ImageResource(name: "birthday_6", bundle: resourceBundle)

    /// The "birthday_7" asset catalog image resource.
    static let birthday7 = ImageResource(name: "birthday_7", bundle: resourceBundle)

    /// The "birthday_8" asset catalog image resource.
    static let birthday8 = ImageResource(name: "birthday_8", bundle: resourceBundle)

    /// The "birthday_9" asset catalog image resource.
    static let birthday9 = ImageResource(name: "birthday_9", bundle: resourceBundle)

    /// The "brokenheart" asset catalog image resource.
    static let brokenheart = ImageResource(name: "brokenheart", bundle: resourceBundle)

    /// The "bunny_10_happymaskedbunnysurroundedbyeastereggs" asset catalog image resource.
    static let bunny10Happymaskedbunnysurroundedbyeastereggs = ImageResource(name: "bunny_10_happymaskedbunnysurroundedbyeastereggs", bundle: resourceBundle)

    /// The "bunny_11_happymaskedbunnywitheastereggans phonesinnothhands" asset catalog image resource.
    static let bunny11HappymaskedbunnywitheastereggansPhonesinnothhands = ImageResource(name: "bunny_11_happymaskedbunnywitheastereggans phonesinnothhands", bundle: resourceBundle)

    /// The "bunny_12_happybunnywithpinkhearteasteregginhandsitting" asset catalog image resource.
    static let bunny12Happybunnywithpinkhearteasteregginhandsitting = ImageResource(name: "bunny_12_happybunnywithpinkhearteasteregginhandsitting", bundle: resourceBundle)

    /// The "bunny_13_happybunnyholdingeastereggsinhandsstanding" asset catalog image resource.
    static let bunny13Happybunnyholdingeastereggsinhandsstanding = ImageResource(name: "bunny_13_happybunnyholdingeastereggsinhandsstanding", bundle: resourceBundle)

    /// The "bunny_14_happybunnyholdingeasteregssbasketinhand" asset catalog image resource.
    static let bunny14Happybunnyholdingeasteregssbasketinhand = ImageResource(name: "bunny_14_happybunnyholdingeasteregssbasketinhand", bundle: resourceBundle)

    /// The "bunny_15_happyeasterbunnysitting" asset catalog image resource.
    static let bunny15Happyeasterbunnysitting = ImageResource(name: "bunny_15_happyeasterbunnysitting", bundle: resourceBundle)

    /// The "bunny_1_happyeastereggbunny\'" asset catalog image resource.
    static let bunny1Happyeastereggbunny = ImageResource(name: "bunny_1_happyeastereggbunny\'", bundle: resourceBundle)

    /// The "bunny_2_withcarrot" asset catalog image resource.
    static let bunny2Withcarrot = ImageResource(name: "bunny_2_withcarrot", bundle: resourceBundle)

    /// The "bunny_3_happyeasterboard" asset catalog image resource.
    static let bunny3Happyeasterboard = ImageResource(name: "bunny_3_happyeasterboard", bundle: resourceBundle)

    /// The "bunny_4_bunnyinhappyeastereggcell" asset catalog image resource.
    static let bunny4Bunnyinhappyeastereggcell = ImageResource(name: "bunny_4_bunnyinhappyeastereggcell", bundle: resourceBundle)

    /// The "bunny_5_2happybunnieshidingbehindesteregg" asset catalog image resource.
    static let bunny52Happybunnieshidingbehindesteregg = ImageResource(name: "bunny_5_2happybunnieshidingbehindesteregg", bundle: resourceBundle)

    /// The "bunny_6_happybunnylyingoneasteregg" asset catalog image resource.
    static let bunny6Happybunnylyingoneasteregg = ImageResource(name: "bunny_6_happybunnylyingoneasteregg", bundle: resourceBundle)

    /// The "bunny_7_happybunnywith2eastereggsinbothhands" asset catalog image resource.
    static let bunny7Happybunnywith2Eastereggsinbothhands = ImageResource(name: "bunny_7_happybunnywith2eastereggsinbothhands", bundle: resourceBundle)

    /// The "bunny_8_happybunnyinsideeastereggsbasket" asset catalog image resource.
    static let bunny8Happybunnyinsideeastereggsbasket = ImageResource(name: "bunny_8_happybunnyinsideeastereggsbasket", bundle: resourceBundle)

    /// The "bunny_9_witheastergiftinhand" asset catalog image resource.
    static let bunny9Witheastergiftinhand = ImageResource(name: "bunny_9_witheastergiftinhand", bundle: resourceBundle)

    /// The "butterfly" asset catalog image resource.
    static let butterfly = ImageResource(name: "butterfly", bundle: resourceBundle)

    /// The "butterfly_1" asset catalog image resource.
    static let butterfly1 = ImageResource(name: "butterfly_1", bundle: resourceBundle)

    /// The "butterfly_2" asset catalog image resource.
    static let butterfly2 = ImageResource(name: "butterfly_2", bundle: resourceBundle)

    /// The "butterfly_3" asset catalog image resource.
    static let butterfly3 = ImageResource(name: "butterfly_3", bundle: resourceBundle)

    /// The "butterfly_4" asset catalog image resource.
    static let butterfly4 = ImageResource(name: "butterfly_4", bundle: resourceBundle)

    /// The "butterfly_5" asset catalog image resource.
    static let butterfly5 = ImageResource(name: "butterfly_5", bundle: resourceBundle)

    /// The "butterfly_6" asset catalog image resource.
    static let butterfly6 = ImageResource(name: "butterfly_6", bundle: resourceBundle)

    /// The "butterfly_7" asset catalog image resource.
    static let butterfly7 = ImageResource(name: "butterfly_7", bundle: resourceBundle)

    /// The "butterfly_8" asset catalog image resource.
    static let butterfly8 = ImageResource(name: "butterfly_8", bundle: resourceBundle)

    /// The "butterfly_9" asset catalog image resource.
    static let butterfly9 = ImageResource(name: "butterfly_9", bundle: resourceBundle)

    /// The "button_removewatermark" asset catalog image resource.
    static let buttonRemovewatermark = ImageResource(name: "button_removewatermark", bundle: resourceBundle)

    /// The "cancel1" asset catalog image resource.
    static let cancel1 = ImageResource(name: "cancel1", bundle: resourceBundle)

    /// The "cat_10_sitting" asset catalog image resource.
    static let cat10Sitting = ImageResource(name: "cat_10_sitting", bundle: resourceBundle)

    /// The "cat_1_cute" asset catalog image resource.
    static let cat1Cute = ImageResource(name: "cat_1_cute", bundle: resourceBundle)

    /// The "cat_2_icecream" asset catalog image resource.
    static let cat2Icecream = ImageResource(name: "cat_2_icecream", bundle: resourceBundle)

    /// The "cat_3_sleeping" asset catalog image resource.
    static let cat3Sleeping = ImageResource(name: "cat_3_sleeping", bundle: resourceBundle)

    /// The "cat_4_cute" asset catalog image resource.
    static let cat4Cute = ImageResource(name: "cat_4_cute", bundle: resourceBundle)

    /// The "cat_5" asset catalog image resource.
    static let cat5 = ImageResource(name: "cat_5", bundle: resourceBundle)

    /// The "cat_6" asset catalog image resource.
    static let cat6 = ImageResource(name: "cat_6", bundle: resourceBundle)

    /// The "cat_7_heart" asset catalog image resource.
    static let cat7Heart = ImageResource(name: "cat_7_heart", bundle: resourceBundle)

    /// The "cat_8_icecream" asset catalog image resource.
    static let cat8Icecream = ImageResource(name: "cat_8_icecream", bundle: resourceBundle)

    /// The "cat_9_hearticecrem" asset catalog image resource.
    static let cat9Hearticecrem = ImageResource(name: "cat_9_hearticecrem", bundle: resourceBundle)

    /// The "celebrations_1_bottle" asset catalog image resource.
    static let celebrations1Bottle = ImageResource(name: "celebrations_1_bottle", bundle: resourceBundle)

    /// The "celebrations_2_cap" asset catalog image resource.
    static let celebrations2Cap = ImageResource(name: "celebrations_2_cap", bundle: resourceBundle)

    /// The "celebrations_3_blower" asset catalog image resource.
    static let celebrations3Blower = ImageResource(name: "celebrations_3_blower", bundle: resourceBundle)

    /// The "celebrations_4_musicspeaker" asset catalog image resource.
    static let celebrations4Musicspeaker = ImageResource(name: "celebrations_4_musicspeaker", bundle: resourceBundle)

    /// The "celebrations_5_rocket" asset catalog image resource.
    static let celebrations5Rocket = ImageResource(name: "celebrations_5_rocket", bundle: resourceBundle)

    /// The "celebrations_6_cheers" asset catalog image resource.
    static let celebrations6Cheers = ImageResource(name: "celebrations_6_cheers", bundle: resourceBundle)

    /// The "celebrations_7_sparkler" asset catalog image resource.
    static let celebrations7Sparkler = ImageResource(name: "celebrations_7_sparkler", bundle: resourceBundle)

    /// The "celebrations_8_sparkler" asset catalog image resource.
    static let celebrations8Sparkler = ImageResource(name: "celebrations_8_sparkler", bundle: resourceBundle)

    /// The "celebrations_9_balloons" asset catalog image resource.
    static let celebrations9Balloons = ImageResource(name: "celebrations_9_balloons", bundle: resourceBundle)

    /// The "checked" asset catalog image resource.
    static let checked = ImageResource(name: "checked", bundle: resourceBundle)

    /// The "christmas" asset catalog image resource.
    static let christmas = ImageResource(name: "christmas", bundle: resourceBundle)

    /// The "christmas_0" asset catalog image resource.
    static let christmas0 = ImageResource(name: "christmas_0", bundle: resourceBundle)

    /// The "christmas_1" asset catalog image resource.
    static let christmas1 = ImageResource(name: "christmas_1", bundle: resourceBundle)

    /// The "christmas_1_deer" asset catalog image resource.
    static let christmas1Deer = ImageResource(name: "christmas_1_deer", bundle: resourceBundle)

    /// The "christmas_2" asset catalog image resource.
    static let christmas2 = ImageResource(name: "christmas_2", bundle: resourceBundle)

    /// The "christmas_2_gift" asset catalog image resource.
    static let christmas2Gift = ImageResource(name: "christmas_2_gift", bundle: resourceBundle)

    /// The "christmas_3" asset catalog image resource.
    static let christmas3 = ImageResource(name: "christmas_3", bundle: resourceBundle)

    /// The "christmas_3_snowman" asset catalog image resource.
    static let christmas3Snowman = ImageResource(name: "christmas_3_snowman", bundle: resourceBundle)

    /// The "christmas_4" asset catalog image resource.
    static let christmas4 = ImageResource(name: "christmas_4", bundle: resourceBundle)

    /// The "christmas_4_snowflake" asset catalog image resource.
    static let christmas4Snowflake = ImageResource(name: "christmas_4_snowflake", bundle: resourceBundle)

    /// The "christmas_5" asset catalog image resource.
    static let christmas5 = ImageResource(name: "christmas_5", bundle: resourceBundle)

    /// The "christmas_5_christmastree" asset catalog image resource.
    static let christmas5Christmastree = ImageResource(name: "christmas_5_christmastree", bundle: resourceBundle)

    /// The "christmas_6" asset catalog image resource.
    static let christmas6 = ImageResource(name: "christmas_6", bundle: resourceBundle)

    /// The "christmas_6_dressedsnowman" asset catalog image resource.
    static let christmas6Dressedsnowman = ImageResource(name: "christmas_6_dressedsnowman", bundle: resourceBundle)

    /// The "christmas_7" asset catalog image resource.
    static let christmas7 = ImageResource(name: "christmas_7", bundle: resourceBundle)

    /// The "christmas_7_santahat" asset catalog image resource.
    static let christmas7Santahat = ImageResource(name: "christmas_7_santahat", bundle: resourceBundle)

    /// The "christmas_8" asset catalog image resource.
    static let christmas8 = ImageResource(name: "christmas_8", bundle: resourceBundle)

    /// The "christmas_9" asset catalog image resource.
    static let christmas9 = ImageResource(name: "christmas_9", bundle: resourceBundle)

    /// The "christmaslight" asset catalog image resource.
    static let christmaslight = ImageResource(name: "christmaslight", bundle: resourceBundle)

    /// The "christmastree" asset catalog image resource.
    static let christmastree = ImageResource(name: "christmastree", bundle: resourceBundle)

    /// The "circle" asset catalog image resource.
    static let circle = ImageResource(name: "circle", bundle: resourceBundle)

    /// The "close2" asset catalog image resource.
    static let close2 = ImageResource(name: "close2", bundle: resourceBundle)

    /// The "closeLoading" asset catalog image resource.
    static let closeLoading = ImageResource(name: "closeLoading", bundle: resourceBundle)

    /// The "close_watermark" asset catalog image resource.
    static let closeWatermark = ImageResource(name: "close_watermark", bundle: resourceBundle)

    /// The "cloud" asset catalog image resource.
    static let cloud = ImageResource(name: "cloud", bundle: resourceBundle)

    /// The "cloudCategory" asset catalog image resource.
    static let cloudCategory = ImageResource(name: "cloudCategory", bundle: resourceBundle)

    /// The "cloud_0" asset catalog image resource.
    static let cloud0 = ImageResource(name: "cloud_0", bundle: resourceBundle)

    /// The "cloud_1" asset catalog image resource.
    static let cloud1 = ImageResource(name: "cloud_1", bundle: resourceBundle)

    /// The "cloud_2" asset catalog image resource.
    static let cloud2 = ImageResource(name: "cloud_2", bundle: resourceBundle)

    /// The "cloud_3" asset catalog image resource.
    static let cloud3 = ImageResource(name: "cloud_3", bundle: resourceBundle)

    /// The "cloud_4" asset catalog image resource.
    static let cloud4 = ImageResource(name: "cloud_4", bundle: resourceBundle)

    /// The "cloud_5" asset catalog image resource.
    static let cloud5 = ImageResource(name: "cloud_5", bundle: resourceBundle)

    /// The "cloud_6" asset catalog image resource.
    static let cloud6 = ImageResource(name: "cloud_6", bundle: resourceBundle)

    /// The "cloud_7" asset catalog image resource.
    static let cloud7 = ImageResource(name: "cloud_7", bundle: resourceBundle)

    /// The "cloud_8" asset catalog image resource.
    static let cloud8 = ImageResource(name: "cloud_8", bundle: resourceBundle)

    /// The "cloud_9" asset catalog image resource.
    static let cloud9 = ImageResource(name: "cloud_9", bundle: resourceBundle)

    /// The "color2" asset catalog image resource.
    static let color2 = ImageResource(name: "color2", bundle: resourceBundle)

    /// The "color_active2" asset catalog image resource.
    static let colorActive2 = ImageResource(name: "color_active2", bundle: resourceBundle)

    /// The "colors" asset catalog image resource.
    static let colors = ImageResource(name: "colors", bundle: resourceBundle)

    /// The "colors2" asset catalog image resource.
    static let colors2 = ImageResource(name: "colors2", bundle: resourceBundle)

    /// The "colors_10_yellowstar" asset catalog image resource.
    static let colors10Yellowstar = ImageResource(name: "colors_10_yellowstar", bundle: resourceBundle)

    /// The "colors_11_orangestar" asset catalog image resource.
    static let colors11Orangestar = ImageResource(name: "colors_11_orangestar", bundle: resourceBundle)

    /// The "colors_12_redstar" asset catalog image resource.
    static let colors12Redstar = ImageResource(name: "colors_12_redstar", bundle: resourceBundle)

    /// The "colors_13_pinkround" asset catalog image resource.
    static let colors13Pinkround = ImageResource(name: "colors_13_pinkround", bundle: resourceBundle)

    /// The "colors_14_purple" asset catalog image resource.
    static let colors14Purple = ImageResource(name: "colors_14_purple", bundle: resourceBundle)

    /// The "colors_15_bluestar" asset catalog image resource.
    static let colors15Bluestar = ImageResource(name: "colors_15_bluestar", bundle: resourceBundle)

    /// The "colors_16_greenstar" asset catalog image resource.
    static let colors16Greenstar = ImageResource(name: "colors_16_greenstar", bundle: resourceBundle)

    /// The "colors_1_red" asset catalog image resource.
    static let colors1Red = ImageResource(name: "colors_1_red", bundle: resourceBundle)

    /// The "colors_2_orange" asset catalog image resource.
    static let colors2Orange = ImageResource(name: "colors_2_orange", bundle: resourceBundle)

    /// The "colors_3_yellow" asset catalog image resource.
    static let colors3Yellow = ImageResource(name: "colors_3_yellow", bundle: resourceBundle)

    /// The "colors_4_pista" asset catalog image resource.
    static let colors4Pista = ImageResource(name: "colors_4_pista", bundle: resourceBundle)

    /// The "colors_5_green" asset catalog image resource.
    static let colors5Green = ImageResource(name: "colors_5_green", bundle: resourceBundle)

    /// The "colors_6_blue" asset catalog image resource.
    static let colors6Blue = ImageResource(name: "colors_6_blue", bundle: resourceBundle)

    /// The "colors_7_purplestar" asset catalog image resource.
    static let colors7Purplestar = ImageResource(name: "colors_7_purplestar", bundle: resourceBundle)

    /// The "colors_8_pinkstar" asset catalog image resource.
    static let colors8Pinkstar = ImageResource(name: "colors_8_pinkstar", bundle: resourceBundle)

    /// The "colors_9_pistaround" asset catalog image resource.
    static let colors9Pistaround = ImageResource(name: "colors_9_pistaround", bundle: resourceBundle)

    /// The "colors_active2" asset catalog image resource.
    static let colorsActive2 = ImageResource(name: "colors_active2", bundle: resourceBundle)

    /// The "confetti0" asset catalog image resource.
    static let confetti0 = ImageResource(name: "confetti0", bundle: resourceBundle)

    /// The "confetti1" asset catalog image resource.
    static let confetti1 = ImageResource(name: "confetti1", bundle: resourceBundle)

    /// The "confetti2" asset catalog image resource.
    static let confetti2 = ImageResource(name: "confetti2", bundle: resourceBundle)

    /// The "confetti3" asset catalog image resource.
    static let confetti3 = ImageResource(name: "confetti3", bundle: resourceBundle)

    /// The "confetti4" asset catalog image resource.
    static let confetti4 = ImageResource(name: "confetti4", bundle: resourceBundle)

    /// The "confetti5" asset catalog image resource.
    static let confetti5 = ImageResource(name: "confetti5", bundle: resourceBundle)

    /// The "continue_Button" asset catalog image resource.
    static let continueButton = ImageResource(name: "continue_Button", bundle: resourceBundle)

    /// The "continue_Button1" asset catalog image resource.
    static let continueButton1 = ImageResource(name: "continue_Button1", bundle: resourceBundle)

    /// The "couple_10_mansurpisewoman" asset catalog image resource.
    static let couple10Mansurpisewoman = ImageResource(name: "couple_10_mansurpisewoman", bundle: resourceBundle)

    /// The "couple_11_hugging" asset catalog image resource.
    static let couple11Hugging = ImageResource(name: "couple_11_hugging", bundle: resourceBundle)

    /// The "couple_12_proposemarrymering" asset catalog image resource.
    static let couple12Proposemarrymering = ImageResource(name: "couple_12_proposemarrymering", bundle: resourceBundle)

    /// The "couple_13_inrainunderumbrellaromantic" asset catalog image resource.
    static let couple13Inrainunderumbrellaromantic = ImageResource(name: "couple_13_inrainunderumbrellaromantic", bundle: resourceBundle)

    /// The "couple_14_cycleride" asset catalog image resource.
    static let couple14Cycleride = ImageResource(name: "couple_14_cycleride", bundle: resourceBundle)

    /// The "couple_15_inlove" asset catalog image resource.
    static let couple15Inlove = ImageResource(name: "couple_15_inlove", bundle: resourceBundle)

    /// The "couple_16_hugging" asset catalog image resource.
    static let couple16Hugging = ImageResource(name: "couple_16_hugging", bundle: resourceBundle)

    /// The "couple_17_withbookcoffee" asset catalog image resource.
    static let couple17Withbookcoffee = ImageResource(name: "couple_17_withbookcoffee", bundle: resourceBundle)

    /// The "couple_18_chill" asset catalog image resource.
    static let couple18Chill = ImageResource(name: "couple_18_chill", bundle: resourceBundle)

    /// The "couple_19_hugging" asset catalog image resource.
    static let couple19Hugging = ImageResource(name: "couple_19_hugging", bundle: resourceBundle)

    /// The "couple_1_angry" asset catalog image resource.
    static let couple1Angry = ImageResource(name: "couple_1_angry", bundle: resourceBundle)

    /// The "couple_20_inlove" asset catalog image resource.
    static let couple20Inlove = ImageResource(name: "couple_20_inlove", bundle: resourceBundle)

    /// The "couple_21_kissing" asset catalog image resource.
    static let couple21Kissing = ImageResource(name: "couple_21_kissing", bundle: resourceBundle)

    /// The "couple_22_romantic" asset catalog image resource.
    static let couple22Romantic = ImageResource(name: "couple_22_romantic", bundle: resourceBundle)

    /// The "couple_23_inlove" asset catalog image resource.
    static let couple23Inlove = ImageResource(name: "couple_23_inlove", bundle: resourceBundle)

    /// The "couple_2_romanticonabench" asset catalog image resource.
    static let couple2Romanticonabench = ImageResource(name: "couple_2_romanticonabench", bundle: resourceBundle)

    /// The "couple_3_feelinginlove" asset catalog image resource.
    static let couple3Feelinginlove = ImageResource(name: "couple_3_feelinginlove", bundle: resourceBundle)

    /// The "couple_4_proposeredrose" asset catalog image resource.
    static let couple4Proposeredrose = ImageResource(name: "couple_4_proposeredrose", bundle: resourceBundle)

    /// The "couple_5_kissing" asset catalog image resource.
    static let couple5Kissing = ImageResource(name: "couple_5_kissing", bundle: resourceBundle)

    /// The "couple_6_manholdingwomaninarm" asset catalog image resource.
    static let couple6Manholdingwomaninarm = ImageResource(name: "couple_6_manholdingwomaninarm", bundle: resourceBundle)

    /// The "couple_7_watchingmovieinblanket" asset catalog image resource.
    static let couple7Watchingmovieinblanket = ImageResource(name: "couple_7_watchingmovieinblanket", bundle: resourceBundle)

    /// The "couple_8_travelling" asset catalog image resource.
    static let couple8Travelling = ImageResource(name: "couple_8_travelling", bundle: resourceBundle)

    /// The "couple_9_studentsinlove" asset catalog image resource.
    static let couple9Studentsinlove = ImageResource(name: "couple_9_studentsinlove", bundle: resourceBundle)

    /// The "crop" asset catalog image resource.
    static let crop = ImageResource(name: "crop", bundle: resourceBundle)

    /// The "crown" asset catalog image resource.
    static let crown = ImageResource(name: "crown", bundle: resourceBundle)

    /// The "crown_1" asset catalog image resource.
    static let crown1 = ImageResource(name: "crown_1", bundle: resourceBundle)

    /// The "crown_2" asset catalog image resource.
    static let crown2 = ImageResource(name: "crown_2", bundle: resourceBundle)

    /// The "crown_3" asset catalog image resource.
    static let crown3 = ImageResource(name: "crown_3", bundle: resourceBundle)

    /// The "crown_4" asset catalog image resource.
    static let crown4 = ImageResource(name: "crown_4", bundle: resourceBundle)

    /// The "crown_5" asset catalog image resource.
    static let crown5 = ImageResource(name: "crown_5", bundle: resourceBundle)

    /// The "crown_6" asset catalog image resource.
    static let crown6 = ImageResource(name: "crown_6", bundle: resourceBundle)

    /// The "crown_7" asset catalog image resource.
    static let crown7 = ImageResource(name: "crown_7", bundle: resourceBundle)

    /// The "crown_8" asset catalog image resource.
    static let crown8 = ImageResource(name: "crown_8", bundle: resourceBundle)

    /// The "custom" asset catalog image resource.
    static let custom = ImageResource(name: "custom", bundle: resourceBundle)

    /// The "cute" asset catalog image resource.
    static let cute = ImageResource(name: "cute", bundle: resourceBundle)

    /// The "cute_0" asset catalog image resource.
    static let cute0 = ImageResource(name: "cute_0", bundle: resourceBundle)

    /// The "cute_1" asset catalog image resource.
    static let cute1 = ImageResource(name: "cute_1", bundle: resourceBundle)

    /// The "cute_2" asset catalog image resource.
    static let cute2 = ImageResource(name: "cute_2", bundle: resourceBundle)

    /// The "cute_3" asset catalog image resource.
    static let cute3 = ImageResource(name: "cute_3", bundle: resourceBundle)

    /// The "cute_4" asset catalog image resource.
    static let cute4 = ImageResource(name: "cute_4", bundle: resourceBundle)

    /// The "cute_5" asset catalog image resource.
    static let cute5 = ImageResource(name: "cute_5", bundle: resourceBundle)

    /// The "cute_6" asset catalog image resource.
    static let cute6 = ImageResource(name: "cute_6", bundle: resourceBundle)

    /// The "cute_7" asset catalog image resource.
    static let cute7 = ImageResource(name: "cute_7", bundle: resourceBundle)

    /// The "cute_8" asset catalog image resource.
    static let cute8 = ImageResource(name: "cute_8", bundle: resourceBundle)

    /// The "cute_9" asset catalog image resource.
    static let cute9 = ImageResource(name: "cute_9", bundle: resourceBundle)

    /// The "diamondflower" asset catalog image resource.
    static let diamondflower = ImageResource(name: "diamondflower", bundle: resourceBundle)

    /// The "diwali" asset catalog image resource.
    static let diwali = ImageResource(name: "diwali", bundle: resourceBundle)

    /// The "diwali_0" asset catalog image resource.
    static let diwali0 = ImageResource(name: "diwali_0", bundle: resourceBundle)

    /// The "diwali_1" asset catalog image resource.
    static let diwali1 = ImageResource(name: "diwali_1", bundle: resourceBundle)

    /// The "diwali_2" asset catalog image resource.
    static let diwali2 = ImageResource(name: "diwali_2", bundle: resourceBundle)

    /// The "diwali_3" asset catalog image resource.
    static let diwali3 = ImageResource(name: "diwali_3", bundle: resourceBundle)

    /// The "diwali_4" asset catalog image resource.
    static let diwali4 = ImageResource(name: "diwali_4", bundle: resourceBundle)

    /// The "diwali_5" asset catalog image resource.
    static let diwali5 = ImageResource(name: "diwali_5", bundle: resourceBundle)

    /// The "diwali_6" asset catalog image resource.
    static let diwali6 = ImageResource(name: "diwali_6", bundle: resourceBundle)

    /// The "diwali_7" asset catalog image resource.
    static let diwali7 = ImageResource(name: "diwali_7", bundle: resourceBundle)

    /// The "diwali_8" asset catalog image resource.
    static let diwali8 = ImageResource(name: "diwali_8", bundle: resourceBundle)

    /// The "diwali_9" asset catalog image resource.
    static let diwali9 = ImageResource(name: "diwali_9", bundle: resourceBundle)

    /// The "done1" asset catalog image resource.
    static let done1 = ImageResource(name: "done1", bundle: resourceBundle)

    /// The "done2" asset catalog image resource.
    static let done2 = ImageResource(name: "done2", bundle: resourceBundle)

    /// The "done_lock" asset catalog image resource.
    static let doneLock = ImageResource(name: "done_lock", bundle: resourceBundle)

    /// The "doublesize_bg" asset catalog image resource.
    static let doublesizeBg = ImageResource(name: "doublesize_bg", bundle: resourceBundle)

    /// The "easter_1_happyeasterflowergrass" asset catalog image resource.
    static let easter1Happyeasterflowergrass = ImageResource(name: "easter_1_happyeasterflowergrass", bundle: resourceBundle)

    /// The "easter_2_happyeasteregg" asset catalog image resource.
    static let easter2Happyeasteregg = ImageResource(name: "easter_2_happyeasteregg", bundle: resourceBundle)

    /// The "easter_3_happyeasterhen" asset catalog image resource.
    static let easter3Happyeasterhen = ImageResource(name: "easter_3_happyeasterhen", bundle: resourceBundle)

    /// The "easter_4_happyeastereggsgrass" asset catalog image resource.
    static let easter4Happyeastereggsgrass = ImageResource(name: "easter_4_happyeastereggsgrass", bundle: resourceBundle)

    /// The "easter_5_easterdayegg" asset catalog image resource.
    static let easter5Easterdayegg = ImageResource(name: "easter_5_easterdayegg", bundle: resourceBundle)

    /// The "easter_6_celebratehenbasketofeggs" asset catalog image resource.
    static let easter6Celebratehenbasketofeggs = ImageResource(name: "easter_6_celebratehenbasketofeggs", bundle: resourceBundle)

    /// The "easter_7_happyeasterbunny" asset catalog image resource.
    static let easter7Happyeasterbunny = ImageResource(name: "easter_7_happyeasterbunny", bundle: resourceBundle)

    /// The "easter_8_eggwithpinkheart" asset catalog image resource.
    static let easter8Eggwithpinkheart = ImageResource(name: "easter_8_eggwithpinkheart", bundle: resourceBundle)

    /// The "easter_9_eastereggflowers" asset catalog image resource.
    static let easter9Eastereggflowers = ImageResource(name: "easter_9_eastereggflowers", bundle: resourceBundle)

    /// The "email2" asset catalog image resource.
    static let email2 = ImageResource(name: "email2", bundle: resourceBundle)

    /// The "email_active2" asset catalog image resource.
    static let emailActive2 = ImageResource(name: "email_active2", bundle: resourceBundle)

    /// The "emoji" asset catalog image resource.
    static let emoji = ImageResource(name: "emoji", bundle: resourceBundle)

    /// The "emoji 1" asset catalog image resource.
    static let emoji1 = ImageResource(name: "emoji 1", bundle: resourceBundle)

    /// The "emoji_0" asset catalog image resource.
    static let emoji0 = ImageResource(name: "emoji_0", bundle: resourceBundle)

    #warning("The \"emoji_1\" image asset name resolves to the symbol \"emoji1\" which already exists. Try renaming the asset.")

    /// The "emoji_10_laughing" asset catalog image resource.
    static let emoji10Laughing = ImageResource(name: "emoji_10_laughing", bundle: resourceBundle)

    /// The "emoji_11_frowning" asset catalog image resource.
    static let emoji11Frowning = ImageResource(name: "emoji_11_frowning", bundle: resourceBundle)

    /// The "emoji_12_foodiehungry" asset catalog image resource.
    static let emoji12Foodiehungry = ImageResource(name: "emoji_12_foodiehungry", bundle: resourceBundle)

    /// The "emoji_13_loveheart" asset catalog image resource.
    static let emoji13Loveheart = ImageResource(name: "emoji_13_loveheart", bundle: resourceBundle)

    /// The "emoji_14_angry" asset catalog image resource.
    static let emoji14Angry = ImageResource(name: "emoji_14_angry", bundle: resourceBundle)

    /// The "emoji_15_thumbsdown" asset catalog image resource.
    static let emoji15Thumbsdown = ImageResource(name: "emoji_15_thumbsdown", bundle: resourceBundle)

    /// The "emoji_16_hungry" asset catalog image resource.
    static let emoji16Hungry = ImageResource(name: "emoji_16_hungry", bundle: resourceBundle)

    /// The "emoji_17_groupselfie" asset catalog image resource.
    static let emoji17Groupselfie = ImageResource(name: "emoji_17_groupselfie", bundle: resourceBundle)

    /// The "emoji_18_laughingfunny" asset catalog image resource.
    static let emoji18Laughingfunny = ImageResource(name: "emoji_18_laughingfunny", bundle: resourceBundle)

    /// The "emoji_19_selfie" asset catalog image resource.
    static let emoji19Selfie = ImageResource(name: "emoji_19_selfie", bundle: resourceBundle)

    /// The "emoji_1_brokenheart" asset catalog image resource.
    static let emoji1Brokenheart = ImageResource(name: "emoji_1_brokenheart", bundle: resourceBundle)

    /// The "emoji_2" asset catalog image resource.
    static let emoji2 = ImageResource(name: "emoji_2", bundle: resourceBundle)

    /// The "emoji_20_laughing" asset catalog image resource.
    static let emoji20Laughing = ImageResource(name: "emoji_20_laughing", bundle: resourceBundle)

    /// The "emoji_21_angryscreming" asset catalog image resource.
    static let emoji21Angryscreming = ImageResource(name: "emoji_21_angryscreming", bundle: resourceBundle)

    /// The "emoji_22_funnylaughing" asset catalog image resource.
    static let emoji22Funnylaughing = ImageResource(name: "emoji_22_funnylaughing", bundle: resourceBundle)

    /// The "emoji_23_sadcrying" asset catalog image resource.
    static let emoji23Sadcrying = ImageResource(name: "emoji_23_sadcrying", bundle: resourceBundle)

    /// The "emoji_24_angry" asset catalog image resource.
    static let emoji24Angry = ImageResource(name: "emoji_24_angry", bundle: resourceBundle)

    /// The "emoji_2_birthdaycelebrating" asset catalog image resource.
    static let emoji2Birthdaycelebrating = ImageResource(name: "emoji_2_birthdaycelebrating", bundle: resourceBundle)

    /// The "emoji_3" asset catalog image resource.
    static let emoji3 = ImageResource(name: "emoji_3", bundle: resourceBundle)

    /// The "emoji_3_awesome" asset catalog image resource.
    static let emoji3Awesome = ImageResource(name: "emoji_3_awesome", bundle: resourceBundle)

    /// The "emoji_4" asset catalog image resource.
    static let emoji4 = ImageResource(name: "emoji_4", bundle: resourceBundle)

    /// The "emoji_4_inloveroseredhearteye" asset catalog image resource.
    static let emoji4Inloveroseredhearteye = ImageResource(name: "emoji_4_inloveroseredhearteye", bundle: resourceBundle)

    /// The "emoji_5" asset catalog image resource.
    static let emoji5 = ImageResource(name: "emoji_5", bundle: resourceBundle)

    /// The "emoji_5_cheerfulblacksunglasses" asset catalog image resource.
    static let emoji5Cheerfulblacksunglasses = ImageResource(name: "emoji_5_cheerfulblacksunglasses", bundle: resourceBundle)

    /// The "emoji_6" asset catalog image resource.
    static let emoji6 = ImageResource(name: "emoji_6", bundle: resourceBundle)

    /// The "emoji_6_excited" asset catalog image resource.
    static let emoji6Excited = ImageResource(name: "emoji_6_excited", bundle: resourceBundle)

    /// The "emoji_7" asset catalog image resource.
    static let emoji7 = ImageResource(name: "emoji_7", bundle: resourceBundle)

    /// The "emoji_7_partyhatbirthday" asset catalog image resource.
    static let emoji7Partyhatbirthday = ImageResource(name: "emoji_7_partyhatbirthday", bundle: resourceBundle)

    /// The "emoji_8" asset catalog image resource.
    static let emoji8 = ImageResource(name: "emoji_8", bundle: resourceBundle)

    /// The "emoji_8_inloveredheartsmiling" asset catalog image resource.
    static let emoji8Inloveredheartsmiling = ImageResource(name: "emoji_8_inloveredheartsmiling", bundle: resourceBundle)

    /// The "emoji_9" asset catalog image resource.
    static let emoji9 = ImageResource(name: "emoji_9", bundle: resourceBundle)

    /// The "emoji_9_vomitting" asset catalog image resource.
    static let emoji9Vomitting = ImageResource(name: "emoji_9_vomitting", bundle: resourceBundle)

    /// The "exit-button2" asset catalog image resource.
    static let exitButton2 = ImageResource(name: "exit-button2", bundle: resourceBundle)

    /// The "exit-button_ipad2" asset catalog image resource.
    static let exitButtonIpad2 = ImageResource(name: "exit-button_ipad2", bundle: resourceBundle)

    /// The "facebook_icon" asset catalog image resource.
    static let facebookIcon = ImageResource(name: "facebook_icon", bundle: resourceBundle)

    /// The "fb2" asset catalog image resource.
    static let fb2 = ImageResource(name: "fb2", bundle: resourceBundle)

    /// The "fb_active2" asset catalog image resource.
    static let fbActive2 = ImageResource(name: "fb_active2", bundle: resourceBundle)

    /// The "fireworks" asset catalog image resource.
    static let fireworks = ImageResource(name: "fireworks", bundle: resourceBundle)

    /// The "fireworks_0" asset catalog image resource.
    static let fireworks0 = ImageResource(name: "fireworks_0", bundle: resourceBundle)

    /// The "fireworks_1" asset catalog image resource.
    static let fireworks1 = ImageResource(name: "fireworks_1", bundle: resourceBundle)

    /// The "fireworks_2" asset catalog image resource.
    static let fireworks2 = ImageResource(name: "fireworks_2", bundle: resourceBundle)

    /// The "fireworks_3" asset catalog image resource.
    static let fireworks3 = ImageResource(name: "fireworks_3", bundle: resourceBundle)

    /// The "fireworks_4" asset catalog image resource.
    static let fireworks4 = ImageResource(name: "fireworks_4", bundle: resourceBundle)

    /// The "fireworks_5" asset catalog image resource.
    static let fireworks5 = ImageResource(name: "fireworks_5", bundle: resourceBundle)

    /// The "fireworks_6" asset catalog image resource.
    static let fireworks6 = ImageResource(name: "fireworks_6", bundle: resourceBundle)

    /// The "fireworks_7" asset catalog image resource.
    static let fireworks7 = ImageResource(name: "fireworks_7", bundle: resourceBundle)

    /// The "fireworks_8" asset catalog image resource.
    static let fireworks8 = ImageResource(name: "fireworks_8", bundle: resourceBundle)

    /// The "fireworks_9" asset catalog image resource.
    static let fireworks9 = ImageResource(name: "fireworks_9", bundle: resourceBundle)

    /// The "flower" asset catalog image resource.
    static let flower = ImageResource(name: "flower", bundle: resourceBundle)

    /// The "flower_0" asset catalog image resource.
    static let flower0 = ImageResource(name: "flower_0", bundle: resourceBundle)

    /// The "flower_1" asset catalog image resource.
    static let flower1 = ImageResource(name: "flower_1", bundle: resourceBundle)

    /// The "flower_2" asset catalog image resource.
    static let flower2 = ImageResource(name: "flower_2", bundle: resourceBundle)

    /// The "flower_3" asset catalog image resource.
    static let flower3 = ImageResource(name: "flower_3", bundle: resourceBundle)

    /// The "flower_4" asset catalog image resource.
    static let flower4 = ImageResource(name: "flower_4", bundle: resourceBundle)

    /// The "flower_5" asset catalog image resource.
    static let flower5 = ImageResource(name: "flower_5", bundle: resourceBundle)

    /// The "flower_6" asset catalog image resource.
    static let flower6 = ImageResource(name: "flower_6", bundle: resourceBundle)

    /// The "flower_7" asset catalog image resource.
    static let flower7 = ImageResource(name: "flower_7", bundle: resourceBundle)

    /// The "flower_8" asset catalog image resource.
    static let flower8 = ImageResource(name: "flower_8", bundle: resourceBundle)

    /// The "flower_9" asset catalog image resource.
    static let flower9 = ImageResource(name: "flower_9", bundle: resourceBundle)

    /// The "flowers" asset catalog image resource.
    static let flowers = ImageResource(name: "flowers", bundle: resourceBundle)

    /// The "flowers_10_orange" asset catalog image resource.
    static let flowers10Orange = ImageResource(name: "flowers_10_orange", bundle: resourceBundle)

    /// The "flowers_11" asset catalog image resource.
    static let flowers11 = ImageResource(name: "flowers_11", bundle: resourceBundle)

    /// The "flowers_12" asset catalog image resource.
    static let flowers12 = ImageResource(name: "flowers_12", bundle: resourceBundle)

    /// The "flowers_13" asset catalog image resource.
    static let flowers13 = ImageResource(name: "flowers_13", bundle: resourceBundle)

    /// The "flowers_14" asset catalog image resource.
    static let flowers14 = ImageResource(name: "flowers_14", bundle: resourceBundle)

    /// The "flowers_15_tulip" asset catalog image resource.
    static let flowers15Tulip = ImageResource(name: "flowers_15_tulip", bundle: resourceBundle)

    /// The "flowers_16" asset catalog image resource.
    static let flowers16 = ImageResource(name: "flowers_16", bundle: resourceBundle)

    /// The "flowers_17" asset catalog image resource.
    static let flowers17 = ImageResource(name: "flowers_17", bundle: resourceBundle)

    /// The "flowers_18_daisyflower" asset catalog image resource.
    static let flowers18Daisyflower = ImageResource(name: "flowers_18_daisyflower", bundle: resourceBundle)

    /// The "flowers_19" asset catalog image resource.
    static let flowers19 = ImageResource(name: "flowers_19", bundle: resourceBundle)

    /// The "flowers_1_purplerose" asset catalog image resource.
    static let flowers1Purplerose = ImageResource(name: "flowers_1_purplerose", bundle: resourceBundle)

    /// The "flowers_20" asset catalog image resource.
    static let flowers20 = ImageResource(name: "flowers_20", bundle: resourceBundle)

    /// The "flowers_2_yellow" asset catalog image resource.
    static let flowers2Yellow = ImageResource(name: "flowers_2_yellow", bundle: resourceBundle)

    /// The "flowers_3_lavender" asset catalog image resource.
    static let flowers3Lavender = ImageResource(name: "flowers_3_lavender", bundle: resourceBundle)

    /// The "flowers_4_sunflower" asset catalog image resource.
    static let flowers4Sunflower = ImageResource(name: "flowers_4_sunflower", bundle: resourceBundle)

    /// The "flowers_5_redrose" asset catalog image resource.
    static let flowers5Redrose = ImageResource(name: "flowers_5_redrose", bundle: resourceBundle)

    /// The "flowers_6_pinklotus" asset catalog image resource.
    static let flowers6Pinklotus = ImageResource(name: "flowers_6_pinklotus", bundle: resourceBundle)

    /// The "flowers_7_pinktulip" asset catalog image resource.
    static let flowers7Pinktulip = ImageResource(name: "flowers_7_pinktulip", bundle: resourceBundle)

    /// The "flowers_8_daisyflower" asset catalog image resource.
    static let flowers8Daisyflower = ImageResource(name: "flowers_8_daisyflower", bundle: resourceBundle)

    /// The "flowers_9_orchidpurple" asset catalog image resource.
    static let flowers9Orchidpurple = ImageResource(name: "flowers_9_orchidpurple", bundle: resourceBundle)

    /// The "frames2" asset catalog image resource.
    static let frames2 = ImageResource(name: "frames2", bundle: resourceBundle)

    /// The "frames_active2" asset catalog image resource.
    static let framesActive2 = ImageResource(name: "frames_active2", bundle: resourceBundle)

    /// The "frienship_1" asset catalog image resource.
    static let frienship1 = ImageResource(name: "frienship_1", bundle: resourceBundle)

    /// The "frienship_2" asset catalog image resource.
    static let frienship2 = ImageResource(name: "frienship_2", bundle: resourceBundle)

    /// The "frienship_3" asset catalog image resource.
    static let frienship3 = ImageResource(name: "frienship_3", bundle: resourceBundle)

    /// The "frienship_4" asset catalog image resource.
    static let frienship4 = ImageResource(name: "frienship_4", bundle: resourceBundle)

    /// The "frienship_5" asset catalog image resource.
    static let frienship5 = ImageResource(name: "frienship_5", bundle: resourceBundle)

    /// The "frienship_6" asset catalog image resource.
    static let frienship6 = ImageResource(name: "frienship_6", bundle: resourceBundle)

    /// The "frienship_7" asset catalog image resource.
    static let frienship7 = ImageResource(name: "frienship_7", bundle: resourceBundle)

    /// The "frienship_8" asset catalog image resource.
    static let frienship8 = ImageResource(name: "frienship_8", bundle: resourceBundle)

    /// The "frienship_9" asset catalog image resource.
    static let frienship9 = ImageResource(name: "frienship_9", bundle: resourceBundle)

    /// The "fx2" asset catalog image resource.
    static let fx2 = ImageResource(name: "fx2", bundle: resourceBundle)

    /// The "fx_active2" asset catalog image resource.
    static let fxActive2 = ImageResource(name: "fx_active2", bundle: resourceBundle)

    /// The "galaxy" asset catalog image resource.
    static let galaxy = ImageResource(name: "galaxy", bundle: resourceBundle)

    /// The "galaxy_0" asset catalog image resource.
    static let galaxy0 = ImageResource(name: "galaxy_0", bundle: resourceBundle)

    /// The "galaxy_1" asset catalog image resource.
    static let galaxy1 = ImageResource(name: "galaxy_1", bundle: resourceBundle)

    /// The "galaxy_2" asset catalog image resource.
    static let galaxy2 = ImageResource(name: "galaxy_2", bundle: resourceBundle)

    /// The "galaxy_3" asset catalog image resource.
    static let galaxy3 = ImageResource(name: "galaxy_3", bundle: resourceBundle)

    /// The "galaxy_4" asset catalog image resource.
    static let galaxy4 = ImageResource(name: "galaxy_4", bundle: resourceBundle)

    /// The "galaxy_5" asset catalog image resource.
    static let galaxy5 = ImageResource(name: "galaxy_5", bundle: resourceBundle)

    /// The "galaxy_6" asset catalog image resource.
    static let galaxy6 = ImageResource(name: "galaxy_6", bundle: resourceBundle)

    /// The "galaxy_7" asset catalog image resource.
    static let galaxy7 = ImageResource(name: "galaxy_7", bundle: resourceBundle)

    /// The "galaxy_8" asset catalog image resource.
    static let galaxy8 = ImageResource(name: "galaxy_8", bundle: resourceBundle)

    /// The "galaxy_9" asset catalog image resource.
    static let galaxy9 = ImageResource(name: "galaxy_9", bundle: resourceBundle)

    /// The "gifts_1" asset catalog image resource.
    static let gifts1 = ImageResource(name: "gifts_1", bundle: resourceBundle)

    /// The "gifts_2" asset catalog image resource.
    static let gifts2 = ImageResource(name: "gifts_2", bundle: resourceBundle)

    /// The "gifts_3" asset catalog image resource.
    static let gifts3 = ImageResource(name: "gifts_3", bundle: resourceBundle)

    /// The "gifts_4" asset catalog image resource.
    static let gifts4 = ImageResource(name: "gifts_4", bundle: resourceBundle)

    /// The "gifts_5" asset catalog image resource.
    static let gifts5 = ImageResource(name: "gifts_5", bundle: resourceBundle)

    /// The "gifts_6" asset catalog image resource.
    static let gifts6 = ImageResource(name: "gifts_6", bundle: resourceBundle)

    /// The "gifts_7" asset catalog image resource.
    static let gifts7 = ImageResource(name: "gifts_7", bundle: resourceBundle)

    /// The "gifts_8" asset catalog image resource.
    static let gifts8 = ImageResource(name: "gifts_8", bundle: resourceBundle)

    /// The "gifts_9" asset catalog image resource.
    static let gifts9 = ImageResource(name: "gifts_9", bundle: resourceBundle)

    /// The "gradient" asset catalog image resource.
    static let gradient = ImageResource(name: "gradient", bundle: resourceBundle)

    /// The "gradients" asset catalog image resource.
    static let gradients = ImageResource(name: "gradients", bundle: resourceBundle)

    /// The "hats_1" asset catalog image resource.
    static let hats1 = ImageResource(name: "hats_1", bundle: resourceBundle)

    /// The "hats_10" asset catalog image resource.
    static let hats10 = ImageResource(name: "hats_10", bundle: resourceBundle)

    /// The "hats_11" asset catalog image resource.
    static let hats11 = ImageResource(name: "hats_11", bundle: resourceBundle)

    /// The "hats_12" asset catalog image resource.
    static let hats12 = ImageResource(name: "hats_12", bundle: resourceBundle)

    /// The "hats_13" asset catalog image resource.
    static let hats13 = ImageResource(name: "hats_13", bundle: resourceBundle)

    /// The "hats_14" asset catalog image resource.
    static let hats14 = ImageResource(name: "hats_14", bundle: resourceBundle)

    /// The "hats_15" asset catalog image resource.
    static let hats15 = ImageResource(name: "hats_15", bundle: resourceBundle)

    /// The "hats_16" asset catalog image resource.
    static let hats16 = ImageResource(name: "hats_16", bundle: resourceBundle)

    /// The "hats_17" asset catalog image resource.
    static let hats17 = ImageResource(name: "hats_17", bundle: resourceBundle)

    /// The "hats_2" asset catalog image resource.
    static let hats2 = ImageResource(name: "hats_2", bundle: resourceBundle)

    /// The "hats_3" asset catalog image resource.
    static let hats3 = ImageResource(name: "hats_3", bundle: resourceBundle)

    /// The "hats_4" asset catalog image resource.
    static let hats4 = ImageResource(name: "hats_4", bundle: resourceBundle)

    /// The "hats_5" asset catalog image resource.
    static let hats5 = ImageResource(name: "hats_5", bundle: resourceBundle)

    /// The "hats_6" asset catalog image resource.
    static let hats6 = ImageResource(name: "hats_6", bundle: resourceBundle)

    /// The "hats_7" asset catalog image resource.
    static let hats7 = ImageResource(name: "hats_7", bundle: resourceBundle)

    /// The "hats_8" asset catalog image resource.
    static let hats8 = ImageResource(name: "hats_8", bundle: resourceBundle)

    /// The "hats_9" asset catalog image resource.
    static let hats9 = ImageResource(name: "hats_9", bundle: resourceBundle)

    /// The "heart" asset catalog image resource.
    static let heart = ImageResource(name: "heart", bundle: resourceBundle)

    /// The "heartCategory" asset catalog image resource.
    static let heartCategory = ImageResource(name: "heartCategory", bundle: resourceBundle)

    /// The "heart_0" asset catalog image resource.
    static let heart0 = ImageResource(name: "heart_0", bundle: resourceBundle)

    /// The "heart_1" asset catalog image resource.
    static let heart1 = ImageResource(name: "heart_1", bundle: resourceBundle)

    /// The "heart_2" asset catalog image resource.
    static let heart2 = ImageResource(name: "heart_2", bundle: resourceBundle)

    /// The "heart_3" asset catalog image resource.
    static let heart3 = ImageResource(name: "heart_3", bundle: resourceBundle)

    /// The "heart_4" asset catalog image resource.
    static let heart4 = ImageResource(name: "heart_4", bundle: resourceBundle)

    /// The "heart_5" asset catalog image resource.
    static let heart5 = ImageResource(name: "heart_5", bundle: resourceBundle)

    /// The "heart_6" asset catalog image resource.
    static let heart6 = ImageResource(name: "heart_6", bundle: resourceBundle)

    /// The "heart_7" asset catalog image resource.
    static let heart7 = ImageResource(name: "heart_7", bundle: resourceBundle)

    /// The "heart_8" asset catalog image resource.
    static let heart8 = ImageResource(name: "heart_8", bundle: resourceBundle)

    /// The "heart_9" asset catalog image resource.
    static let heart9 = ImageResource(name: "heart_9", bundle: resourceBundle)

    /// The "hexagon" asset catalog image resource.
    static let hexagon = ImageResource(name: "hexagon", bundle: resourceBundle)

    /// The "home_svg" asset catalog image resource.
    static let homeSvg = ImageResource(name: "home_svg", bundle: resourceBundle)

    /// The "icecream_1_cup" asset catalog image resource.
    static let icecream1Cup = ImageResource(name: "icecream_1_cup", bundle: resourceBundle)

    /// The "icecream_2_candy" asset catalog image resource.
    static let icecream2Candy = ImageResource(name: "icecream_2_candy", bundle: resourceBundle)

    /// The "icecream_3_cup" asset catalog image resource.
    static let icecream3Cup = ImageResource(name: "icecream_3_cup", bundle: resourceBundle)

    /// The "icecream_4_conewow" asset catalog image resource.
    static let icecream4Conewow = ImageResource(name: "icecream_4_conewow", bundle: resourceBundle)

    /// The "icecream_5_popsiclesadsleeping" asset catalog image resource.
    static let icecream5Popsiclesadsleeping = ImageResource(name: "icecream_5_popsiclesadsleeping", bundle: resourceBundle)

    /// The "icecream_6_evilcone" asset catalog image resource.
    static let icecream6Evilcone = ImageResource(name: "icecream_6_evilcone", bundle: resourceBundle)

    /// The "icecream_7_conestick" asset catalog image resource.
    static let icecream7Conestick = ImageResource(name: "icecream_7_conestick", bundle: resourceBundle)

    /// The "imessage" asset catalog image resource.
    static let imessage = ImageResource(name: "imessage", bundle: resourceBundle)

    /// The "info2" asset catalog image resource.
    static let info2 = ImageResource(name: "info2", bundle: resourceBundle)

    /// The "instagram2" asset catalog image resource.
    static let instagram2 = ImageResource(name: "instagram2", bundle: resourceBundle)

    /// The "instagram_active2" asset catalog image resource.
    static let instagramActive2 = ImageResource(name: "instagram_active2", bundle: resourceBundle)

    /// The "ipad-pro-loading-page" asset catalog image resource.
    static let ipadProLoadingPage = ImageResource(name: "ipad-pro-loading-page", bundle: resourceBundle)

    /// The "ipad-slider-fill" asset catalog image resource.
    static let ipadSliderFill = ImageResource(name: "ipad-slider-fill", bundle: resourceBundle)

    /// The "ipad-slider-handle" asset catalog image resource.
    static let ipadSliderHandle = ImageResource(name: "ipad-slider-handle", bundle: resourceBundle)

    /// The "ipad-slider-track" asset catalog image resource.
    static let ipadSliderTrack = ImageResource(name: "ipad-slider-track", bundle: resourceBundle)

    /// The "ipad_bg" asset catalog image resource.
    static let ipadBg = ImageResource(name: "ipad_bg", bundle: resourceBundle)

    /// The "joker_1_red" asset catalog image resource.
    static let joker1Red = ImageResource(name: "joker_1_red", bundle: resourceBundle)

    /// The "joker_2_blue" asset catalog image resource.
    static let joker2Blue = ImageResource(name: "joker_2_blue", bundle: resourceBundle)

    /// The "joker_3_multicolor" asset catalog image resource.
    static let joker3Multicolor = ImageResource(name: "joker_3_multicolor", bundle: resourceBundle)

    /// The "joker_4_orange" asset catalog image resource.
    static let joker4Orange = ImageResource(name: "joker_4_orange", bundle: resourceBundle)

    /// The "joker_5_green" asset catalog image resource.
    static let joker5Green = ImageResource(name: "joker_5_green", bundle: resourceBundle)

    /// The "joker_6_orange" asset catalog image resource.
    static let joker6Orange = ImageResource(name: "joker_6_orange", bundle: resourceBundle)

    /// The "leaf" asset catalog image resource.
    static let leaf = ImageResource(name: "leaf", bundle: resourceBundle)

    /// The "leafCategory" asset catalog image resource.
    static let leafCategory = ImageResource(name: "leafCategory", bundle: resourceBundle)

    /// The "leaf_0" asset catalog image resource.
    static let leaf0 = ImageResource(name: "leaf_0", bundle: resourceBundle)

    /// The "leaf_1" asset catalog image resource.
    static let leaf1 = ImageResource(name: "leaf_1", bundle: resourceBundle)

    /// The "leaf_2" asset catalog image resource.
    static let leaf2 = ImageResource(name: "leaf_2", bundle: resourceBundle)

    /// The "leaf_3" asset catalog image resource.
    static let leaf3 = ImageResource(name: "leaf_3", bundle: resourceBundle)

    /// The "leaf_4" asset catalog image resource.
    static let leaf4 = ImageResource(name: "leaf_4", bundle: resourceBundle)

    /// The "leaf_5" asset catalog image resource.
    static let leaf5 = ImageResource(name: "leaf_5", bundle: resourceBundle)

    /// The "leaf_6" asset catalog image resource.
    static let leaf6 = ImageResource(name: "leaf_6", bundle: resourceBundle)

    /// The "leaf_7" asset catalog image resource.
    static let leaf7 = ImageResource(name: "leaf_7", bundle: resourceBundle)

    /// The "leaf_8" asset catalog image resource.
    static let leaf8 = ImageResource(name: "leaf_8", bundle: resourceBundle)

    /// The "leaf_9" asset catalog image resource.
    static let leaf9 = ImageResource(name: "leaf_9", bundle: resourceBundle)

    /// The "lock_done" asset catalog image resource.
    static let lockDone = ImageResource(name: "lock_done", bundle: resourceBundle)

    /// The "logoNew" asset catalog image resource.
    static let logoNew = ImageResource(name: "logoNew", bundle: resourceBundle)

    /// The "mail" asset catalog image resource.
    static let mail = ImageResource(name: "mail", bundle: resourceBundle)

    /// The "mail2" asset catalog image resource.
    static let mail2 = ImageResource(name: "mail2", bundle: resourceBundle)

    /// The "mail_active2" asset catalog image resource.
    static let mailActive2 = ImageResource(name: "mail_active2", bundle: resourceBundle)

    /// The "marble" asset catalog image resource.
    static let marble = ImageResource(name: "marble", bundle: resourceBundle)

    /// The "marble_0" asset catalog image resource.
    static let marble0 = ImageResource(name: "marble_0", bundle: resourceBundle)

    /// The "marble_1" asset catalog image resource.
    static let marble1 = ImageResource(name: "marble_1", bundle: resourceBundle)

    /// The "marble_2" asset catalog image resource.
    static let marble2 = ImageResource(name: "marble_2", bundle: resourceBundle)

    /// The "marble_3" asset catalog image resource.
    static let marble3 = ImageResource(name: "marble_3", bundle: resourceBundle)

    /// The "marble_4" asset catalog image resource.
    static let marble4 = ImageResource(name: "marble_4", bundle: resourceBundle)

    /// The "marble_5" asset catalog image resource.
    static let marble5 = ImageResource(name: "marble_5", bundle: resourceBundle)

    /// The "marble_6" asset catalog image resource.
    static let marble6 = ImageResource(name: "marble_6", bundle: resourceBundle)

    /// The "marble_7" asset catalog image resource.
    static let marble7 = ImageResource(name: "marble_7", bundle: resourceBundle)

    /// The "marble_8" asset catalog image resource.
    static let marble8 = ImageResource(name: "marble_8", bundle: resourceBundle)

    /// The "marble_9" asset catalog image resource.
    static let marble9 = ImageResource(name: "marble_9", bundle: resourceBundle)

    /// The "menu" asset catalog image resource.
    static let menu = ImageResource(name: "menu", bundle: resourceBundle)

    /// The "messenger_icon" asset catalog image resource.
    static let messengerIcon = ImageResource(name: "messenger_icon", bundle: resourceBundle)

    /// The "more" asset catalog image resource.
    static let more = ImageResource(name: "more", bundle: resourceBundle)

    /// The "moreIcon" asset catalog image resource.
    static let moreIcon = ImageResource(name: "moreIcon", bundle: resourceBundle)

    /// The "mothersday_10_bestmommomandkid" asset catalog image resource.
    static let mothersday10Bestmommomandkid = ImageResource(name: "mothersday_10_bestmommomandkid", bundle: resourceBundle)

    /// The "mothersday_1_purpleheart" asset catalog image resource.
    static let mothersday1Purpleheart = ImageResource(name: "mothersday_1_purpleheart", bundle: resourceBundle)

    /// The "mothersday_2_happymothersdayflowers" asset catalog image resource.
    static let mothersday2Happymothersdayflowers = ImageResource(name: "mothersday_2_happymothersdayflowers", bundle: resourceBundle)

    /// The "mothersday_3_iloveyoumom" asset catalog image resource.
    static let mothersday3Iloveyoumom = ImageResource(name: "mothersday_3_iloveyoumom", bundle: resourceBundle)

    /// The "mothersday_4_bestmomeverbokhe" asset catalog image resource.
    static let mothersday4Bestmomeverbokhe = ImageResource(name: "mothersday_4_bestmomeverbokhe", bundle: resourceBundle)

    /// The "mothersday_5_thanksmomflowers" asset catalog image resource.
    static let mothersday5Thanksmomflowers = ImageResource(name: "mothersday_5_thanksmomflowers", bundle: resourceBundle)

    /// The "mothersday_6_mymomismyheroflowers" asset catalog image resource.
    static let mothersday6Mymomismyheroflowers = ImageResource(name: "mothersday_6_mymomismyheroflowers", bundle: resourceBundle)

    /// The "mothersday_7_iloveyoumomgreetingcard" asset catalog image resource.
    static let mothersday7Iloveyoumomgreetingcard = ImageResource(name: "mothersday_7_iloveyoumomgreetingcard", bundle: resourceBundle)

    /// The "mothersday_8_flowerpinkheart" asset catalog image resource.
    static let mothersday8Flowerpinkheart = ImageResource(name: "mothersday_8_flowerpinkheart", bundle: resourceBundle)

    /// The "mothersday_9_ilovemom" asset catalog image resource.
    static let mothersday9Ilovemom = ImageResource(name: "mothersday_9_ilovemom", bundle: resourceBundle)

    /// The "msg2" asset catalog image resource.
    static let msg2 = ImageResource(name: "msg2", bundle: resourceBundle)

    /// The "msg_active2" asset catalog image resource.
    static let msgActive2 = ImageResource(name: "msg_active2", bundle: resourceBundle)

    /// The "music2" asset catalog image resource.
    static let music2 = ImageResource(name: "music2", bundle: resourceBundle)

    /// The "music_10_accordion" asset catalog image resource.
    static let music10Accordion = ImageResource(name: "music_10_accordion", bundle: resourceBundle)

    /// The "music_11_compactdisc" asset catalog image resource.
    static let music11Compactdisc = ImageResource(name: "music_11_compactdisc", bundle: resourceBundle)

    /// The "music_12_piano" asset catalog image resource.
    static let music12Piano = ImageResource(name: "music_12_piano", bundle: resourceBundle)

    /// The "music_1_violin" asset catalog image resource.
    static let music1Violin = ImageResource(name: "music_1_violin", bundle: resourceBundle)

    /// The "music_2_mandolin" asset catalog image resource.
    static let music2Mandolin = ImageResource(name: "music_2_mandolin", bundle: resourceBundle)

    /// The "music_3_saxophone" asset catalog image resource.
    static let music3Saxophone = ImageResource(name: "music_3_saxophone", bundle: resourceBundle)

    /// The "music_4_walkman" asset catalog image resource.
    static let music4Walkman = ImageResource(name: "music_4_walkman", bundle: resourceBundle)

    /// The "music_5_microphone" asset catalog image resource.
    static let music5Microphone = ImageResource(name: "music_5_microphone", bundle: resourceBundle)

    /// The "music_6_drum" asset catalog image resource.
    static let music6Drum = ImageResource(name: "music_6_drum", bundle: resourceBundle)

    /// The "music_7_headphone" asset catalog image resource.
    static let music7Headphone = ImageResource(name: "music_7_headphone", bundle: resourceBundle)

    /// The "music_8_musicplayer" asset catalog image resource.
    static let music8Musicplayer = ImageResource(name: "music_8_musicplayer", bundle: resourceBundle)

    /// The "music_9_guitar" asset catalog image resource.
    static let music9Guitar = ImageResource(name: "music_9_guitar", bundle: resourceBundle)

    /// The "music_active2" asset catalog image resource.
    static let musicActive2 = ImageResource(name: "music_active2", bundle: resourceBundle)

    /// The "n_lock_corner" asset catalog image resource.
    static let nLockCorner = ImageResource(name: "n_lock_corner", bundle: resourceBundle)

    /// The "n_lock_corner_ipad" asset catalog image resource.
    static let nLockCornerIpad = ImageResource(name: "n_lock_corner_ipad", bundle: resourceBundle)

    /// The "nature_10_heartrainbowcloud" asset catalog image resource.
    static let nature10Heartrainbowcloud = ImageResource(name: "nature_10_heartrainbowcloud", bundle: resourceBundle)

    /// The "nature_11_mushrooms" asset catalog image resource.
    static let nature11Mushrooms = ImageResource(name: "nature_11_mushrooms", bundle: resourceBundle)

    /// The "nature_12_skyrainbowclouds" asset catalog image resource.
    static let nature12Skyrainbowclouds = ImageResource(name: "nature_12_skyrainbowclouds", bundle: resourceBundle)

    /// The "nature_1_tree " asset catalog image resource.
    static let nature1Tree = ImageResource(name: "nature_1_tree ", bundle: resourceBundle)

    /// The "nature_2_flowers" asset catalog image resource.
    static let nature2Flowers = ImageResource(name: "nature_2_flowers", bundle: resourceBundle)

    /// The "nature_3_flowers" asset catalog image resource.
    static let nature3Flowers = ImageResource(name: "nature_3_flowers", bundle: resourceBundle)

    /// The "nature_4_hill" asset catalog image resource.
    static let nature4Hill = ImageResource(name: "nature_4_hill", bundle: resourceBundle)

    /// The "nature_5_flowers" asset catalog image resource.
    static let nature5Flowers = ImageResource(name: "nature_5_flowers", bundle: resourceBundle)

    /// The "nature_6_sun" asset catalog image resource.
    static let nature6Sun = ImageResource(name: "nature_6_sun", bundle: resourceBundle)

    /// The "nature_7_orange" asset catalog image resource.
    static let nature7Orange = ImageResource(name: "nature_7_orange", bundle: resourceBundle)

    /// The "nature_8_cloud" asset catalog image resource.
    static let nature8Cloud = ImageResource(name: "nature_8_cloud", bundle: resourceBundle)

    /// The "nature_9_flowersrose" asset catalog image resource.
    static let nature9Flowersrose = ImageResource(name: "nature_9_flowersrose", bundle: resourceBundle)

    /// The "neon" asset catalog image resource.
    static let neon = ImageResource(name: "neon", bundle: resourceBundle)

    /// The "neon_0" asset catalog image resource.
    static let neon0 = ImageResource(name: "neon_0", bundle: resourceBundle)

    /// The "neon_1" asset catalog image resource.
    static let neon1 = ImageResource(name: "neon_1", bundle: resourceBundle)

    /// The "neon_10_happybirthday" asset catalog image resource.
    static let neon10Happybirthday = ImageResource(name: "neon_10_happybirthday", bundle: resourceBundle)

    /// The "neon_11_girlpower" asset catalog image resource.
    static let neon11Girlpower = ImageResource(name: "neon_11_girlpower", bundle: resourceBundle)

    /// The "neon_1_hello" asset catalog image resource.
    static let neon1Hello = ImageResource(name: "neon_1_hello", bundle: resourceBundle)

    /// The "neon_2" asset catalog image resource.
    static let neon2 = ImageResource(name: "neon_2", bundle: resourceBundle)

    /// The "neon_2_welcome" asset catalog image resource.
    static let neon2Welcome = ImageResource(name: "neon_2_welcome", bundle: resourceBundle)

    /// The "neon_3" asset catalog image resource.
    static let neon3 = ImageResource(name: "neon_3", bundle: resourceBundle)

    /// The "neon_3_love" asset catalog image resource.
    static let neon3Love = ImageResource(name: "neon_3_love", bundle: resourceBundle)

    /// The "neon_4" asset catalog image resource.
    static let neon4 = ImageResource(name: "neon_4", bundle: resourceBundle)

    /// The "neon_4_iloveyou" asset catalog image resource.
    static let neon4Iloveyou = ImageResource(name: "neon_4_iloveyou", bundle: resourceBundle)

    /// The "neon_5" asset catalog image resource.
    static let neon5 = ImageResource(name: "neon_5", bundle: resourceBundle)

    /// The "neon_5_cheers" asset catalog image resource.
    static let neon5Cheers = ImageResource(name: "neon_5_cheers", bundle: resourceBundle)

    /// The "neon_6" asset catalog image resource.
    static let neon6 = ImageResource(name: "neon_6", bundle: resourceBundle)

    /// The "neon_6_hello" asset catalog image resource.
    static let neon6Hello = ImageResource(name: "neon_6_hello", bundle: resourceBundle)

    /// The "neon_7" asset catalog image resource.
    static let neon7 = ImageResource(name: "neon_7", bundle: resourceBundle)

    /// The "neon_7_thankyou" asset catalog image resource.
    static let neon7Thankyou = ImageResource(name: "neon_7_thankyou", bundle: resourceBundle)

    /// The "neon_8" asset catalog image resource.
    static let neon8 = ImageResource(name: "neon_8", bundle: resourceBundle)

    /// The "neon_8_awesome" asset catalog image resource.
    static let neon8Awesome = ImageResource(name: "neon_8_awesome", bundle: resourceBundle)

    /// The "neon_9" asset catalog image resource.
    static let neon9 = ImageResource(name: "neon_9", bundle: resourceBundle)

    /// The "neon_9_pride" asset catalog image resource.
    static let neon9Pride = ImageResource(name: "neon_9_pride", bundle: resourceBundle)

    /// The "newcard" asset catalog image resource.
    static let newcard = ImageResource(name: "newcard", bundle: resourceBundle)

    /// The "newportrait" asset catalog image resource.
    static let newportrait = ImageResource(name: "newportrait", bundle: resourceBundle)

    /// The "newstory" asset catalog image resource.
    static let newstory = ImageResource(name: "newstory", bundle: resourceBundle)

    /// The "newwallpaper" asset catalog image resource.
    static let newwallpaper = ImageResource(name: "newwallpaper", bundle: resourceBundle)

    /// The "night_1_crescentmoon" asset catalog image resource.
    static let night1Crescentmoon = ImageResource(name: "night_1_crescentmoon", bundle: resourceBundle)

    /// The "night_2_fullmoon" asset catalog image resource.
    static let night2Fullmoon = ImageResource(name: "night_2_fullmoon", bundle: resourceBundle)

    /// The "night_3_crescentmoon" asset catalog image resource.
    static let night3Crescentmoon = ImageResource(name: "night_3_crescentmoon", bundle: resourceBundle)

    /// The "night_4_moonsky" asset catalog image resource.
    static let night4Moonsky = ImageResource(name: "night_4_moonsky", bundle: resourceBundle)

    /// The "night_5_crescentmoonskyclouds" asset catalog image resource.
    static let night5Crescentmoonskyclouds = ImageResource(name: "night_5_crescentmoonskyclouds", bundle: resourceBundle)

    /// The "night_6_mooncloudssky" asset catalog image resource.
    static let night6Mooncloudssky = ImageResource(name: "night_6_mooncloudssky", bundle: resourceBundle)

    /// The "night_7_moonsleeping" asset catalog image resource.
    static let night7Moonsleeping = ImageResource(name: "night_7_moonsleeping", bundle: resourceBundle)

    /// The "night_8_moonsun" asset catalog image resource.
    static let night8Moonsun = ImageResource(name: "night_8_moonsun", bundle: resourceBundle)

    /// The "offer_Image" asset catalog image resource.
    static let offer = ImageResource(name: "offer_Image", bundle: resourceBundle)

    /// The "optionIcon_0" asset catalog image resource.
    static let optionIcon0 = ImageResource(name: "optionIcon_0", bundle: resourceBundle)

    /// The "optionIcon_1" asset catalog image resource.
    static let optionIcon1 = ImageResource(name: "optionIcon_1", bundle: resourceBundle)

    /// The "optionIcon_2" asset catalog image resource.
    static let optionIcon2 = ImageResource(name: "optionIcon_2", bundle: resourceBundle)

    /// The "optionIcon_3" asset catalog image resource.
    static let optionIcon3 = ImageResource(name: "optionIcon_3", bundle: resourceBundle)

    /// The "optionIcon_4" asset catalog image resource.
    static let optionIcon4 = ImageResource(name: "optionIcon_4", bundle: resourceBundle)

    /// The "original" asset catalog image resource.
    static let original = ImageResource(name: "original", bundle: resourceBundle)

    /// The "overlay" asset catalog image resource.
    static let overlay = ImageResource(name: "overlay", bundle: resourceBundle)

    /// The "pattern" asset catalog image resource.
    static let pattern = ImageResource(name: "pattern", bundle: resourceBundle)

    /// The "pattern2" asset catalog image resource.
    static let pattern2 = ImageResource(name: "pattern2", bundle: resourceBundle)

    /// The "pattern_0" asset catalog image resource.
    static let pattern0 = ImageResource(name: "pattern_0", bundle: resourceBundle)

    /// The "pattern_1" asset catalog image resource.
    static let pattern1 = ImageResource(name: "pattern_1", bundle: resourceBundle)

    /// The "pattern_10" asset catalog image resource.
    static let pattern10 = ImageResource(name: "pattern_10", bundle: resourceBundle)

    /// The "pattern_11" asset catalog image resource.
    static let pattern11 = ImageResource(name: "pattern_11", bundle: resourceBundle)

    /// The "pattern_12" asset catalog image resource.
    static let pattern12 = ImageResource(name: "pattern_12", bundle: resourceBundle)

    /// The "pattern_13" asset catalog image resource.
    static let pattern13 = ImageResource(name: "pattern_13", bundle: resourceBundle)

    /// The "pattern_14" asset catalog image resource.
    static let pattern14 = ImageResource(name: "pattern_14", bundle: resourceBundle)

    /// The "pattern_15" asset catalog image resource.
    static let pattern15 = ImageResource(name: "pattern_15", bundle: resourceBundle)

    /// The "pattern_16" asset catalog image resource.
    static let pattern16 = ImageResource(name: "pattern_16", bundle: resourceBundle)

    /// The "pattern_17" asset catalog image resource.
    static let pattern17 = ImageResource(name: "pattern_17", bundle: resourceBundle)

    /// The "pattern_18" asset catalog image resource.
    static let pattern18 = ImageResource(name: "pattern_18", bundle: resourceBundle)

    /// The "pattern_19" asset catalog image resource.
    static let pattern19 = ImageResource(name: "pattern_19", bundle: resourceBundle)

    #warning("The \"pattern_2\" image asset name resolves to the symbol \"pattern2\" which already exists. Try renaming the asset.")

    /// The "pattern_20" asset catalog image resource.
    static let pattern20 = ImageResource(name: "pattern_20", bundle: resourceBundle)

    /// The "pattern_21" asset catalog image resource.
    static let pattern21 = ImageResource(name: "pattern_21", bundle: resourceBundle)

    /// The "pattern_22" asset catalog image resource.
    static let pattern22 = ImageResource(name: "pattern_22", bundle: resourceBundle)

    /// The "pattern_23" asset catalog image resource.
    static let pattern23 = ImageResource(name: "pattern_23", bundle: resourceBundle)

    /// The "pattern_24" asset catalog image resource.
    static let pattern24 = ImageResource(name: "pattern_24", bundle: resourceBundle)

    /// The "pattern_25" asset catalog image resource.
    static let pattern25 = ImageResource(name: "pattern_25", bundle: resourceBundle)

    /// The "pattern_26" asset catalog image resource.
    static let pattern26 = ImageResource(name: "pattern_26", bundle: resourceBundle)

    /// The "pattern_27" asset catalog image resource.
    static let pattern27 = ImageResource(name: "pattern_27", bundle: resourceBundle)

    /// The "pattern_28" asset catalog image resource.
    static let pattern28 = ImageResource(name: "pattern_28", bundle: resourceBundle)

    /// The "pattern_29" asset catalog image resource.
    static let pattern29 = ImageResource(name: "pattern_29", bundle: resourceBundle)

    /// The "pattern_3" asset catalog image resource.
    static let pattern3 = ImageResource(name: "pattern_3", bundle: resourceBundle)

    /// The "pattern_30" asset catalog image resource.
    static let pattern30 = ImageResource(name: "pattern_30", bundle: resourceBundle)

    /// The "pattern_31" asset catalog image resource.
    static let pattern31 = ImageResource(name: "pattern_31", bundle: resourceBundle)

    /// The "pattern_32" asset catalog image resource.
    static let pattern32 = ImageResource(name: "pattern_32", bundle: resourceBundle)

    /// The "pattern_33" asset catalog image resource.
    static let pattern33 = ImageResource(name: "pattern_33", bundle: resourceBundle)

    /// The "pattern_34" asset catalog image resource.
    static let pattern34 = ImageResource(name: "pattern_34", bundle: resourceBundle)

    /// The "pattern_35" asset catalog image resource.
    static let pattern35 = ImageResource(name: "pattern_35", bundle: resourceBundle)

    /// The "pattern_36" asset catalog image resource.
    static let pattern36 = ImageResource(name: "pattern_36", bundle: resourceBundle)

    /// The "pattern_37" asset catalog image resource.
    static let pattern37 = ImageResource(name: "pattern_37", bundle: resourceBundle)

    /// The "pattern_38" asset catalog image resource.
    static let pattern38 = ImageResource(name: "pattern_38", bundle: resourceBundle)

    /// The "pattern_39" asset catalog image resource.
    static let pattern39 = ImageResource(name: "pattern_39", bundle: resourceBundle)

    /// The "pattern_4" asset catalog image resource.
    static let pattern4 = ImageResource(name: "pattern_4", bundle: resourceBundle)

    /// The "pattern_40" asset catalog image resource.
    static let pattern40 = ImageResource(name: "pattern_40", bundle: resourceBundle)

    /// The "pattern_41" asset catalog image resource.
    static let pattern41 = ImageResource(name: "pattern_41", bundle: resourceBundle)

    /// The "pattern_42" asset catalog image resource.
    static let pattern42 = ImageResource(name: "pattern_42", bundle: resourceBundle)

    /// The "pattern_5" asset catalog image resource.
    static let pattern5 = ImageResource(name: "pattern_5", bundle: resourceBundle)

    /// The "pattern_6" asset catalog image resource.
    static let pattern6 = ImageResource(name: "pattern_6", bundle: resourceBundle)

    /// The "pattern_7" asset catalog image resource.
    static let pattern7 = ImageResource(name: "pattern_7", bundle: resourceBundle)

    /// The "pattern_8" asset catalog image resource.
    static let pattern8 = ImageResource(name: "pattern_8", bundle: resourceBundle)

    /// The "pattern_9" asset catalog image resource.
    static let pattern9 = ImageResource(name: "pattern_9", bundle: resourceBundle)

    /// The "pattern_active2" asset catalog image resource.
    static let patternActive2 = ImageResource(name: "pattern_active2", bundle: resourceBundle)

    /// The "pause" asset catalog image resource.
    static let pause = ImageResource(name: "pause", bundle: resourceBundle)

    /// The "pet_1_loveyourpets" asset catalog image resource.
    static let pet1Loveyourpets = ImageResource(name: "pet_1_loveyourpets", bundle: resourceBundle)

    /// The "pet_2_hamster" asset catalog image resource.
    static let pet2Hamster = ImageResource(name: "pet_2_hamster", bundle: resourceBundle)

    /// The "pet_3_duck" asset catalog image resource.
    static let pet3Duck = ImageResource(name: "pet_3_duck", bundle: resourceBundle)

    /// The "pet_4_ilovemypets" asset catalog image resource.
    static let pet4Ilovemypets = ImageResource(name: "pet_4_ilovemypets", bundle: resourceBundle)

    /// The "pet_5_goldfishnemo" asset catalog image resource.
    static let pet5Goldfishnemo = ImageResource(name: "pet_5_goldfishnemo", bundle: resourceBundle)

    /// The "pet_6_sinngwithmebird" asset catalog image resource.
    static let pet6Sinngwithmebird = ImageResource(name: "pet_6_sinngwithmebird", bundle: resourceBundle)

    /// The "pet_7_catmeow" asset catalog image resource.
    static let pet7Catmeow = ImageResource(name: "pet_7_catmeow", bundle: resourceBundle)

    /// The "pet_8_ilovemydog" asset catalog image resource.
    static let pet8Ilovemydog = ImageResource(name: "pet_8_ilovemydog", bundle: resourceBundle)

    /// The "pic_eff_image" asset catalog image resource.
    static let picEff = ImageResource(name: "pic_eff_image", bundle: resourceBundle)

    /// The "pirate_10_pirate" asset catalog image resource.
    static let pirate10Pirate = ImageResource(name: "pirate_10_pirate", bundle: resourceBundle)

    /// The "pirate_11_pirate" asset catalog image resource.
    static let pirate11Pirate = ImageResource(name: "pirate_11_pirate", bundle: resourceBundle)

    /// The "pirate_12_canonball" asset catalog image resource.
    static let pirate12Canonball = ImageResource(name: "pirate_12_canonball", bundle: resourceBundle)

    /// The "pirate_13_piratehok" asset catalog image resource.
    static let pirate13Piratehok = ImageResource(name: "pirate_13_piratehok", bundle: resourceBundle)

    /// The "pirate_14_piratehat" asset catalog image resource.
    static let pirate14Piratehat = ImageResource(name: "pirate_14_piratehat", bundle: resourceBundle)

    /// The "pirate_15_treasuremap" asset catalog image resource.
    static let pirate15Treasuremap = ImageResource(name: "pirate_15_treasuremap", bundle: resourceBundle)

    /// The "pirate_17_pirateship" asset catalog image resource.
    static let pirate17Pirateship = ImageResource(name: "pirate_17_pirateship", bundle: resourceBundle)

    /// The "pirate_18_piratecanon" asset catalog image resource.
    static let pirate18Piratecanon = ImageResource(name: "pirate_18_piratecanon", bundle: resourceBundle)

    /// The "pirate_1_treasurechest" asset catalog image resource.
    static let pirate1Treasurechest = ImageResource(name: "pirate_1_treasurechest", bundle: resourceBundle)

    /// The "pirate_2_viking" asset catalog image resource.
    static let pirate2Viking = ImageResource(name: "pirate_2_viking", bundle: resourceBundle)

    /// The "pirate_3_vikingpirate" asset catalog image resource.
    static let pirate3Vikingpirate = ImageResource(name: "pirate_3_vikingpirate", bundle: resourceBundle)

    /// The "pirate_4_pirate" asset catalog image resource.
    static let pirate4Pirate = ImageResource(name: "pirate_4_pirate", bundle: resourceBundle)

    /// The "pirate_5_pirate" asset catalog image resource.
    static let pirate5Pirate = ImageResource(name: "pirate_5_pirate", bundle: resourceBundle)

    /// The "pirate_6_pirateskullsword" asset catalog image resource.
    static let pirate6Pirateskullsword = ImageResource(name: "pirate_6_pirateskullsword", bundle: resourceBundle)

    /// The "pirate_7_piratecaptain" asset catalog image resource.
    static let pirate7Piratecaptain = ImageResource(name: "pirate_7_piratecaptain", bundle: resourceBundle)

    /// The "pirate_8_pirate" asset catalog image resource.
    static let pirate8Pirate = ImageResource(name: "pirate_8_pirate", bundle: resourceBundle)

    /// The "pirate_9_pirate" asset catalog image resource.
    static let pirate9Pirate = ImageResource(name: "pirate_9_pirate", bundle: resourceBundle)

    /// The "play" asset catalog image resource.
    static let play = ImageResource(name: "play", bundle: resourceBundle)

    /// The "pride_10_loveislove" asset catalog image resource.
    static let pride10Loveislove = ImageResource(name: "pride_10_loveislove", bundle: resourceBundle)

    /// The "pride_11_lgbt" asset catalog image resource.
    static let pride11Lgbt = ImageResource(name: "pride_11_lgbt", bundle: resourceBundle)

    /// The "pride_12_rainbowheart" asset catalog image resource.
    static let pride12Rainbowheart = ImageResource(name: "pride_12_rainbowheart", bundle: resourceBundle)

    /// The "pride_13_peacepride" asset catalog image resource.
    static let pride13Peacepride = ImageResource(name: "pride_13_peacepride", bundle: resourceBundle)

    /// The "pride_14_prideheart" asset catalog image resource.
    static let pride14Prideheart = ImageResource(name: "pride_14_prideheart", bundle: resourceBundle)

    /// The "pride_1_lightinningbolt" asset catalog image resource.
    static let pride1Lightinningbolt = ImageResource(name: "pride_1_lightinningbolt", bundle: resourceBundle)

    /// The "pride_2_unicorn" asset catalog image resource.
    static let pride2Unicorn = ImageResource(name: "pride_2_unicorn", bundle: resourceBundle)

    /// The "pride_3_priderainbow" asset catalog image resource.
    static let pride3Priderainbow = ImageResource(name: "pride_3_priderainbow", bundle: resourceBundle)

    /// The "pride_4_fist" asset catalog image resource.
    static let pride4Fist = ImageResource(name: "pride_4_fist", bundle: resourceBundle)

    /// The "pride_5_prideflag" asset catalog image resource.
    static let pride5Prideflag = ImageResource(name: "pride_5_prideflag", bundle: resourceBundle)

    /// The "pride_6_pridetransgenderflag" asset catalog image resource.
    static let pride6Pridetransgenderflag = ImageResource(name: "pride_6_pridetransgenderflag", bundle: resourceBundle)

    /// The "pride_7_pridesymbol" asset catalog image resource.
    static let pride7Pridesymbol = ImageResource(name: "pride_7_pridesymbol", bundle: resourceBundle)

    /// The "pride_8_pridestar" asset catalog image resource.
    static let pride8Pridestar = ImageResource(name: "pride_8_pridestar", bundle: resourceBundle)

    /// The "pride_9_pridestasr" asset catalog image resource.
    static let pride9Pridestasr = ImageResource(name: "pride_9_pridestasr", bundle: resourceBundle)

    /// The "puja_1_offerings" asset catalog image resource.
    static let puja1Offerings = ImageResource(name: "puja_1_offerings", bundle: resourceBundle)

    /// The "puja_2_fireworkscrackersfestival" asset catalog image resource.
    static let puja2Fireworkscrackersfestival = ImageResource(name: "puja_2_fireworkscrackersfestival", bundle: resourceBundle)

    /// The "puja_3_lanterndiya" asset catalog image resource.
    static let puja3Lanterndiya = ImageResource(name: "puja_3_lanterndiya", bundle: resourceBundle)

    /// The "puja_4_punjabi" asset catalog image resource.
    static let puja4Punjabi = ImageResource(name: "puja_4_punjabi", bundle: resourceBundle)

    /// The "puja_5_prayer" asset catalog image resource.
    static let puja5Prayer = ImageResource(name: "puja_5_prayer", bundle: resourceBundle)

    /// The "puja_6_festivalladyhousewifemommother" asset catalog image resource.
    static let puja6Festivalladyhousewifemommother = ImageResource(name: "puja_6_festivalladyhousewifemommother", bundle: resourceBundle)

    /// The "puja_7_lantercandlelight" asset catalog image resource.
    static let puja7Lantercandlelight = ImageResource(name: "puja_7_lantercandlelight", bundle: resourceBundle)

    /// The "puja_8_pot" asset catalog image resource.
    static let puja8Pot = ImageResource(name: "puja_8_pot", bundle: resourceBundle)

    /// The "puja_9_festivalgift" asset catalog image resource.
    static let puja9Festivalgift = ImageResource(name: "puja_9_festivalgift", bundle: resourceBundle)

    /// The "rakhi_1_rakshabanndhan" asset catalog image resource.
    static let rakhi1Rakshabanndhan = ImageResource(name: "rakhi_1_rakshabanndhan", bundle: resourceBundle)

    /// The "rakhi_2_rakshabandhan" asset catalog image resource.
    static let rakhi2Rakshabandhan = ImageResource(name: "rakhi_2_rakshabandhan", bundle: resourceBundle)

    /// The "rakhi_3_rakshabandhan" asset catalog image resource.
    static let rakhi3Rakshabandhan = ImageResource(name: "rakhi_3_rakshabandhan", bundle: resourceBundle)

    /// The "rakhi_4_rakshabandhan" asset catalog image resource.
    static let rakhi4Rakshabandhan = ImageResource(name: "rakhi_4_rakshabandhan", bundle: resourceBundle)

    /// The "rate-us2" asset catalog image resource.
    static let rateUs2 = ImageResource(name: "rate-us2", bundle: resourceBundle)

    /// The "rate-us_active2" asset catalog image resource.
    static let rateUsActive2 = ImageResource(name: "rate-us_active2", bundle: resourceBundle)

    /// The "rateUs_Panel" asset catalog image resource.
    static let rateUsPanel = ImageResource(name: "rateUs_Panel", bundle: resourceBundle)

    /// The "rightArrow" asset catalog image resource.
    static let rightArrow = ImageResource(name: "rightArrow", bundle: resourceBundle)

    /// The "right_svg" asset catalog image resource.
    static let rightSvg = ImageResource(name: "right_svg", bundle: resourceBundle)

    /// The "rose" asset catalog image resource.
    static let rose = ImageResource(name: "rose", bundle: resourceBundle)

    /// The "rose_0" asset catalog image resource.
    static let rose0 = ImageResource(name: "rose_0", bundle: resourceBundle)

    /// The "rose_1" asset catalog image resource.
    static let rose1 = ImageResource(name: "rose_1", bundle: resourceBundle)

    /// The "rose_2" asset catalog image resource.
    static let rose2 = ImageResource(name: "rose_2", bundle: resourceBundle)

    /// The "rose_3" asset catalog image resource.
    static let rose3 = ImageResource(name: "rose_3", bundle: resourceBundle)

    /// The "rose_4" asset catalog image resource.
    static let rose4 = ImageResource(name: "rose_4", bundle: resourceBundle)

    /// The "rose_5" asset catalog image resource.
    static let rose5 = ImageResource(name: "rose_5", bundle: resourceBundle)

    /// The "rose_6" asset catalog image resource.
    static let rose6 = ImageResource(name: "rose_6", bundle: resourceBundle)

    /// The "rose_7" asset catalog image resource.
    static let rose7 = ImageResource(name: "rose_7", bundle: resourceBundle)

    /// The "rose_8" asset catalog image resource.
    static let rose8 = ImageResource(name: "rose_8", bundle: resourceBundle)

    /// The "rose_9" asset catalog image resource.
    static let rose9 = ImageResource(name: "rose_9", bundle: resourceBundle)

    /// The "settings2" asset catalog image resource.
    static let settings2 = ImageResource(name: "settings2", bundle: resourceBundle)

    /// The "settings_active2" asset catalog image resource.
    static let settingsActive2 = ImageResource(name: "settings_active2", bundle: resourceBundle)

    /// The "share2" asset catalog image resource.
    static let share2 = ImageResource(name: "share2", bundle: resourceBundle)

    /// The "share_active2" asset catalog image resource.
    static let shareActive2 = ImageResource(name: "share_active2", bundle: resourceBundle)

    /// The "slidertrackImage" asset catalog image resource.
    static let slidertrack = ImageResource(name: "slidertrackImage", bundle: resourceBundle)

    /// The "solid" asset catalog image resource.
    static let solid = ImageResource(name: "solid", bundle: resourceBundle)

    /// The "speach" asset catalog image resource.
    static let speach = ImageResource(name: "speach", bundle: resourceBundle)

    /// The "star" asset catalog image resource.
    static let star = ImageResource(name: "star", bundle: resourceBundle)

    #warning("The \"star_Image\" image asset name resolves to the symbol \"star\" which already exists. Try renaming the asset.")

    /// The "start2" asset catalog image resource.
    static let start2 = ImageResource(name: "start2", bundle: resourceBundle)

    /// The "start2a" asset catalog image resource.
    static let start2A = ImageResource(name: "start2a", bundle: resourceBundle)

    /// The "start_button" asset catalog image resource.
    static let startButton = ImageResource(name: "start_button", bundle: resourceBundle)

    /// The "story" asset catalog image resource.
    static let story = ImageResource(name: "story", bundle: resourceBundle)

    /// The "subscription_Selected_Bg" asset catalog image resource.
    static let subscriptionSelectedBg = ImageResource(name: "subscription_Selected_Bg", bundle: resourceBundle)

    /// The "subscription_UnSelected_Bg" asset catalog image resource.
    static let subscriptionUnSelectedBg = ImageResource(name: "subscription_UnSelected_Bg", bundle: resourceBundle)

    /// The "sunglasses_10_heart" asset catalog image resource.
    static let sunglasses10Heart = ImageResource(name: "sunglasses_10_heart", bundle: resourceBundle)

    /// The "sunglasses_11_flower" asset catalog image resource.
    static let sunglasses11Flower = ImageResource(name: "sunglasses_11_flower", bundle: resourceBundle)

    /// The "sunglasses_1_rectangular" asset catalog image resource.
    static let sunglasses1Rectangular = ImageResource(name: "sunglasses_1_rectangular", bundle: resourceBundle)

    /// The "sunglasses_2_round" asset catalog image resource.
    static let sunglasses2Round = ImageResource(name: "sunglasses_2_round", bundle: resourceBundle)

    /// The "sunglasses_3_star" asset catalog image resource.
    static let sunglasses3Star = ImageResource(name: "sunglasses_3_star", bundle: resourceBundle)

    /// The "sunglasses_4_pentagon" asset catalog image resource.
    static let sunglasses4Pentagon = ImageResource(name: "sunglasses_4_pentagon", bundle: resourceBundle)

    /// The "sunglasses_5_roundmulticolor" asset catalog image resource.
    static let sunglasses5Roundmulticolor = ImageResource(name: "sunglasses_5_roundmulticolor", bundle: resourceBundle)

    /// The "sunglasses_6_round" asset catalog image resource.
    static let sunglasses6Round = ImageResource(name: "sunglasses_6_round", bundle: resourceBundle)

    /// The "sunglasses_7_round" asset catalog image resource.
    static let sunglasses7Round = ImageResource(name: "sunglasses_7_round", bundle: resourceBundle)

    /// The "sunglasses_8_round" asset catalog image resource.
    static let sunglasses8Round = ImageResource(name: "sunglasses_8_round", bundle: resourceBundle)

    /// The "sunglasses_9_star" asset catalog image resource.
    static let sunglasses9Star = ImageResource(name: "sunglasses_9_star", bundle: resourceBundle)

    /// The "thumbles_01" asset catalog image resource.
    static let thumbles01 = ImageResource(name: "thumbles_01", bundle: resourceBundle)

    /// The "thumbles_02" asset catalog image resource.
    static let thumbles02 = ImageResource(name: "thumbles_02", bundle: resourceBundle)

    /// The "thumbles_03" asset catalog image resource.
    static let thumbles03 = ImageResource(name: "thumbles_03", bundle: resourceBundle)

    /// The "thumbles_04" asset catalog image resource.
    static let thumbles04 = ImageResource(name: "thumbles_04", bundle: resourceBundle)

    /// The "thumbles_05" asset catalog image resource.
    static let thumbles05 = ImageResource(name: "thumbles_05", bundle: resourceBundle)

    /// The "thumbles_06" asset catalog image resource.
    static let thumbles06 = ImageResource(name: "thumbles_06", bundle: resourceBundle)

    /// The "thumbles_07" asset catalog image resource.
    static let thumbles07 = ImageResource(name: "thumbles_07", bundle: resourceBundle)

    /// The "thumbles_08" asset catalog image resource.
    static let thumbles08 = ImageResource(name: "thumbles_08", bundle: resourceBundle)

    /// The "thumbles_09" asset catalog image resource.
    static let thumbles09 = ImageResource(name: "thumbles_09", bundle: resourceBundle)

    /// The "thumbles_10" asset catalog image resource.
    static let thumbles10 = ImageResource(name: "thumbles_10", bundle: resourceBundle)

    /// The "thumbles_11" asset catalog image resource.
    static let thumbles11 = ImageResource(name: "thumbles_11", bundle: resourceBundle)

    /// The "thumbles_12" asset catalog image resource.
    static let thumbles12 = ImageResource(name: "thumbles_12", bundle: resourceBundle)

    /// The "thumbles_13" asset catalog image resource.
    static let thumbles13 = ImageResource(name: "thumbles_13", bundle: resourceBundle)

    /// The "thumbles_14" asset catalog image resource.
    static let thumbles14 = ImageResource(name: "thumbles_14", bundle: resourceBundle)

    /// The "thumbles_15" asset catalog image resource.
    static let thumbles15 = ImageResource(name: "thumbles_15", bundle: resourceBundle)

    /// The "thumbles_16" asset catalog image resource.
    static let thumbles16 = ImageResource(name: "thumbles_16", bundle: resourceBundle)

    /// The "thumbles_17" asset catalog image resource.
    static let thumbles17 = ImageResource(name: "thumbles_17", bundle: resourceBundle)

    /// The "thumbles_18" asset catalog image resource.
    static let thumbles18 = ImageResource(name: "thumbles_18", bundle: resourceBundle)

    /// The "thumbles_19" asset catalog image resource.
    static let thumbles19 = ImageResource(name: "thumbles_19", bundle: resourceBundle)

    /// The "thumbles_20" asset catalog image resource.
    static let thumbles20 = ImageResource(name: "thumbles_20", bundle: resourceBundle)

    /// The "thumbles_21" asset catalog image resource.
    static let thumbles21 = ImageResource(name: "thumbles_21", bundle: resourceBundle)

    /// The "thumbles_22" asset catalog image resource.
    static let thumbles22 = ImageResource(name: "thumbles_22", bundle: resourceBundle)

    /// The "thumbles_23" asset catalog image resource.
    static let thumbles23 = ImageResource(name: "thumbles_23", bundle: resourceBundle)

    /// The "thumbles_24" asset catalog image resource.
    static let thumbles24 = ImageResource(name: "thumbles_24", bundle: resourceBundle)

    /// The "thumbles_25" asset catalog image resource.
    static let thumbles25 = ImageResource(name: "thumbles_25", bundle: resourceBundle)

    /// The "thumbles_26" asset catalog image resource.
    static let thumbles26 = ImageResource(name: "thumbles_26", bundle: resourceBundle)

    /// The "thumbles_27" asset catalog image resource.
    static let thumbles27 = ImageResource(name: "thumbles_27", bundle: resourceBundle)

    /// The "thumbles_28" asset catalog image resource.
    static let thumbles28 = ImageResource(name: "thumbles_28", bundle: resourceBundle)

    /// The "thumbles_29" asset catalog image resource.
    static let thumbles29 = ImageResource(name: "thumbles_29", bundle: resourceBundle)

    /// The "thumbles_30" asset catalog image resource.
    static let thumbles30 = ImageResource(name: "thumbles_30", bundle: resourceBundle)

    /// The "thumbles_31" asset catalog image resource.
    static let thumbles31 = ImageResource(name: "thumbles_31", bundle: resourceBundle)

    /// The "thumbles_32" asset catalog image resource.
    static let thumbles32 = ImageResource(name: "thumbles_32", bundle: resourceBundle)

    /// The "thumbles_33" asset catalog image resource.
    static let thumbles33 = ImageResource(name: "thumbles_33", bundle: resourceBundle)

    /// The "thumbles_34" asset catalog image resource.
    static let thumbles34 = ImageResource(name: "thumbles_34", bundle: resourceBundle)

    /// The "thumbles_35" asset catalog image resource.
    static let thumbles35 = ImageResource(name: "thumbles_35", bundle: resourceBundle)

    /// The "thumbles_36" asset catalog image resource.
    static let thumbles36 = ImageResource(name: "thumbles_36", bundle: resourceBundle)

    /// The "thumbles_37" asset catalog image resource.
    static let thumbles37 = ImageResource(name: "thumbles_37", bundle: resourceBundle)

    /// The "thumbles_38" asset catalog image resource.
    static let thumbles38 = ImageResource(name: "thumbles_38", bundle: resourceBundle)

    /// The "thumbles_39" asset catalog image resource.
    static let thumbles39 = ImageResource(name: "thumbles_39", bundle: resourceBundle)

    /// The "thumbles_40" asset catalog image resource.
    static let thumbles40 = ImageResource(name: "thumbles_40", bundle: resourceBundle)

    /// The "thumbles_41" asset catalog image resource.
    static let thumbles41 = ImageResource(name: "thumbles_41", bundle: resourceBundle)

    /// The "thumbles_42" asset catalog image resource.
    static let thumbles42 = ImageResource(name: "thumbles_42", bundle: resourceBundle)

    /// The "thumbles_43" asset catalog image resource.
    static let thumbles43 = ImageResource(name: "thumbles_43", bundle: resourceBundle)

    /// The "thumbles_44" asset catalog image resource.
    static let thumbles44 = ImageResource(name: "thumbles_44", bundle: resourceBundle)

    /// The "thumbles_45" asset catalog image resource.
    static let thumbles45 = ImageResource(name: "thumbles_45", bundle: resourceBundle)

    /// The "thumbles_46" asset catalog image resource.
    static let thumbles46 = ImageResource(name: "thumbles_46", bundle: resourceBundle)

    /// The "thumbles_47" asset catalog image resource.
    static let thumbles47 = ImageResource(name: "thumbles_47", bundle: resourceBundle)

    /// The "thumbles_48" asset catalog image resource.
    static let thumbles48 = ImageResource(name: "thumbles_48", bundle: resourceBundle)

    /// The "thumbles_49" asset catalog image resource.
    static let thumbles49 = ImageResource(name: "thumbles_49", bundle: resourceBundle)

    /// The "thumbles_50" asset catalog image resource.
    static let thumbles50 = ImageResource(name: "thumbles_50", bundle: resourceBundle)

    /// The "thumbles_51" asset catalog image resource.
    static let thumbles51 = ImageResource(name: "thumbles_51", bundle: resourceBundle)

    /// The "thumbles_52" asset catalog image resource.
    static let thumbles52 = ImageResource(name: "thumbles_52", bundle: resourceBundle)

    /// The "thumbles_53" asset catalog image resource.
    static let thumbles53 = ImageResource(name: "thumbles_53", bundle: resourceBundle)

    /// The "thumbles_54" asset catalog image resource.
    static let thumbles54 = ImageResource(name: "thumbles_54", bundle: resourceBundle)

    /// The "thumbles_55" asset catalog image resource.
    static let thumbles55 = ImageResource(name: "thumbles_55", bundle: resourceBundle)

    /// The "thumbles_56" asset catalog image resource.
    static let thumbles56 = ImageResource(name: "thumbles_56", bundle: resourceBundle)

    /// The "thumbles_57" asset catalog image resource.
    static let thumbles57 = ImageResource(name: "thumbles_57", bundle: resourceBundle)

    /// The "thumbles_58" asset catalog image resource.
    static let thumbles58 = ImageResource(name: "thumbles_58", bundle: resourceBundle)

    /// The "thumbles_59" asset catalog image resource.
    static let thumbles59 = ImageResource(name: "thumbles_59", bundle: resourceBundle)

    /// The "thumbles_60" asset catalog image resource.
    static let thumbles60 = ImageResource(name: "thumbles_60", bundle: resourceBundle)

    /// The "thumbles_61" asset catalog image resource.
    static let thumbles61 = ImageResource(name: "thumbles_61", bundle: resourceBundle)

    /// The "thumbles_62" asset catalog image resource.
    static let thumbles62 = ImageResource(name: "thumbles_62", bundle: resourceBundle)

    /// The "thumbles_63" asset catalog image resource.
    static let thumbles63 = ImageResource(name: "thumbles_63", bundle: resourceBundle)

    /// The "thumbles_64" asset catalog image resource.
    static let thumbles64 = ImageResource(name: "thumbles_64", bundle: resourceBundle)

    /// The "thumbles_65" asset catalog image resource.
    static let thumbles65 = ImageResource(name: "thumbles_65", bundle: resourceBundle)

    /// The "thumbles_66" asset catalog image resource.
    static let thumbles66 = ImageResource(name: "thumbles_66", bundle: resourceBundle)

    /// The "thumbles_67" asset catalog image resource.
    static let thumbles67 = ImageResource(name: "thumbles_67", bundle: resourceBundle)

    /// The "thumbles_68" asset catalog image resource.
    static let thumbles68 = ImageResource(name: "thumbles_68", bundle: resourceBundle)

    /// The "thumbles_69" asset catalog image resource.
    static let thumbles69 = ImageResource(name: "thumbles_69", bundle: resourceBundle)

    /// The "thumbles_70" asset catalog image resource.
    static let thumbles70 = ImageResource(name: "thumbles_70", bundle: resourceBundle)

    /// The "thumbles_71" asset catalog image resource.
    static let thumbles71 = ImageResource(name: "thumbles_71", bundle: resourceBundle)

    /// The "thumbles_72" asset catalog image resource.
    static let thumbles72 = ImageResource(name: "thumbles_72", bundle: resourceBundle)

    /// The "thumbles_73" asset catalog image resource.
    static let thumbles73 = ImageResource(name: "thumbles_73", bundle: resourceBundle)

    /// The "thumbles_74" asset catalog image resource.
    static let thumbles74 = ImageResource(name: "thumbles_74", bundle: resourceBundle)

    /// The "thumbles_75" asset catalog image resource.
    static let thumbles75 = ImageResource(name: "thumbles_75", bundle: resourceBundle)

    /// The "thumbles_76" asset catalog image resource.
    static let thumbles76 = ImageResource(name: "thumbles_76", bundle: resourceBundle)

    /// The "thumbles_77" asset catalog image resource.
    static let thumbles77 = ImageResource(name: "thumbles_77", bundle: resourceBundle)

    /// The "thumbles_78" asset catalog image resource.
    static let thumbles78 = ImageResource(name: "thumbles_78", bundle: resourceBundle)

    /// The "thumbles_79" asset catalog image resource.
    static let thumbles79 = ImageResource(name: "thumbles_79", bundle: resourceBundle)

    /// The "thumbles_80" asset catalog image resource.
    static let thumbles80 = ImageResource(name: "thumbles_80", bundle: resourceBundle)

    /// The "thumbles_81" asset catalog image resource.
    static let thumbles81 = ImageResource(name: "thumbles_81", bundle: resourceBundle)

    /// The "thumbles_82" asset catalog image resource.
    static let thumbles82 = ImageResource(name: "thumbles_82", bundle: resourceBundle)

    /// The "thumbles_83" asset catalog image resource.
    static let thumbles83 = ImageResource(name: "thumbles_83", bundle: resourceBundle)

    /// The "thumbles_84" asset catalog image resource.
    static let thumbles84 = ImageResource(name: "thumbles_84", bundle: resourceBundle)

    /// The "thumbles_85" asset catalog image resource.
    static let thumbles85 = ImageResource(name: "thumbles_85", bundle: resourceBundle)

    /// The "thumbles_86" asset catalog image resource.
    static let thumbles86 = ImageResource(name: "thumbles_86", bundle: resourceBundle)

    /// The "thumbles_87" asset catalog image resource.
    static let thumbles87 = ImageResource(name: "thumbles_87", bundle: resourceBundle)

    /// The "thumbles_88" asset catalog image resource.
    static let thumbles88 = ImageResource(name: "thumbles_88", bundle: resourceBundle)

    /// The "thumbles_89" asset catalog image resource.
    static let thumbles89 = ImageResource(name: "thumbles_89", bundle: resourceBundle)

    /// The "thumbles_90" asset catalog image resource.
    static let thumbles90 = ImageResource(name: "thumbles_90", bundle: resourceBundle)

    /// The "thumbles_91" asset catalog image resource.
    static let thumbles91 = ImageResource(name: "thumbles_91", bundle: resourceBundle)

    /// The "thumbles_92" asset catalog image resource.
    static let thumbles92 = ImageResource(name: "thumbles_92", bundle: resourceBundle)

    /// The "thumbles_93" asset catalog image resource.
    static let thumbles93 = ImageResource(name: "thumbles_93", bundle: resourceBundle)

    /// The "thumbles_94" asset catalog image resource.
    static let thumbles94 = ImageResource(name: "thumbles_94", bundle: resourceBundle)

    /// The "thumbles_95" asset catalog image resource.
    static let thumbles95 = ImageResource(name: "thumbles_95", bundle: resourceBundle)

    /// The "thumbles_96" asset catalog image resource.
    static let thumbles96 = ImageResource(name: "thumbles_96", bundle: resourceBundle)

    /// The "thumbles_97" asset catalog image resource.
    static let thumbles97 = ImageResource(name: "thumbles_97", bundle: resourceBundle)

    /// The "thumbles_98" asset catalog image resource.
    static let thumbles98 = ImageResource(name: "thumbles_98", bundle: resourceBundle)

    /// The "thumbles_99" asset catalog image resource.
    static let thumbles99 = ImageResource(name: "thumbles_99", bundle: resourceBundle)

    /// The "thumbls_12" asset catalog image resource.
    static let thumbls12 = ImageResource(name: "thumbls_12", bundle: resourceBundle)

    /// The "thumbls_23" asset catalog image resource.
    static let thumbls23 = ImageResource(name: "thumbls_23", bundle: resourceBundle)

    /// The "thumbls_24" asset catalog image resource.
    static let thumbls24 = ImageResource(name: "thumbls_24", bundle: resourceBundle)

    /// The "triangle" asset catalog image resource.
    static let triangle = ImageResource(name: "triangle", bundle: resourceBundle)

    /// The "unchecked" asset catalog image resource.
    static let unchecked = ImageResource(name: "unchecked", bundle: resourceBundle)

    /// The "vintage" asset catalog image resource.
    static let vintage = ImageResource(name: "vintage", bundle: resourceBundle)

    /// The "vintage_0" asset catalog image resource.
    static let vintage0 = ImageResource(name: "vintage_0", bundle: resourceBundle)

    /// The "vintage_1" asset catalog image resource.
    static let vintage1 = ImageResource(name: "vintage_1", bundle: resourceBundle)

    /// The "vintage_2" asset catalog image resource.
    static let vintage2 = ImageResource(name: "vintage_2", bundle: resourceBundle)

    /// The "vintage_3" asset catalog image resource.
    static let vintage3 = ImageResource(name: "vintage_3", bundle: resourceBundle)

    /// The "vintage_4" asset catalog image resource.
    static let vintage4 = ImageResource(name: "vintage_4", bundle: resourceBundle)

    /// The "vintage_5" asset catalog image resource.
    static let vintage5 = ImageResource(name: "vintage_5", bundle: resourceBundle)

    /// The "vintage_6" asset catalog image resource.
    static let vintage6 = ImageResource(name: "vintage_6", bundle: resourceBundle)

    /// The "vintage_7" asset catalog image resource.
    static let vintage7 = ImageResource(name: "vintage_7", bundle: resourceBundle)

    /// The "vintage_8" asset catalog image resource.
    static let vintage8 = ImageResource(name: "vintage_8", bundle: resourceBundle)

    /// The "vintage_9" asset catalog image resource.
    static let vintage9 = ImageResource(name: "vintage_9", bundle: resourceBundle)

    /// The "whatsapp" asset catalog image resource.
    static let whatsapp = ImageResource(name: "whatsapp", bundle: resourceBundle)

    /// The "white" asset catalog image resource.
    static let white = ImageResource(name: "white", bundle: resourceBundle)

    /// The "wishes_10_coffeecup" asset catalog image resource.
    static let wishes10Coffeecup = ImageResource(name: "wishes_10_coffeecup", bundle: resourceBundle)

    /// The "wishes_11_sunholdigcoffeecupinhand" asset catalog image resource.
    static let wishes11Sunholdigcoffeecupinhand = ImageResource(name: "wishes_11_sunholdigcoffeecupinhand", bundle: resourceBundle)

    /// The "wishes_12_great" asset catalog image resource.
    static let wishes12Great = ImageResource(name: "wishes_12_great", bundle: resourceBundle)

    /// The "wishes_13_cool" asset catalog image resource.
    static let wishes13Cool = ImageResource(name: "wishes_13_cool", bundle: resourceBundle)

    /// The "wishes_14_seeya" asset catalog image resource.
    static let wishes14Seeya = ImageResource(name: "wishes_14_seeya", bundle: resourceBundle)

    /// The "wishes_15_yeah" asset catalog image resource.
    static let wishes15Yeah = ImageResource(name: "wishes_15_yeah", bundle: resourceBundle)

    /// The "wishes_16_thankyou" asset catalog image resource.
    static let wishes16Thankyou = ImageResource(name: "wishes_16_thankyou", bundle: resourceBundle)

    /// The "wishes_17_lovewithredheart" asset catalog image resource.
    static let wishes17Lovewithredheart = ImageResource(name: "wishes_17_lovewithredheart", bundle: resourceBundle)

    /// The "wishes_18_sorry" asset catalog image resource.
    static let wishes18Sorry = ImageResource(name: "wishes_18_sorry", bundle: resourceBundle)

    /// The "wishes_19_hello" asset catalog image resource.
    static let wishes19Hello = ImageResource(name: "wishes_19_hello", bundle: resourceBundle)

    /// The "wishes_1_goodmorningsunlightcoffee" asset catalog image resource.
    static let wishes1Goodmorningsunlightcoffee = ImageResource(name: "wishes_1_goodmorningsunlightcoffee", bundle: resourceBundle)

    /// The "wishes_20_beyourself" asset catalog image resource.
    static let wishes20Beyourself = ImageResource(name: "wishes_20_beyourself", bundle: resourceBundle)

    /// The "wishes_21_youcandoit" asset catalog image resource.
    static let wishes21Youcandoit = ImageResource(name: "wishes_21_youcandoit", bundle: resourceBundle)

    /// The "wishes_22_nevergiveup" asset catalog image resource.
    static let wishes22Nevergiveup = ImageResource(name: "wishes_22_nevergiveup", bundle: resourceBundle)

    /// The "wishes_23_goodvibes" asset catalog image resource.
    static let wishes23Goodvibes = ImageResource(name: "wishes_23_goodvibes", bundle: resourceBundle)

    /// The "wishes_24_thanks" asset catalog image resource.
    static let wishes24Thanks = ImageResource(name: "wishes_24_thanks", bundle: resourceBundle)

    /// The "wishes_25_omg" asset catalog image resource.
    static let wishes25Omg = ImageResource(name: "wishes_25_omg", bundle: resourceBundle)

    /// The "wishes_26_lovely" asset catalog image resource.
    static let wishes26Lovely = ImageResource(name: "wishes_26_lovely", bundle: resourceBundle)

    /// The "wishes_27_hello" asset catalog image resource.
    static let wishes27Hello = ImageResource(name: "wishes_27_hello", bundle: resourceBundle)

    /// The "wishes_28_smile" asset catalog image resource.
    static let wishes28Smile = ImageResource(name: "wishes_28_smile", bundle: resourceBundle)

    /// The "wishes_29_fun" asset catalog image resource.
    static let wishes29Fun = ImageResource(name: "wishes_29_fun", bundle: resourceBundle)

    /// The "wishes_2_susunglassessmillinggoodmorning" asset catalog image resource.
    static let wishes2Susunglassessmillinggoodmorning = ImageResource(name: "wishes_2_susunglassessmillinggoodmorning", bundle: resourceBundle)

    /// The "wishes_30_bye" asset catalog image resource.
    static let wishes30Bye = ImageResource(name: "wishes_30_bye", bundle: resourceBundle)

    /// The "wishes_31_love" asset catalog image resource.
    static let wishes31Love = ImageResource(name: "wishes_31_love", bundle: resourceBundle)

    /// The "wishes_32_goodthingstaketime" asset catalog image resource.
    static let wishes32Goodthingstaketime = ImageResource(name: "wishes_32_goodthingstaketime", bundle: resourceBundle)

    /// The "wishes_33_behappybebrightbeyou" asset catalog image resource.
    static let wishes33Behappybebrightbeyou = ImageResource(name: "wishes_33_behappybebrightbeyou", bundle: resourceBundle)

    /// The "wishes_34_positivemind" asset catalog image resource.
    static let wishes34Positivemind = ImageResource(name: "wishes_34_positivemind", bundle: resourceBundle)

    /// The "wishes_35_keepsmiling" asset catalog image resource.
    static let wishes35Keepsmiling = ImageResource(name: "wishes_35_keepsmiling", bundle: resourceBundle)

    /// The "wishes_36_emptydecorativeflowerbottom" asset catalog image resource.
    static let wishes36Emptydecorativeflowerbottom = ImageResource(name: "wishes_36_emptydecorativeflowerbottom", bundle: resourceBundle)

    /// The "wishes_37_emptyboardwithflowers" asset catalog image resource.
    static let wishes37Emptyboardwithflowers = ImageResource(name: "wishes_37_emptyboardwithflowers", bundle: resourceBundle)

    /// The "wishes_38_emptyboard" asset catalog image resource.
    static let wishes38Emptyboard = ImageResource(name: "wishes_38_emptyboard", bundle: resourceBundle)

    /// The "wishes_39_emptyboard" asset catalog image resource.
    static let wishes39Emptyboard = ImageResource(name: "wishes_39_emptyboard", bundle: resourceBundle)

    /// The "wishes_3_sleeingpandaundermoongoodnight" asset catalog image resource.
    static let wishes3Sleeingpandaundermoongoodnight = ImageResource(name: "wishes_3_sleeingpandaundermoongoodnight", bundle: resourceBundle)

    /// The "wishes_40_welcome" asset catalog image resource.
    static let wishes40Welcome = ImageResource(name: "wishes_40_welcome", bundle: resourceBundle)

    /// The "wishes_41_happywedding" asset catalog image resource.
    static let wishes41Happywedding = ImageResource(name: "wishes_41_happywedding", bundle: resourceBundle)

    /// The "wishes_42_savethedate" asset catalog image resource.
    static let wishes42Savethedate = ImageResource(name: "wishes_42_savethedate", bundle: resourceBundle)

    /// The "wishes_43_thankyou" asset catalog image resource.
    static let wishes43Thankyou = ImageResource(name: "wishes_43_thankyou", bundle: resourceBundle)

    /// The "wishes_4_sleepinggoodnight" asset catalog image resource.
    static let wishes4Sleepinggoodnight = ImageResource(name: "wishes_4_sleepinggoodnight", bundle: resourceBundle)

    /// The "wishes_5._halfmoonkissingstargoodnight" asset catalog image resource.
    static let wishes5Halfmoonkissingstargoodnight = ImageResource(name: "wishes_5._halfmoonkissingstargoodnight", bundle: resourceBundle)

    /// The "wishes_6_teddysleepingonhalfmoongoodnight" asset catalog image resource.
    static let wishes6Teddysleepingonhalfmoongoodnight = ImageResource(name: "wishes_6_teddysleepingonhalfmoongoodnight", bundle: resourceBundle)

    /// The "wishes_7_goodnight" asset catalog image resource.
    static let wishes7Goodnight = ImageResource(name: "wishes_7_goodnight", bundle: resourceBundle)

    /// The "wishes_8_cofeecuohaveagoodday" asset catalog image resource.
    static let wishes8Cofeecuohaveagoodday = ImageResource(name: "wishes_8_cofeecuohaveagoodday", bundle: resourceBundle)

    /// The "wishes_9_hotcoffeecupsassur" asset catalog image resource.
    static let wishes9Hotcoffeecupsassur = ImageResource(name: "wishes_9_hotcoffeecupsassur", bundle: resourceBundle)

    /// The "zigzag" asset catalog image resource.
    static let zigzag = ImageResource(name: "zigzag", bundle: resourceBundle)

}

// MARK: - Backwards Deployment Support -

/// A color resource.
struct ColorResource: Swift.Hashable, Swift.Sendable {

    /// An asset catalog color resource name.
    fileprivate let name: Swift.String

    /// An asset catalog color resource bundle.
    fileprivate let bundle: Foundation.Bundle

    /// Initialize a `ColorResource` with `name` and `bundle`.
    init(name: Swift.String, bundle: Foundation.Bundle) {
        self.name = name
        self.bundle = bundle
    }

}

/// An image resource.
struct ImageResource: Swift.Hashable, Swift.Sendable {

    /// An asset catalog image resource name.
    fileprivate let name: Swift.String

    /// An asset catalog image resource bundle.
    fileprivate let bundle: Foundation.Bundle

    /// Initialize an `ImageResource` with `name` and `bundle`.
    init(name: Swift.String, bundle: Foundation.Bundle) {
        self.name = name
        self.bundle = bundle
    }

}

#if canImport(AppKit)
@available(macOS 10.13, *)
@available(macCatalyst, unavailable)
extension AppKit.NSColor {

    /// Initialize a `NSColor` with a color resource.
    convenience init(resource: ColorResource) {
        self.init(named: NSColor.Name(resource.name), bundle: resource.bundle)!
    }

}

protocol _ACResourceInitProtocol {}
extension AppKit.NSImage: _ACResourceInitProtocol {}

@available(macOS 10.7, *)
@available(macCatalyst, unavailable)
extension _ACResourceInitProtocol {

    /// Initialize a `NSImage` with an image resource.
    init(resource: ImageResource) {
        self = resource.bundle.image(forResource: NSImage.Name(resource.name))! as! Self
    }

}
#endif

#if canImport(UIKit)
@available(iOS 11.0, tvOS 11.0, *)
@available(watchOS, unavailable)
extension UIKit.UIColor {

    /// Initialize a `UIColor` with a color resource.
    convenience init(resource: ColorResource) {
#if !os(watchOS)
        self.init(named: resource.name, in: resource.bundle, compatibleWith: nil)!
#else
        self.init()
#endif
    }

}

@available(iOS 11.0, tvOS 11.0, *)
@available(watchOS, unavailable)
extension UIKit.UIImage {

    /// Initialize a `UIImage` with an image resource.
    convenience init(resource: ImageResource) {
#if !os(watchOS)
        self.init(named: resource.name, in: resource.bundle, compatibleWith: nil)!
#else
        self.init()
#endif
    }

}
#endif

#if canImport(SwiftUI)
@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
extension SwiftUI.Color {

    /// Initialize a `Color` with a color resource.
    init(_ resource: ColorResource) {
        self.init(resource.name, bundle: resource.bundle)
    }

}

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
extension SwiftUI.Image {

    /// Initialize an `Image` with an image resource.
    init(_ resource: ImageResource) {
        self.init(resource.name, bundle: resource.bundle)
    }

}
#endif