//
//  AddressViewController.swift
//
//  Created by Ruslan Lutfullin on 5/16/18.
//

import MapKit
import LUAutocompleteView
import SkyFloatingLabelTextField
import UIKit
import AddressBookUI


class MyTextField: SkyFloatingLabelTextField {

    var myTag = IndexPath(row: 0, section: 0)
    
}


class AddressViewController: BaseViewController,
UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource {


    
    // MARK: - Data

    var data: PaymentModel!
    var completionHandler: ((Bool)->Void)?
    var profile: LogInInfo!

    let autocompleteView = LUAutocompleteView()
 
    var currentTextFieldKey : Int = 0
 
    let locationManager = CLLocationManager()

    var searchCompleter = MKLocalSearchCompleter()
    var searchResults = [String]()
    
    var currentCities = [TR("cityDefault")]
 
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var onSend: UIButton!{
        didSet{
            self.onSend.layer.cornerRadius = 6
            self.onSend.clipsToBounds = true
        }
    }

    @IBOutlet weak var titleLabel: UILabel!

    
    //MARK: - View Controller

    override func viewDidLoad() {
        
        super.viewDidLoad()

        setViewProperties()
        
        addKeyboardWillShowNotif()
        
        setAutocompleteViewProperties()
        
        setLocationSearch()
  
        getDeliveryModelUpdate()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
        
        reloadTranslations()
    }
     
    
    //MARK: - Functions
    
    func getDeliveryModelUpdate(){
 
        getDeliveryModel {
 
            self.tableView.reloadData()
            
        }
        
    }
        
    func loadCitiesNames(_ location : CLLocation){
 
 
        CLGeocoder().reverseGeocodeLocation(location) { placemarks , error in
            
            guard error == nil else {
                
                debugLog("CLGeocoder().reverseGeocodeLocation = " + error!.localizedDescription)
                return
            }
            
            self.currentCities = placemarks?.map({ placemark -> String in
                let line = "\(placemark.addressDictionary?["City"] ?? kEmpty)"
                debugLog(line)
                return line
                
            }) ?? [TR("cityDefault")]
 
        }
    }
    
    func setLocationSearch(){
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
        
    }
    
    func addKeyboardWillShowNotif(){
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(self.keyboardWillShow),
            name: .UIKeyboardWillShow,
            object: nil
        )
    }
    
    func setViewProperties(){

        view.layer.cornerRadius = 5
        view.clipsToBounds = true
        view.isOpaque = true
        
        
        navigationController?.navigationBar.layer.cornerRadius = 5
        navigationController?.navigationBar.clipsToBounds = true
        navigationController?.navigationBar.isOpaque = true
        navigationController?.navigationBar.backgroundColor = .clear
        
    }

    override func reloadTranslations() {
        
        navigationItem.title = TR("delivery_address")
        searchCompleter.delegate = self
        tableView.reloadData()
        
    }

    
    
    //MARK: - TableView

    

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
                return 56
        }
        else {
            return 130
        }
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       
        if section == 0 {
            
            return addressPartsNames.count
            
        } else {
            
            return deliveryConidtions.count
        }
    }
    
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        if section == 0 {
            
            return nil
            
        } else {
            
            return TR("choose_delivery_conditions")
        }
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {

            
        }
        else {
            
            data.deliveryType = deliveryKeyTypes[indexPath.row]
            
            tableView.reloadSections(IndexSet(arrayLiteral: 1), with: .automatic)
        }
            
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
 
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "id_cell_address", for: indexPath)
            cell.layoutIfNeeded()
            
            let textContentType : [UITextContentType] = [.addressCity, .sublocality, .streetAddressLine1, .streetAddressLine2]
            let contView = cell.contentView
            let indKey = addressPartsNames[indexPath.row]
 
            let textfField = contView.viewWithTag(100) as! MyTextField
            textfField.myTag = indexPath
            textfField.placeholder = TR(indKey)
            textfField.text = data.addressDescription[indKey] ?? kEmpty
            textfField.delegate = self
            textfField.textContentType = textContentType[indexPath.row]
            textfField.addTarget(self, action: #selector(textChanged(textField:)), for: .editingChanged)
 
            return cell
            
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "id_cell_delivery_conidtions", for: indexPath)
            cell.layoutIfNeeded()

            let contView = cell.contentView
            let indKey = deliveryConidtions[indexPath.row]
            let deliveyType  = deliveryKeyTypes[indexPath.row]

            let priceDelivery = getDeliveryPrice(for: deliveyType)
 
            let labelTitle = contView.viewWithTag(100) as! UILabel
            labelTitle.text = TR(indKey)
 
            let labelChoose = contView.viewWithTag(200) as! UILabel
            labelChoose.text = data.deliveryType == deliveyType ? TR("choosen") :  TR("choose_button")
            labelChoose.backgroundColor = data.deliveryType == deliveyType ? kColor_AppOrange : kColor_Black

            if  modelForDelivery?.methods[deliveyType.name]?.status ?? false {
                contView.layer.opacity = 1
                labelChoose.layer.opacity = 1
                cell.isUserInteractionEnabled = true
            } else {
                contView.layer.opacity = 0.5
                labelChoose.layer.opacity = 0
                cell.isUserInteractionEnabled = false

             }
            
            
            
            let labelDescription = contView.viewWithTag(300) as! UILabel
            labelDescription.text = String(format: TR("delivery_price_description"), setNiceCurrancy(priceDelivery))
            
            let labelDelivDate = contView.viewWithTag(400) as! UILabel
            labelDelivDate.text = chooseDeliveryDateLine(deliveyType)
            
            return cell
        }
        
    }
    

    
    //MARK: - keyboardWillShow

    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            let keyboardHeight = keyboardSize.height
            let preferredHeight = view.frame.height - keyboardHeight
            autocompleteView.maximumHeight =  preferredHeight
            view.layoutIfNeeded()
        }
    }
    

    
    
    //MARK: - Actions
    
    
    @IBAction func goNext(_ sender: UIButton) {

        data.address = TR("countryDefault")
        
        for keyNum in 0..<addressPartsNames.count {
            let key = addressPartsNames[keyNum]
            
            if let line = data.addressDescription[key] {
                data.address =  data.address! + ", " + line
            }
        }
 
        if (data.address == TR("countryDefault") ){
            
            showAlert(TR("enter_shipping_address"))
            return
        }
 
        guard let type = data.deliveryType else  {
 
            showAlert(TR("choose_delivery_conditions"))
            return
        }
 
        switch type {
        case .AFTER_TOMORROW:
            break
        case .TODAY_FITTING:
            
            data.dateLine = Date().fromDateToString()
            
            let nextVC = getVCFromMain("PrePaymentStep")  as! PrePaymentStep
            nextVC.data = data
            nextVC.completionHandler = { [weak self]
                (isReady) -> Void in
                if let callback = self?.completionHandler {
                    callback (isReady)
                }
            }
            showVC(nextVC)
            
            
            break
            
        case .IN_HOUR:
            
            let nextVC = getVCFromMain("DeliveryDateViewController") as! DeliveryDateViewController
            nextVC.data = data
            nextVC.completionHandler = { [weak self]
                (isReady) -> Void in
                if let callback = self?.completionHandler {
                    callback (isReady)
                }
            }
            
            showVC(nextVC)
            
            break
            
//        default:
//            break
        }
        

    }
    
    
    override func textChanged(textField: UITextField) {
        let textFieldMy = textField as! MyTextField
 
 
        switch textFieldMy.myTag.row {
        case 0: // region
   
            
            break
            
        case 1: // street
            
            break
            
        default:
            
            break
        }
        
        searchCompleter.queryFragment  = (textFieldMy.text ?? kEmpty)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {

        let tag = (textField as! MyTextField).myTag

        let newText = textField.text ?? kEmpty
 
        let indKey = addressPartsNames[tag.row]
        data.addressDescription[indKey]  = newText
//        tableView.reloadRows(at: [tag], with: .fade)
        
        
    }
 
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        
        currentTextFieldKey = (textField as! MyTextField).myTag.row
 
        if currentTextFieldKey == 0 && currentCities.count > 1 {
            autocompleteView.textField  = textField
            textField.delegate = self
            searchResults = currentCities
            autocompleteView.textFieldEditingChanged()
        }

        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        
    }
    
    func setAutocompleteViewProperties(){
        
        view.addSubview(autocompleteView)
        
        autocompleteView.dataSource = self
        autocompleteView.delegate = self
        autocompleteView.shouldHideAfterSelecting = true
        
    }
    
    

    
}


