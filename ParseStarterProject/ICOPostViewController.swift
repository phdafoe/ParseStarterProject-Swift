//
//  ICOPostViewController.swift
//  iCoInstagram
//
//  Created by User on 5/1/16.
//  Copyright © 2016 Parse. All rights reserved.
//

import UIKit
import Parse

class ICOPostViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    //MARK: - VARIABLES LOCALES GLOBALES
    var photoSelected : Bool = false
    
    //MARK: - IBOUTLET
    
    @IBOutlet weak var myImageToPost: UIImageView!
    @IBOutlet weak var myShareTextField: UITextField!
    @IBOutlet weak var myActivityIndicator: UIActivityIndicatorView!
    
    
    //MARK: - IBACTION
    @IBAction func myPostImage(sender: AnyObject) {
        
        //Aqui para compreobar que no haya habido ningun error y si lo hay que nos avise correctamente
        var error = ""
        
        //Esto quiere decir si (not)photoSelected -> si no ha habido una seleccion de foto etc...
        if !photoSelected{

            error = "Por favor escoge una imagen"
        }else if myShareTextField.text == ""{
            
            error = "Por favor, escribe un texto"
        }
        
        
        if error != ""{
         
            displayAlertView("Hey", message: error)
        }else{
            
            //Aqui creamos la Tabla Post
            let post = PFObject(className: "Post")
            
            //Aqui le metemos un titulo
            post["titulo"] = myShareTextField.text
            
            //Aqui vamos con la imagen
            //extraemos el dato de la imagen
            let imageData = UIImageJPEGRepresentation(self.myImageToPost.image!, 25.0)
            //let imageData = UIImagePNGRepresentation(self.myImageToPost.image!)
            
            //Creamos un fichero especial de Parse.com
            let imageFile = PFFile(name: "image.png", data: imageData!)
            
            //asignamos a una nueva columna la imagen tipo
            post["imageFile"] = imageFile

            //Aqui le decimos a la tabla "post" quien es el usuario que ha subido la imagen
            post["username"] = PFUser.currentUser()?.username
            
            //Loading con el Activity Indicator
            self.myActivityIndicator.startAnimating()
            UIApplication.sharedApplication().beginIgnoringInteractionEvents()

            //Guardamos en a base de datos
            
            post.saveInBackgroundWithBlock({ (success, error) -> Void in
                
                if success{
                    let alertView = UIAlertController(title: "Hey", message: "Enhorabuena, tu publicación se ha realizado correctamente", preferredStyle: .Alert)
                    let actionView = UIAlertAction(title: "ACEPTAR", style: .Default, handler: nil)
                    alertView.addAction(actionView)
                    self.presentViewController(alertView, animated: true, completion: nil)
                    
                    //Si es exitoso lo paramos y lo ocultamos
                    self.myActivityIndicator.stopAnimating()
                    self.myActivityIndicator.hidden = true
                    
                }else{
                    self.displayAlertView("No se pudo publicar", message: String(error))
                    
                    //Si es exitoso lo paramos y lo ocultamos
                    self.myActivityIndicator.stopAnimating()
                    self.myActivityIndicator.hidden = true
                }
                
                
                
                //Una vez publicada la imagen lo mas logico es que reiniciemos el view controller
                self.photoSelected = false
                self.myShareTextField.text = ""
                self.myImageToPost.image = UIImage(named: "placeholder-man.png")
                
                self.myActivityIndicator.stopAnimating()
                
                UIApplication.sharedApplication().endIgnoringInteractionEvents()
            })
        }
        
        
   
    }
    
    @IBAction func mySelectImageToPost(sender: AnyObject) {
        
        //creamos un UIImagePicker Controller que es el que me permitira tener acceso al componente imagen del dispositivo
        let picker = UIImagePickerController() //alloc init
        picker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        picker.allowsEditing = false
        picker.delegate = self
        
        presentViewController(picker, animated: true, completion: nil)
  
        
    }
    
    @IBAction func myLogout(sender: AnyObject) {
        
        PFUser.logOut()
        self.performSegueWithIdentifier("logout", sender: self)
        
        
        
    }
    
    //MARK: - LIFE CYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        
        myActivityIndicator.stopAnimating()

       
    }
    
    //MARK: - UIImagePickerControllerDelegate
    func imagePickerController(picker: UIImagePickerController,
        didFinishPickingImage image: UIImage,
        editingInfo: [String : AnyObject]?) {
            
            //Se nos suministra la imagen que se ha pasado como parametro desde el metodo delegado
            myImageToPost.image = image
            //Desaparecemos el controllador despues de estar satisfechos
            dismissViewControllerAnimated(true, completion: nil)
            photoSelected = true
        
        
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.view.endEditing(true)
        
    }
    
    //MARK: - UTILS / AUXILIARES
    func displayAlertView(title: String, message: String){
        
        let alertView = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        let actionView = UIAlertAction(title: "ACEPTAR", style: .Default, handler: nil)
        alertView.addAction(actionView)
        presentViewController(alertView, animated: true, completion: nil)
    }




}
