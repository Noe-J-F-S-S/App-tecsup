//
//  UpdateProfileViewController.swift
//  Instagram-Tecsup
//
//  Created by Mac41 on 4/11/22.
//

import UIKit
import FirebaseAuth
import FirebaseStorage
import FirebaseFirestore

class UpdateProfileViewController: UIViewController  {

    @IBOutlet weak var imageUpDateProfile: UIImageView!
    
    @IBOutlet weak var txtName: UITextField!
    @IBOutlet weak var txtUsername: UITextField!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtBio: UITextField!
    
    //para poder acceder a la galeria o camara debemos instanciar a UIImagePickerController
    let imagePicker = UIImagePickerController()
    let db = Firestore.firestore()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imageUpDateProfile.layer.cornerRadius = 40
        
        getCurrntUSer()
        setUpImagePicker()
        getUserDocument()
    }
    
    func getCurrntUSer(){
        let user = Auth.auth().currentUser
        txtEmail.text = user?.email
        txtName.text = user?.displayName
    }
    
    func setUpImagePicker(){
        imagePicker.delegate = self
    }
    
    func saveUserData(url: String){
        db.collection("users").document(Auth.auth().currentUser?.uid ?? "no-id").setData([
            "name": txtName.text!,
            "email": txtEmail.text!,
            "username": txtUsername.text!,
            "bio": txtBio.text!,
            "image":url
        ])
        
    }
    
    func imageFromUrl(url: String){
        let imageURL = URL(string: url)
        let data = try? Data(contentsOf: imageURL!)
        
        if let imageData = data {
            imageUpDateProfile.image = UIImage(data: imageData)
            imageUpDateProfile.contentMode = .scaleAspectFill
        }
    }
    
    func getUserDocument() {
        let user = db.collection("users").document(Auth.auth().currentUser?.uid ?? "no-id")
        user.getDocument { document, error in
            if error == nil {
                //todo esta bien
                let data = document?.data()
                
                if data == nil {
                    return
                }
                
                self.txtBio.text = data!["bio"] as? String
                self.txtName.text = data!["name"] as?  String
                self.txtEmail.text = data!["email"] as? String
                self.txtUsername.text = data!["username"] as? String
                self.imageFromUrl(url: data!["image"] as? String ?? "")
            }
        }
    }
    
    
    @IBAction func onTapBack(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
   
    @IBAction func onTapSaveData(_ sender: UIButton) {
        uploadImage()
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func onTapOpenGallery(_ sender: Any) {
        imagePicker.isEditing = false
        imagePicker.sourceType = .photoLibrary
        
        present(imagePicker, animated: true)
    }
    
}

extension UpdateProfileViewController: UIImagePickerControllerDelegate & UINavigationControllerDelegate{
    
    func uploadImage(){
        
        let storaRef = Storage.storage().reference().child("\(Auth.auth().currentUser?.uid ?? "").png")
        if let uploadDataImage = self.imageUpDateProfile.image?.jpegData(compressionQuality: 0.5){
            storaRef.putData(uploadDataImage) { metadata, error in
                if error == nil {
                    //Esta bien, vamos a obtener la URL de la foto
                    storaRef.downloadURL {url, error in
                        print(url?.absoluteString)
                        self.saveUserData(url: url?.absoluteString ?? "")
                    }
                } else{
                    print("Error\(error)")
                }
            }
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let pickerImage = info[.originalImage] as? UIImage{
            imageUpDateProfile.image = pickerImage
            imageUpDateProfile.contentMode = .scaleToFill
        }
        imagePicker.dismiss(animated: true)
    }
}
