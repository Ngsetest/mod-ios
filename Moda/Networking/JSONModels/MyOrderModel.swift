//
//  MyOrderModel.swift
//  Moda
//
//  Created by Stanislav's MacBook Pro on 29.08.2018.
//  Copyright © 2018 moda. All rights reserved.
//

import Foundation

struct MyOrderModel: InitModel {
    let id: Int
    let userId: Int
    let name: String?
    let surname: String?
    let email: String?
    let deliveryType: DeliveryType? = .TODAY_FITTING
    let phone: String?
    let amount: Double?
    let prepayment: AmountType? = .zero
    let address: String
    let paymentMethod: PaymentType? = .cod
    let state: String?
    let createdAt: String
    let deliveryPayment: Double?
    let products:[MyOrderProduct]

}



struct MyOrderProduct: InitModel {
    let id: Int
    let boutique: String
    let name: String?
    let color: String
    let size: String = kEmpty
    let price: Double?
    let quantity: Int

    let existing: MyOrderExisting = MyOrderExisting.createSelf()
    
    func getShortProduct() -> ShortProduct {
        
        return ShortProduct(
            id: existing.id,
            name: existing.name,
            brand: existing.brand,
            color: existing.variations.first?.color,
            size: nil,
            image: existing.image,
            count: quantity,
            sku: existing.sku
        )
    }
    
}

struct ShortProduct: InitModel {
    let id: Int
    let name: String?
    let brand: Brand
    let color: Color?
    let size: Size?
    let image: Image?
    let count: Int?
    let sku: String?

}

struct MyOrderExisting: InitModel {
    let id: Int
    let composition: String
    let name: String?
    let image: Image
    let brand: Brand
    let sku: String?
    let variations: [MyOrderVariations]
    let discount: Double?
    
    static func createSelf() -> MyOrderExisting{
        
        return MyOrderExisting(id: 0, composition: kEmpty, name: kEmpty, image: Image(extension: kEmpty, id: 0, name: kEmpty, path: kEmpty), brand: Brand(id: 0, name: kEmpty, slug: kEmpty, position: 0), sku: kEmpty, variations: [], discount: 0)
    }
}

struct MyOrderVariations: InitModel {
    let id: Int
    let position: Int
    let inStock: Int
    let price: Double?
    let price2: Double?
    let color: Color
}
