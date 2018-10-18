//
//  ContactDetailController.swift
//  Contacts
//
//  Created by Hao Wu on 2018/10/10.
//  Copyright © 2018年 Hao Wu. All rights reserved.
//

import UIKit

protocol ContactDetailControllerDelegate: class {
    func didMarkAsFavoriteContact(_ contact: Contact)
}

class ContactDetailController: UITableViewController {

    var contact: Contact?
    
    // Outlets
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var profileView: UIImageView!
    @IBOutlet weak var phoneNumberLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var streetAddressLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var stateLabel: UILabel!
    @IBOutlet weak var zipLabel: UILabel!
    
    weak var delegate: ContactDetailControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureView()
    }

    func configureView() {
        guard let contact = contact else { return }
        
        profileView.image = contact.image
        nameLabel.text = "\(contact.firstName) \(contact.lastName)"
        phoneNumberLabel.text = contact.phone
        emailLabel.text = contact.email
        streetAddressLabel.text = contact.street
        cityLabel.text = contact.city
        stateLabel.text = contact.state
        zipLabel.text = contact.zip
    }

    @IBAction func markAsFavorite(_ sender: Any) {
        guard let contact = contact else { return }
        delegate?.didMarkAsFavoriteContact(contact)
    }
    

}
