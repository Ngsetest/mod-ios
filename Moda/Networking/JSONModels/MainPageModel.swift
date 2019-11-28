//
//  MainPageModel.swift
//  Moda
//
//  Created by Ruslan Lutfullin on 5/5/18.
//  Copyright © 2018 moda. All rights reserved.
//

import Foundation

enum MainModelForView{
    case banners(items : [SliderItem], name : String)
    case sliders(items : [SliderItem], name : String)
    case collection(collection : Collection, name : String)
}

struct MainModel: InitModel {
    
    let slider: [SliderItem]
    let keys: [String : String]
    var productsData: [String : Collection]
 
    var blocks : [MainModelForView] {
        var arr = [MainModelForView]()
        let cleanSliderOfProductsForMobile = slider.filter{ $0.mobile == 1 }
        
        var arrSliders : [[SliderItem]] = []
        var collections  = productsData.values.map{ $0 }
        var countall = 0
        var i = 0
        
        while countall < cleanSliderOfProductsForMobile.count {
            let smallArr = cleanSliderOfProductsForMobile.filter{ ($0.groupId ?? 0) == i }
            if smallArr.count > 0 {
                arrSliders.append(smallArr)
            }
            countall += smallArr.count
            i += 1
        }
        
        i = 0
    
        while !arrSliders.isEmpty {
            let newI = i % 4
            i += 1

            if newI == 3 ,  collections.count > 0 {
                if var item = collections.first, item.data.count > 0 {
                    item.setDefaultColor()
                    let name = TR("premium_styles")
                    arr.append(.collection(collection: item, name: name))
                }
                collections.removeFirst()
                continue
            }
            
            let item = arrSliders.first
            let name = item?.first?.text ?? kEmpty
            
            if item?.count == 1 {
                arr.append(.banners(items: item ?? [], name: name))
            } else {
                arr.append(.sliders(items: item ?? [], name: name))
            }
            
            arrSliders.removeFirst()
        }
        
        return arr
    }
    

}

struct Collection: InitModel {
    
    let currentPage: Int
    var data: [Product]
    let perPage: Int
    let firstPageUrl: URL
    var nextPageUrl: URL?
    let prevPageUrl: URL?
    let total: Int?
    
    
    mutating func setDefaultColor(){
        
        for i in 0..<data.count {
            data[i].setDefaultColor()
        }
        
    }
}

struct SliderItem: InitModel {
    let category: Category
    let image: Image
    let text: String?
    let groupId : Int?
    let mobile : Int?
}

struct Product: InitModel, Equatable {
    
    let brand: Brand
    let category: Category
    var id: Int
    let name: String
    let image: Image?
    let variations: [Variation]
    let status: Int?
    let sku: String?

    var count: Int?
    var color: Color?
    var _size: Size?
    
    mutating func setDefaultColor(){
        
        let variationFirst = variations.first!
        if variationFirst.colorId != nil {
            color = Color(id: variationFirst.colorId!, name: kEmpty, value: kEmpty)
        }

    }
    
    func getChoosenVariation() -> Variation {
        if color != nil && _size != nil {
 
            let variation =  variations.filter{ ($0.colorId == color!.id) && ($0.sizeId == _size!.id) }.first
            
            if variation != nil {
                return variation!
            }
         }
        
        return variations.first!
    }
    
    func isPalindrome(_ word: String) -> Bool {
        // Please write your code here.
        
        let array = Array(word.lowercased())
        let count = array.count
        
        for i in 0..<count/2 {
            if array[i] != array[count-i] {
                return false
            }
        }
        
        return true
    }
    
    func isEqualToProduct(_ item : Product, _ fullEqual : Bool) -> Bool {
        
        if self.id == item.id {
            if fullEqual {
                if self.color == item.color {
                    if self._size == item._size{
                        return true
                    }
                }
            } else {
                return true
            }
        }
        
        return false
    }
    
    func getShortProduct() -> ShortProduct {
        
        let newProduct =  ShortProduct(
            id: id,
            name: name,
            brand: brand,
            color: color,
            size: _size,
            image: image,
            count: count,
            sku: sku)
    
        return newProduct
        
    }
    
}

struct Brand: InitModel, Equatable {
    let id: Int
    let name: String
    let slug: String?
    let position: Int?
}

struct Category: InitModel, Equatable {
    let id: Int
    let name: String
    let parentId: Int
    let position: Int
    let slug: String?
    let `class`: String?
    let imageId: Int?
    let sizetablemarkup : String?
}

struct Image: InitModel, Equatable {
    let `extension`: String
    let id: Int
    let name: String
    let path: String

    var url: URL { return URL(string: NetworkManager.baseURL + "\(self.path)/\(self.name).\(self.extension)".encodeUrl()!)! }
}

struct Variation: InitModel, Equatable {
    let colorId: Int?
    let id: Int
    let price: Int
    let price2: Int?
    let sizeId: Int?
}

extension String {
    
    func encodeUrl() -> String? { return addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed) }

    func decodeUrl() -> String? { return removingPercentEncoding }
}

struct CountryModel: InitModel {
    
    var name: String?
    var code: String?
}


struct PromoModel: InitModel {
    let code: String
    let message: String?
    let amountPercent: Int
    let status : Bool
}
