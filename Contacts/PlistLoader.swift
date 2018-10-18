//
//  PlistLoader.swift
//  Contacts
//
//  Created by Hao Wu on 2018/10/10.
//  Copyright © 2018年 Hao Wu. All rights reserved.
//

import Foundation

enum PlistError: Error {
    case invalidResource
    case parsingFailure
}

class Plistloader {
    static func array(fromFile name: String, ofType type: String) throws -> [[String: String]] {
        guard let path = Bundle.main.path(forResource: name, ofType: type) else {
            throw PlistError.invalidResource
        }
        
        guard let array = NSArray(contentsOfFile: path) as? [[String: String]] else {
            throw PlistError.parsingFailure
        }
        
        return array
    }
}

class ContactsSource {
    static var contacts: [Contact] {
        let data = try! Plistloader.array(fromFile: "ContactsDB", ofType: "plist")
        return data.compactMap { Contact(dictionary: $0) }
    }
}
