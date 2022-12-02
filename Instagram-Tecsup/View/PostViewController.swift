//
//  PostViewController.swift
//  Instagram-Tecsup
//
//  Created by Mac41 on 11/11/22.
//

import UIKit
import FirebaseAuth
import FirebaseStorage
import FirebaseFirestore

class PostViewController: UIViewController{

    @IBOutlet weak var imagePost: UIImageView!
    
    
    @IBOutlet weak var txttitle: UITextField!
    @IBOutlet weak var txtDescription: UITextField!
    
    //para poder acceder a la galeria o camara debemos instanciar a UIImagePickerController
    let imagePicker = UIImagePickerController()
    let db = Firestore.firestore()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpImagePicker()
        
    }
    
    
    func setUpImagePicker(){
        imagePicker.delegate = self
    }
    
    func savePostData(url: String){
        db.collection("post").addDocument(data: [
            "title": txttitle.text!,
            "description": txtDescription.text!,
            "image":url,
            "userId": Auth.auth().currentUser?.uid
        ])
        
    }
    
    func imageFromUrl(url: String){
        let imageURL = URL(string: url)
        let data = try? Data(contentsOf: imageURL!)
        
        if let imageData = data {
            imagePost.image = UIImage(data: imageData)
            imagePost.contentMode = .scaleAspectFill
        }
    }
    
    
    @IBAction func onTapOpenGallery(_ sender: UIButton) {
        imagePicker.isEditing = false
        imagePicker.sourceType = .photoLibrary
        
        present(imagePicker, animated: true)
    }
    
    @IBAction func onTapSaveData(_ sender: UIButton) {
        uploadNewImage()
        navigationController?.popViewController(animated: true)
    }
}

extension PostViewController: UIImagePickerControllerDelegate & UINavigationControllerDelegate{
    
    func uploadNewImage(){
        let numberN = Int.random(in: 1...10000)
        let storaRef = Storage.storage().reference().child("\(numberN)-\(Auth.auth().currentUser?.uid ?? "").png")
        if let uploadDataImage = self.imagePost.image?.jpegData(compressionQuality: 0.5){
            storaRef.putData(uploadDataImage) { metadata, error in
                if error == nil {
                    //Esta bien, vamos a obtener la URL de la foto
                    storaRef.downloadURL {url, error in
                        print(url?.absoluteString)
                        self.savePostData(url: url?.absoluteString ?? "")
                        self.txttitle.text = ""
                        self.txtDescription.text = ""
                        self.imagePost.image = nil
                    }
                } else{
                    print("Error\(error)")
                }
            }
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let pickerImage = info[.originalImage] as? UIImage{
            imagePost.image = pickerImage
            imagePost.contentMode = .scaleToFill
        }
        imagePicker.dismiss(animated: true)
    }
}
