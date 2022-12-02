//
//  ProfileViewController.swift
//  Instagram-Tecsup
//
//  Created by Mac41 on 28/10/22.
//

import UIKit

class ProfileViewController: UIViewController {

    @IBOutlet weak var imageProfile: UIImageView!
    
    @IBOutlet weak var btnEdit: UIButton!
    @IBOutlet weak var btnStatics: UIButton!
    @IBOutlet weak var btnContacts: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        imageProfile.layer.cornerRadius = 30
        btnEdit.layer.cornerRadius = 13
        btnStatics.layer.cornerRadius = 13
        btnContacts.layer.cornerRadius = 13
        
        // Do any additional setup after loading the view.
    }

}
