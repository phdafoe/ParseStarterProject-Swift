/**
* Copyright (c) 2015-present, Parse, LLC.
* All rights reserved.
*
* This source code is licensed under the BSD-style license found in the
* LICENSE file in the root directory of this source tree. An additional grant
* of patent rights can be found in the PATENTS file in the same directory.
*/

import UIKit
import Parse

class ViewController: UIViewController {
    
    //MARK: - VARIABLES LOCALES GLOBALES
    //4
    let loading = UIActivityIndicatorView() // Alloc init
 
    
    //MARK: - IBOUTLET
    
    @IBOutlet weak var textFieldUserName: UITextField!
    @IBOutlet weak var textFieldPassword: UITextField!
    @IBOutlet weak var textFieldPhoneNumber: UITextField!
    @IBOutlet weak var textFieldEmail: UITextField!
    
    //MARK: - UTILS / AUXILIARES
    //3
    func displayAlertViewController(title: String, message: String){
        
        let alertVC = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        let actionVC = UIAlertAction(title: "OK", style: .Default, handler: nil)
        alertVC.addAction(actionVC)
        presentViewController(alertVC, animated: true, completion: nil)
        
    }
    
    
    //MARK: - IBACTION
    
    @IBAction func sendInformationNewUserWithPassword(sender: AnyObject) {
        
        //print("Enhorabuena has sido Registrado con Éxito .)")
        //1 comprobacion si el usuario ha introducido o no tanto el usuario como el password
        var error = ""
        if textFieldUserName.text == "" || textFieldPassword.text == ""{
                error = "Por favor introduce un Usuario" + "\n y una Password"
        }else{
            //4 
            // cuando las cosas van a conectarse de modo remoto a un CMS como Parse o realizar la descarga o carga de imagenes desde un REST o SOAP, es necesario hacerlo de manera asincrona debemos mostrarle al usuario que se esta realizando un proceso en segundo plano y disponemos de un Activity Indicator que lo vamos a meter por codigo
        
            loading.center = self.view.center
            loading.hidesWhenStopped = true
            loading.activityIndicatorViewStyle = .Gray
            loading.startAnimating()
            
            self.view.addSubview(loading)
            // 4.1 -> debemos asegurarnos de que se bloqueen los botones de nuestra interfaz
            UIApplication.sharedApplication().beginIgnoringInteractionEvents()
            
            
            //1
            /*let alertVC = UIAlertController(title: "Bienvenido .)", message: "Usuario registrado correctamente", preferredStyle: .Alert)
            let actionVC = UIAlertAction(title: "OK", style: .Default, handler: nil)
            alertVC.addAction(actionVC)
            self.presentViewController(alertVC, animated: true, completion: nil)*/
            
            //2 -> este proceso es asincrono
            let user = PFUser()
            user.username = self.textFieldUserName.text!
            user.password = self.textFieldPassword.text!
            user.email = self.textFieldEmail.text!
            user["phone"] = self.textFieldPhoneNumber.text!
            
            //3
            user.signUpInBackgroundWithBlock({ (success, signError) -> Void in
                
                //4 -> aqui tenemos que quitar nuestro activity indicator
                self.loading.stopAnimating()
                self.loading.hidden = true
                
                // habilitamos nuevamente la interaccion de eventos
                UIApplication.sharedApplication().endIgnoringInteractionEvents()
                
                
                if let errorString = signError?.userInfo["error"] as? NSString  {
                    
                      self.displayAlertViewController("Error al registrar", message: String(errorString))
                }else{

                    self.displayAlertViewController("Bienvenido .)", message: "Usuario registrado correctamente")
                }
            })
        }
        
        if error != ""{
            self.displayAlertViewController("Error en el Formulario", message: error)
        }
        
        
    }
    
    
    @IBAction func didLogout(segue:UIStoryboardSegue){
        
        print("Logout")
    }
    
    //MARK: - LIFE CYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        
        textFieldUserName.text = ""
        textFieldPassword.text = ""
        textFieldEmail.text = ""
        textFieldPhoneNumber.text = ""
        
        
    }
    

    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.view.endEditing(true)
    }
}
