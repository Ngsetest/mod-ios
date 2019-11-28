//
//  Validator.swift
//  Moda
//
//  Created by Ruslan Lutfullin on 5/21/18.
//  Copyright © 2018 moda. All rights reserved.
//

import Foundation

struct Validator {
    
    static func errorForEmptyLine() -> String {
        return TR("should_not_be_empty")
    }
        
    static func isValidEmail(_ value: String?) -> String? {
        
        guard (value != nil && !value!.isEmpty) else { return Validator.errorForEmptyLine() }
        
        let emailRegEx = "^(?:(?:(?:(?: )*(?:(?:(?:\\t| )*\\r\\n)?(?:\\t| )+))+(?: )*)|(?: )+)?(?:(?:(?:[-A-Za-z0-9!#$%&’*+/=?^_'{|}~]+(?:\\.[-A-Za-z0-9!#$%&’*+/=?^_'{|}~]+)*)|(?:\"(?:(?:(?:(?: )*(?:(?:[!#-Z^-~]|\\[|\\])|(?:\\\\(?:\\t|[ -~]))))+(?: )*)|(?: )+)\"))(?:@)(?:(?:(?:[A-Za-z0-9](?:[-A-Za-z0-9]{0,61}[A-Za-z0-9])?)(?:\\.[A-Za-z0-9](?:[-A-Za-z0-9]{0,61}[A-Za-z0-9])?)*)|(?:\\[(?:(?:(?:(?:(?:[0-9]|(?:[1-9][0-9])|(?:1[0-9][0-9])|(?:2[0-4][0-9])|(?:25[0-5]))\\.){3}(?:[0-9]|(?:[1-9][0-9])|(?:1[0-9][0-9])|(?:2[0-4][0-9])|(?:25[0-5]))))|(?:(?:(?: )*[!-Z^-~])*(?: )*)|(?:[Vv][0-9A-Fa-f]+\\.[-A-Za-z0-9._~!$&'()*+,;=:]+))\\])))(?:(?:(?:(?: )*(?:(?:(?:\\t| )*\\r\\n)?(?:\\t| )+))+(?: )*)|(?: )+)?$"
        
        let emailTest = NSPredicate(format: "SELF MATCHES %@", emailRegEx)
        let result = emailTest.evaluate(with: value!)
        
        return result ? nil :  TR("wrong_mail")
     }
    
    
    static func isValidPhone(_ value: String?) -> String? {
        
        guard (value != nil && !value!.isEmpty) else { return Validator.errorForEmptyLine() }

        let PHONE_REGEX = "^((\\+)|(00))[0-9]{6,14}$"
        let phoneTest = NSPredicate(format: "SELF MATCHES %@", PHONE_REGEX)
        let result = phoneTest.evaluate(with: kPhonePrefixDefault + value!)
        
        return result ? nil : TR("wrong_phone_number")
    }
    
    static func isValidOrderNumber(_ value: String?) -> String? {
        
        guard (value != nil && !value!.isEmpty) else { return Validator.errorForEmptyLine() }

        let result = value!.rangeOfCharacter(from: CharacterSet.decimalDigits.inverted) == nil
        
        return result ? nil : TR("wrong_number")
    }
    
    static func isValidRePassword(_ value: String?, _ value0: String?) -> String? {
        
        guard (value != nil) && (value0 != nil)  else { return Validator.errorForEmptyLine() }

        return value0! == value! ? nil : TR("passwords_are_different")
     }

    static func isValidPassword(_ value: String?) -> String? {
        
        guard value != nil else { return Validator.errorForEmptyLine() }

        return value!.count < 6 ? TR("password_is_longer") : nil
    }
    
    static func isValidMessage(_ value: String?) -> String? {
        
        guard value != nil else { return Validator.errorForEmptyLine() }

        return value!.count > 0 ? nil : TR("put_in_text")
    }
    
    static func isValidTFName(_ value: String?) -> Bool {
        return ( value != nil && !value!.isEmpty )
    }

    static func isValidTFEmail(_ value: String?) -> Bool {
        return isValidEmail(value) == nil
    }

    static func isValidName(_ value: String?, _ errorLine : String) -> String? {
        
        guard ( value != nil && !value!.isEmpty ) else { return Validator.errorForEmptyLine() }
        
        let countN =  value!.unicodeScalars.filter({ [" ", "-", "."].contains($0) }).count
        let countLetters =  value!.unicodeScalars.filter({ CharacterSet.letters.contains($0) }).count
        
        let result =   (countN + countLetters) == value!.unicodeScalars.count
        
        return result ? nil : errorLine
    }
}

extension String {
    
    func getDateFromString() -> Date {
        let dateFormatter = DateFormatter()
//        dateFormatter.timeZone = TimeZone(abbreviation: "GMT+0:00")
        dateFormatter.dateFormat  = "yyyy-MM-dd"
        let date = dateFormatter.date(from: self)
        guard let  safeDate = date else {
            return Date()
        }
        return safeDate
    }
}

extension Date {
    func fromDateToString() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMMM, EEEE"
        dateFormatter.locale = Locale(identifier: "ru")
        let dateType = dateFormatter.string(from: self)
        return dateType
    }
    
    
    func fiveDaysArray() -> [String] {
        var array = [String]()
        
        for x in 1...kDefaultDaysForDelivery {
            array.append(dayForDelivery(x-1).fromDateToString())
        }
        return array
    }
    
    func dayForDelivery(_ nextDays: Int = 0) -> Date {
        
        return Calendar.current.date(byAdding: .day, value: nextDays, to: self) ?? Date()
        
    }
}
