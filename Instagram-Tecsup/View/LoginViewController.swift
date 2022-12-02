//
//  LoginViewController.swift
//  Instagram-Tecsup
//
//  Created by Mac41 on 21/10/22.
//

import UIKit
import FirebaseAuth

class LoginViewController: UIViewController {
    
    
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        txtPassword.isSecureTextEntry = true

        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        checkSession()
    }
    
    func checkSession(){
        if Auth.auth().currentUser != nil{
            self.performSegue(withIdentifier: "seguelogin", sender: nil)
        }
    }
    
    @IBAction func onTapLogin(_ sender: UIButton) {
        if txtEmail.text == "" || txtPassword.text == "" {
            let alert = UIAlertController(title: "Error", message: "Completa los campos", preferredStyle: .alert)
            let alertButton = UIAlertAction(title: "ok",style: .default)
            alert.addAction(alertButton)
            present(alert, animated: true)
            return
        }
        signIn(email: txtEmail.text!, password: txtPassword.text!)
    }
    
    /// vamos a crear dos funciones  una para el registro y otra para el signing
    /// // si el usuario no existe llamo al registro
    func signIn(email:String, password:String){
        Auth.auth().signIn(withEmail: email, password: password){AuthResult, error in
            //error es la variable donde si pasa un error esta tendra valor, si error no tiene un valor entendemos
            //que todo esta bien por ende error es igual a nil
            if error == nil{
                //el usuario existe
                self.performSegue(withIdentifier: "seguelogin", sender: nil)
            }else{
                //el usuario nio existe
                self.signUp(email: email, password: password)
            }
        }
    }
    
    func signUp(email: String, password: String){
        Auth.auth().createUser(withEmail: email, password: password) {AuthResult, error in
            if error != nil {
                //vamos a crear alerta
                let alert = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle:
                        .alert)
                //Agregando un boton
                let alertButton = UIAlertAction(title:"ok", style: .default)
                alert.addAction(alertButton)
            }else{
                //se creo al usuario de forma correcta
                self.performSegue(withIdentifier: "seguelogin", sender: nil)
            }
    }
    }
}
