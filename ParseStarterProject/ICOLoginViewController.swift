//
//  ICOLoginViewController.swift
//  iCoInstagram
//
//  Created by User on 4/1/16.
//  Copyright © 2016 Parse. All rights reserved.
//

import UIKit
import Parse

class ICOLoginViewController: UIViewController {
    
    
    //MARK: - VARIABLES LOCALES GLOBALES
    //4
    let loading = UIActivityIndicatorView() // Alloc init
    
    
    //MARK: - IBOUTLET
    
    @IBOutlet weak var mytextFieldUserNameOK: UITextField!
    @IBOutlet weak var myTextFieldPasswordOK: UITextField!
    
    //MARK: - IBACTION
    
    @IBAction func closeViewController(sender: AnyObject) {
        
        dismissViewControllerAnimated(true, completion: nil)
        
    }
    
    
    @IBAction func myLoginUser(sender: AnyObject) {

        //print("Enhorabuena has sido Registrado con Éxito .)")
        //1 comprobacion si el usuario ha introducido o no tanto el usuario como el password
        
        if mytextFieldUserNameOK.text == "" || myTextFieldPasswordOK.text == ""{

            self.displayAlertViewController("Por favor introduce un Usuario" + "\n y una Password", message: "")
            
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
            
            
            //2 -> este proceso es async
            let user = PFUser()
            user.username = self.mytextFieldUserNameOK.text!
            user.password = self.myTextFieldPasswordOK.text!

            PFUser.logInWithUsernameInBackground(self.mytextFieldUserNameOK.text!, password:self.myTextFieldPasswordOK.text!) {
                
                (user: PFUser?, loginError: NSError?) -> Void in
                
                //4 -> aqui tenemos que quitar nuestro activity indicator
                self.loading.stopAnimating()
                self.loading.hidden = true
                
                // habilitamos nuevamente la interaccion de eventos
                UIApplication.sharedApplication().endIgnoringInteractionEvents()
                
                if user != nil {
                    
                    //Aqui le pasamos el salto de ViewController cuando nos logamos de nuevo
                    self.performSegueWithIdentifier("JumpToUsersTVC", sender: self)
                    
                    //self.displayAlertViewController("Enhorabuena", message: "El Usuario ha podido acceder") 
                    
                } else {
                    if let errorString = loginError?.userInfo["error"] as? NSString  {
                        self.displayAlertViewController("Error al Acceder", message: String(errorString))
                    }else{
                        self.displayAlertViewController("Hey!", message: "El Usuario No ha podido acceder")
                    }
                }
            }
        }

    }
    
    
    //MARK: - UTILS / AUXILIARES
    func displayAlertViewController(title: String, message: String){
        
        let alertVC = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        let actionVC = UIAlertAction(title: "OK", style: .Default, handler: nil)
        alertVC.addAction(actionVC)
        presentViewController(alertVC, animated: true, completion: nil)
        
    }
    
    
    //MARK: - CYCLE LIFE
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //print(PFUser.currentUser())

        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        
        if PFUser.currentUser() != nil{
            self.performSegueWithIdentifier("JumpToUsersTVC", sender: self)
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.view.endEditing(true)
    }

}
