//
//  ICOFeedOtherInfoTableViewController.swift
//  iCoInstagram
//
//  Created by User on 6/1/16.
//  Copyright © 2016 Parse. All rights reserved.
//

import UIKit
import Parse

class ICOFeedOtherInfoTableViewController: UITableViewController {
    
    //MARK: - VARIABLES LOCALES GLOBALES
    //ARRAYS
    var myArrayTituloImagenes = [String]() //alloc init
    var myUserName = [String]() //alloc init
    var imagesPF = [PFFile]() //alloc init
    
    //aqui debo saber a quin estoy siguiendo
    var followedUser = "" //en principio no estoy siguiendo a nadie

    
    
    //MARK: - IBOUTLET
    
    @IBOutlet var myTableView: UITableView!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        getFollowedQuery()

    }
    
    //MARK: - UTILS / AUXILIARES
    
    func updateData(){


        let query = PFQuery(className:"Post")
        
        //la condicion es voy a saber a que usurio estoy siguiendo
        query.whereKey("username", equalTo:self.followedUser)
        
        query.findObjectsInBackgroundWithBlock {
            (objects: [PFObject]?, error: NSError?) -> Void in
            
            if error == nil {
                
                if let objects = objects {
                    
                    for object in objects {
                        
                        //Aqui vamos a ir recuperando los datos
                        self.myArrayTituloImagenes.append(object["titulo"] as! String)
                        self.myUserName.append(object["username"]as! String)
                        self.imagesPF.append(object["imageFile"]as! PFFile)
                    }
                    
                    self.myTableView.reloadData()
                }
            } else {
                // Log details of the failure
                print("Error: \(error!) \(error!.userInfo)")
            }
        }
    }
    
    func getFollowedQuery(){
        
        //Aqui debemos hacer un filtro de quienes son los usurios a los que estoy siguiendo por tanto no deberian salurme todas las imagenes de otros usuarios
        
        let query = PFQuery(className:"seguidores")
        
        //la condicion es que yo no seguidor soy equivalente  a mi mismo    
        query.whereKey("followers", equalTo:(PFUser.currentUser()?.username)!)
        
        query.findObjectsInBackgroundWithBlock {
            
            (objects: [PFObject]?, error: NSError?) -> Void in
            
            if error == nil {
                
                if let objects = objects {

                    for object in objects {

                        self.followedUser = object["following"] as! String
                        self.updateData() // esto en principio me saca todas las publicaciones asi que hay que meter otra condicion
                    }
                }
            } else {
                // Log details of the failure
                print("Error: \(error!) \(error!.userInfo)")
            }
        }

        
    }



    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return myArrayTituloImagenes.count
    }

    
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {

        let cell : ICOFeddCustomTableViewCell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! ICOFeddCustomTableViewCell

        // Configure the cell...
        
        cell.myTextLBLNamePicture.text = myArrayTituloImagenes[indexPath.row]
        cell.myTextLBLUserName.text = myUserName[indexPath.row]
        
        //Hay que descargar la imagen de manera async
        
        imagesPF[indexPath.row].getDataInBackgroundWithBlock { (imagenData, error) -> Void in
            
            if error == nil{
                let imageAsync = UIImage(data: imagenData!)
                cell.myCustomImage.image = imageAsync
                
            }else{
                print("Un error en la descarga de la Imagen \(indexPath.row)")
            }
        }
        

        return cell
    }
    

    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        return 350
    }

}
