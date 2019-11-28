//
//  InitModel.swift
//  Moda
//
//  Created by admin_user on 3/8/19.
//  Copyright © 2019 moda. All rights reserved.
//

import Foundation

public  protocol InitModel : Codable {
    
}


extension InitModel  {
   
    func toDictionary() -> [String : Any] {
        return (try? JSONSerialization.jsonObject(with: JSONEncoder().encode(self))) as? [String: Any] ?? [:]
    }
    
}
