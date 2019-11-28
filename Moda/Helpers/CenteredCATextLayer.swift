//
//  File.swift
//  Moda
//
//  Created by Ruslan Lutfullin on 4/25/18.
//  Copyright © 2018 moda. All rights reserved.
//

import UIKit

class CenteredCATextLayer: CATextLayer {
    override init() {
        super.init()
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(layer: aDecoder)
    }
    
    override func draw(in ctx: CGContext) {
        let height = bounds.size.height
        let fontSize = self.fontSize
        let yDiff = (height - fontSize) / 2 - fontSize / 10
        
        ctx.saveGState()
        ctx.translateBy(x: 0.0, y: yDiff)
        super.draw(in: ctx)
        ctx.restoreGState()
    }
}
