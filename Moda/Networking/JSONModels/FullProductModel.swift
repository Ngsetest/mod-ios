//
//  FullProductModel.swift
//  Moda
//
//  Created by Ruslan Lutfullin on 5/5/18.
//  Copyright © 2018 moda. All rights reserved.
//

import Foundation

struct FullProductModel: InitModel {
    let brand: Brand
    let colors: [Color]
    let category: Category
    let composition: String?
    let gallery: [GalleryItem]
    let id: Int
    let image: Image
    let name: String
    let sizes: [Size]
    let variations: [Variation]
    let variationImages: [GalleryItem]
    let views: Int
    let relationProducts: Collection
    let description: String?
    let status: Int?
    let sku : String?
    let url : String?
    let sharelink : String?

    var count: Int?
    var color: Color?
    var _size: Size?
 
    func getChoosenVariation() -> Variation {
        if color != nil && _size != nil {
 
            let variation =  variations.filter{ ($0.colorId == color!.id) && ($0.sizeId == _size!.id) }.first
            
            if variation != nil {
                return variation!
            }
        }
        
        return variations.first!
    }
    
    func getShortProduct() -> ShortProduct {
        
        return ShortProduct(
            id: id,
            name: name,
            brand: brand,
            color: color,
            size: _size,
            image: image,
            count: count,
            sku: sku)

    }
    
    func getProduct() -> Product {
        
        return Product(
            brand: brand,
            category: category,
            id: id,
            name: name,
            image: image,
            variations: variations,
            status:status,
            sku: sku,
            count: 1,
            color: color,
            _size: _size)
    }
}

struct Color: InitModel, Equatable {
    let id: Int
    let name: String
    let value: String
}

struct Size: InitModel, Equatable {
    let id: Int
    let name: String
}

struct GalleryItem: InitModel {
    let colorId: Int
    let `extension`: String
    let name: String
    let path: String

    var url: URL {
        let path =  NetworkManager.baseURL + "\(self.path)/\(self.name).\(self.extension)".encodeUrl()!
//        print(path)
        return URL(string: path)!
    }

}

struct OrderCheck: InitModel {
    let id: Int = 0
    let status: String
}


