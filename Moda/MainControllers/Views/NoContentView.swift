//
//  NoContentView.swift
//  Moda
//
//  Created by Shin Anatoly on 9/10/19.
//  Copyright © 2019 ason. All rights reserved.
//

import Foundation
import UIKit
public class NoContentView: UIView {
    private let titleLabel = UILabel()
    private let detailLabel = UILabel()
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        initialize()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        updateSubviewsFrame(self.frame.size)
    }
    
    private func initialize() {
        titleLabel.textAlignment = .center
        titleLabel.numberOfLines = 0
        titleLabel.text = TR("no_content")
        titleLabel.font = .gerberaMediumFont(ofSize: 16)
        self.addSubview(titleLabel)
        
        detailLabel.textAlignment = .center
        detailLabel.numberOfLines = 0
        detailLabel.text = TR("mod_lcc")
        detailLabel.adjustsFontSizeToFitWidth = true
        detailLabel.font = .gerberaFont(ofSize: 20)
        self.addSubview(detailLabel)
    }
    
    private func updateSubviewsFrame(_ size: CGSize) {
        let x = size.width/15
        let w = size.width - 2*x
        var h = titleLabel.text?.heightWithConstrainedWidth(width: w, font: .gerberaMediumFont(ofSize: 16)) ?? 0
        var y = size.height/2 - h
        self.titleLabel.frame = .init(x: x, y: y, width: w, height: h)
        
        y = titleLabel.frame.maxY + 2*x
        h = 23
        self.detailLabel.frame = .init(x: x, y: y, width: w, height: h)
    }
}
