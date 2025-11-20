//
//  StickerModelClass.swift
//  AIEraseObjects
//
//  Created by Admin on 28/01/25.
//

import Foundation

struct StickerCategory: Codable {
    let categoryName: String
//    let prefix : String
//    let count:Int
    let stickers: [String] // Array of image names
}

struct StickerData: Codable {
    let categories: [StickerCategory]
}

// UNUSED:
/*
struct ImageAsset: Codable {
    let name: String
    let fileName: String
}

struct ImageCategories: Codable {
    let name: String
    let assets: [ImageAsset] // Dictionary of categories
}

struct ListCategory:Codable
{
    let list : [ImageCategories]
}
*/

//struct CategoryElement
//{
//    let name:String
//    let stickerNames : [String]
//}
