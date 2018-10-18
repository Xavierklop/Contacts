//
//  ContactListController.swift
//  Contacts
//
//  Created by Hao Wu on 2018/10/10.
//  Copyright © 2018年 Hao Wu. All rights reserved.
//

import UIKit

extension Contact {
    var firstLetterForSort: String {
        return String(firstName.first!).uppercased()
    }
}

extension ContactsSource {
    static var sortedUniqueFirstLetters: [String] {
        let firstLetters = contacts.map { $0.firstLetterForSort }
        let uniqueFirstLetters = Set(firstLetters)
        return Array(uniqueFirstLetters).sorted()
    }
    
    static var sectionedContacts: [[Contact]] {
        let sections: [[Contact]] = sortedUniqueFirstLetters.map {firstLetter in
            // in each time, filteredContacts is a [Contact] with specified letter. For example, first time filteredContacts is a [Contact] with firstName started with "A".
            let filteredContacts = contacts.filter { $0.firstLetterForSort == firstLetter }
            // map {} use returned item make up a array, it is to say here map {} use the returned item [Contact] make up a [[Contact]] array.
            return filteredContacts.sorted(by: { $0.firstName < $1.firstName })
        }
        return sections
    }
}

class ContactListController: UITableViewController {
    
    let dataScource = ContactsDataSource(sectionedData: ContactsSource.sectionedContacts, sectionTitles: ContactsSource.sortedUniqueFirstLetters)

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = dataScource
    }
    
    // MARK: - Table View Delegate
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showContact" {
            if let indexPath = tableView.indexPathForSelectedRow {
                let contact = dataScource.object(at: indexPath)
                
                guard let navigationController = segue.destination as? UINavigationController, let contactDetailController = navigationController.topViewController as? ContactDetailController else { return }
                
                contactDetailController.contact = contact
                contactDetailController.delegate = self
            }
        }
    }
    
}

extension Contact: Equatable {
    static func ==(lhs: Contact, rhs: Contact) -> Bool {
        return lhs.firstName == rhs.firstName && lhs.lastName == rhs.lastName && lhs.street == rhs.street && lhs.city == rhs.city && lhs.state == rhs.state && lhs.zip == rhs.zip && lhs.phone == rhs.phone && lhs.email == rhs.email
    }
}

extension ContactListController: ContactDetailControllerDelegate {
    func didMarkAsFavoriteContact(_ contact: Contact) {
        guard let indexPath = dataScource.indexPath(for: contact) else { return }
        
        var favoriteContact = dataScource.object(at: indexPath)
        favoriteContact.isFavorite = true
        
        dataScource.updateContact(favoriteContact, at: indexPath)
        tableView.reloadData()
    }
}

