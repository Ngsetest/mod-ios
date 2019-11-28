//
//  FChooseDateViewController.swift
//  Moda
//
//  Created by Alimov Islom on 7/4/18.
//  Copyright © 2018 moda. All rights reserved.
//

import UIKit

class FChooseDateViewController: BaseViewController {
    
    weak var customDelegate:FCustomDateDelegation?
    var viewTitleString: String?
    var arrayOfDate:[String]?
    lazy var closeButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(#imageLiteral(resourceName: "cross"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(handleClose), for: .touchUpInside)
        return button
    }()
    let tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: UITableViewStyle.plain)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.separatorStyle = .none
        return tableView
    }()
    let viewTitleLabel: UILabel = {
        let title = UILabel()
        //title.text = viewTitleString//"Выберите дату доставки"
        title.font = UIFont.init(name: kFont_bold, size: 24)
        title.translatesAutoresizingMaskIntoConstraints = false
        title.numberOfLines = 0
        title.textAlignment = .left
        return title
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        if let viewTitleString = viewTitleString {
        viewTitleLabel.text = viewTitleString
        }
        view.backgroundColor = kColor_White
        view.addSubview(closeButton)
        view.addSubview(viewTitleLabel)
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        self.makeLayout()
        self.registerCell()
    }
    func makeLayout() {
        closeButton.widthAnchor.constraint(equalToConstant: 45).isActive = true
        closeButton.heightAnchor.constraint(equalToConstant: 45).isActive = true
        closeButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 25).isActive = true
        closeButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 10).isActive = true
        
       // viewTitleLabel.heightAnchor.constraint(equalToConstant: 28).isActive = true
        viewTitleLabel.topAnchor.constraint(equalTo:closeButton.bottomAnchor, constant: 8).isActive = true
        viewTitleLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        viewTitleLabel.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20).isActive = true
        
        tableView.topAnchor.constraint(equalTo: viewTitleLabel.bottomAnchor, constant: 8).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0).isActive = true
        tableView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        tableView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
    }
    func registerCell() {
        tableView.register(FChooseDateTableViewCell.self, forCellReuseIdentifier: FChooseDateTableViewCell.identifier)
    }
    
    @objc func handleClose() {
    self.dismiss(animated: true, completion: nil)
    }

}
extension FChooseDateViewController: UITableViewDelegate {
}
extension FChooseDateViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let viewTitleString = viewTitleString {
            if viewTitleString ==  TR("choose_delivery_date") {
                if let count = arrayOfDate?.count {
                    return count
                }
            }
            else {
                if let count = arrayOfDate?.count {
                    return count
                }
            }
        }
       return 0
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: FChooseDateTableViewCell.identifier, for: indexPath) as! FChooseDateTableViewCell
        cell.dateLabel.text = arrayOfDate?[indexPath.item]
        return cell
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return heightOfCell(indexPath)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return heightOfCell(indexPath)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        debugLog(arrayOfDate?[indexPath.item] ?? kEmpty)
       
        if viewTitleString == TR("choose_delivery_date") {
         customDelegate?.youHaveChoosed(date: arrayOfDate?[indexPath.item] ?? kEmpty, type: 0)
        } else {
        customDelegate?.youHaveChoosed(date: arrayOfDate?[indexPath.item] ?? kEmpty, type: 1)
        }
       
        self.dismiss(animated: true, completion: nil)
        
    }
    
    func heightOfCell(_ indexPath: IndexPath) -> CGFloat {
        return 58
    }
}
