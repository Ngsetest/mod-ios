//
//  BaseFilterViewControllerCell.swift
//  Moda
//
//  Created by admin_user on 3/25/19.
//  Copyright © 2019 moda. All rights reserved.
//

import Foundation
import UIKit

class BaseFilterViewControllerCell: BaseTableViewCell {
    
    var nameOfCellSector = kEmpty
    var nameTitleKey = kEmpty
    
    var tableeOffset = CGFloat(0)
    var contentOffset = CGFloat(0)

    
    // MARK: - Outlets
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var arrow: UIImageView!
    
    var hideOn = true
    var ids = [ Int ]()

    
    // MARK: - Lifecycle methods
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none

        setNamesProperties()
    }
    
    //MARK: - Inner
 
    func animateOpenView(_ tablee: UITableView){
        
        UIViewPropertyAnimator.runningPropertyAnimator(withDuration: 0.3, delay: 0, options: [.curveEaseInOut], animations: {
            self.arrow.rotate(angle: 180)
            tablee.contentOffset = CGPoint(x: 0, y: self.contentOffset)
            self.layoutIfNeeded()
        }) { success in
            tablee.isScrollEnabled = false
        }
    }
    
    func animateCloseView(_ tablee: UITableView){
        
        UIViewPropertyAnimator.runningPropertyAnimator(withDuration: 0.3, delay: 0, options: [.curveEaseInOut], animations: {
            self.arrow.transform = CGAffineTransform.identity
            tablee.contentOffset = CGPoint(x: 0, y: 0)
            self.layoutIfNeeded()
        }) { success in
            tablee.isScrollEnabled = true
        }
    }
    
    
    func getClearNameForTitle(_ indexPath : IndexPath) -> String {
        
        let simple_name = getItemName(indexPath)
        
        return  simple_name.uppercased().trimmingCharacters(in: CharacterSet(charactersIn: "—"))
    }
    
    func updateSubTitleOfFilter(){
        
        title.text = kCommaWithEmpty
        
        for j in 0..<getSectionItemsCount() {
            
            for i in 0..<getItemsCount(j){
                let index = IndexPath(row: i, section: j)
                let idNumber = getItemId(index)
                
                if ids.contains(idNumber) {
                    title.text! += kCommaWithEmpty + getClearNameForTitle(index)
                }
            }
        }
 
        title.text =  title.text == kCommaWithEmpty ? kEmpty :
            title.text?.replacingOccurrences(of: kCommaWithEmpty + kCommaWithEmpty, with: kEmpty)
    }
 
    
    override func reloadTranslations() {
       
        
        titleLabel.text = TR(nameTitleKey).uppercased()
        updateSubTitleOfFilter()
        
    }
    
    func getTitlesForTags() -> [String] {
        
        if title.text != nil && title.text!.count > 0 {
            return title.text!.split(separator: ",").map { String($0) }
        } else {
            return []
        }
        
    }
    
    func setDataFromTag(_ idsOuter:  [String : Any]) {

        ids = idsOuter[nameOfCellSector] as? [Int] ?? [Int]()

        reloadTranslations()
    }
    
    
    func openAll(_ tablee: UITableView){
        
        setContentViewHeightConstraint(tableeOffset)
        animateOpenView(tablee)
    }
    
    func hideAll(_ tablee: UITableView, _ animated : Bool = true) -> (String , [Int], [String]){
        
        if animated {
            setContentViewHeightConstraint(superview?.bounds.height ?? 0)
            animateCloseView(tablee)
        }
 
        return (nameOfCellSector, ids, getTitlesForTags() )
    }
    
    //MARK: - Override
    
    public func setNamesProperties(){
        
        nameOfCellSector = kEmpty
        nameTitleKey = kEmpty
        
    }
    
    public func getItemName(_ index : IndexPath) -> String {
        return  kEmpty
    }
    
    
    public func getItemId(_ index : IndexPath) -> Int{
        return 0
    }
    
    public func getItemsCount(_ section : Int) -> Int{
        return   0
    }
    
    
    func getSectionItemsCount() -> Int{
        return  1
    }
 
    func setContentViewHeightConstraint(_ offsetY : CGFloat){
        
    }
    
}


class BaseFilterTableViewControllerCell: BaseFilterViewControllerCell {

    var nameOfCellIdentificator = kEmpty


    @IBOutlet weak var tableHeight: NSLayoutConstraint!
    
    @IBOutlet weak var table: UITableView!

    
    // MARK: - Lifecycle methods
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setTableProperties()
        
        updateSubTitleOfFilter()
    }
    
    override func reloadTranslations() {
        super.reloadTranslations()
 
        table.reloadData()
    }
    
    
    func setTableProperties(){
        
        setContentViewHeightConstraint(superview?.bounds.height  ?? 0)
        table.tableFooterView = UIView()
    }
    
    // MARK: - Private methods
    
    override func setContentViewHeightConstraint(_ offsetY : CGFloat){
        
        tableHeight.isActive = false
        let heightOfView = superview?.bounds.height  ?? 0
        tableHeight = table.heightAnchor.constraint(equalToConstant: heightOfView - offsetY)
        tableHeight.isActive = true
    }
    
}

// MARK: - UITableViewDataSource

extension BaseFilterTableViewControllerCell: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return getItemsCount(section)
        
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: nameOfCellIdentificator) ??
            UITableViewCell(style: .default, reuseIdentifier: nameOfCellIdentificator)
        cell.selectionStyle = .none
        cell.textLabel?.font = UIFont(name: kFont_normal, size: 12)!
        cell.textLabel?.textAlignment = .left
        cell.textLabel?.text = getItemName(indexPath).uppercased()
        
        checkCellWithV(cell, indexPath)
        
        return cell
    }
    
    func checkCellWithV(_ cell : UITableViewCell, _ indexPath: IndexPath){
        
        if ids.contains(getItemId(indexPath)) {
            cell.accessoryType = .checkmark
        } else {
            cell.accessoryType = .none
        }
    }
}

extension BaseFilterTableViewControllerCell: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let idNumber = getItemId(indexPath)
        if ids.contains(idNumber) {
            ids.removeAll( where: { $0 == idNumber })
        } else {
            ids.append(idNumber)
        }
        
        updateSubTitleOfFilter() 
        
        tableView.reloadRows(at: [indexPath], with: .fade)
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return getSectionItemsCount()
        
    }
    
}


