//
//  TestClass.swift
//  Moda
//
//  Created by admin_user on 7/26/19.
//  Copyright © 2019 moda. All rights reserved.
//

import Foundation
import UIKit

/*
 Task description
 1. Define model to store data.
 2. Parse data and create instances from it.
 3. Find albums that were in top 10 in all countries.
 
 Chart positions: UK CAN FRA NOR US
 */

let records = [
    //    "Title;ReleaseDate;Label;UK;CAN;FRA;NOR;US",
    "A Hard Day's Night;26 June 1964;United Artists (US);1;1;5;—;1;",
    "Beatles for Sale;4 December 1964;Parlophone (UK);1;-;—;—;—;",
    "Beatles '65;15 December 1964;Capitol (US);—;1;80;—;1;",
    "Rubber Soul;3 December 1965;Parlophone (UK);1;1;5;—;1;",
    "Revolver;5 August 1966;Parlophone (UK);1;1;5;14;1;",
    "Sgt. Pepper's Lonely Hearts Club Band;26 May 1967;Parlophone (UK), Capitol (US);1;7;4;1;1;",
    "Magical Mystery Tour;27 November 1967[F];Parlophone (UK), Capitol (US);31;—;2;13;1;",
    "Yellow Submarine;13 January 1969;Apple (UK), Capitol (US);3;1;4;1;2;",
    "Abbey Road;26 September 1969;Apple;1;1;1;1;1;",
    "Let It Be;8 May 1970;Apple;1;1;5;1;1;"
]


var topAlbums : [String] {
    
    let maxPosition = Int(10)
    
    var topItems = [String]()
    
    for item in  records {
        
        let arr = item.components(separatedBy: ";")
        var isTenTop = true
        
        for j in 0..<5 {
 
            if (Int(arr[j + 3]) ?? (maxPosition + 1) ) > maxPosition {
                isTenTop = false
                break
            }
        }
        
        if isTenTop {
            topItems.append(item)
        }
    }
    
    return topItems
 }