// MARK: - MKLocalSearchCompleterDelegate

extension AddressViewController: MKLocalSearchCompleterDelegate {

    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter){
        searchResults = completer.results.map{  String($0.title.split(separator: ",").first!)}
        autocompleteView.textFieldEditingChanged()
    }

    func completer(_ completer: MKLocalSearchCompleter, didFailWithError error: Error){
        debugLog("AddressViewController - Autocomplete error \(error.localizedDescription)")

    }

}


// MARK: - LUAutocompleteViewDataSource

extension AddressViewController: LUAutocompleteViewDataSource {

    func autocompleteView(_ autocompleteView: LUAutocompleteView, elementsFor text: String,
                          completion: @escaping ([String]) -> Void) {

        completion(searchResults)
 
    }
    
    
    
}




// MARK: - LUAutocompleteViewDelegate

extension AddressViewController: LUAutocompleteViewDelegate {

    func autocompleteView(_ autocompleteView: LUAutocompleteView, didSelect text: String) {
        print(text + " was selected from autocomplete view")

    }
}

extension AddressViewController : CLLocationManagerDelegate {
   
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
       
        if status == .authorizedWhenInUse {
            locationManager.requestLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        if let location = locations.first {
            
            searchCompleter.region = MKCoordinateRegion(center: location.coordinate,
                                                        span: MKCoordinateSpanMake(3, 3))

            loadCitiesNames(location)
            print("location::\(location)")
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("error:: \(error)")
    }
}



