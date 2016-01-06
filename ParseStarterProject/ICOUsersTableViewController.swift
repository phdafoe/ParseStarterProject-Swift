//
//  ICOUsersTableViewController.swift
//  iCoInstagram
//
//  Created by User on 4/1/16.
//  Copyright © 2016 Parse. All rights reserved.
//

import UIKit
import Parse

class ICOUsersTableViewController: UITableViewController {
    
    //MARK: - VARIABLES LOCALES GLOBALES
    var myArrayUsersOfParse : [String] = []
    //este array para almacenar los usuarios que estemos o no siguiendo
    //para eso tenemos que hacer una consulta para determinar o saber todos los usuarios a los que estoy siguiendo
    var followings = [Bool]()
    
    //MARK: - PULLTOREFRESH
    var refresher : UIRefreshControl!
    
    
    //MARK: - IBOUTLET
    @IBOutlet var myTableViewOfParse: UITableView!
    
    
    //MARK: - CYCLE LIFE
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //PULLTOREFRESH
        refresher = UIRefreshControl()//Alloc init
        refresher.attributedTitle = NSAttributedString(string: "Arrastra para recargar")
        refresher.addTarget(self, action: "refresh", forControlEvents: UIControlEvents.ValueChanged)
        myTableViewOfParse.addSubview(refresher)
        
        self.updateUsersOfParse()
   
    }
    
    //MARK: - UTILS / AUXILIARES
    
    func updateUsersOfParse(){
        //ESTA ES LA CONSULTA DE TODOS LOS USUARIOS QUE ESTAMOS SUGUIENDO
        let followingQuery = PFQuery(className:"seguidores")
        
        //una condicionen donde el seguidor es decir el follower soy yo currentUser OK!!
        followingQuery.whereKey("followers", equalTo:(PFUser.currentUser()?.username)!)
        
        followingQuery.findObjectsInBackgroundWithBlock {
            
            (currentUserMe: [PFObject]?, error: NSError?) -> Void in
            
            if error == nil {
                
                //Encapsulo en una variable temporal
                if let followingPeople = currentUserMe {
                    
                    //Aqui metemos la consulta a la base de datos que me excluye a mi mismo y me encuentra a todos los demas usuarios
                    // aqui realizamos una consulta a la base de datos
                    let query = PFUser.query()
                    
                    //solicitamos a la consulta  DE TODOS LOS USUARIOS QUE TENGO
                    query!.findObjectsInBackgroundWithBlock {
                        
                        (objects: [PFObject]?, error: NSError?) -> Void in
                        
                        //RECORRO TODOS LOS USUARIOS
                        for objectSelectDB in objects!{
                            
                            
                            let user: PFUser = objectSelectDB as! PFUser
                            
                            //PARA DEJAR DE SEGUIRME A MI MISMO
                            if user.username != PFUser.currentUser()?.username{
                                
                                //Y A LOS USUARIOS CONSULTADOS LOS METEMOS EN EL ARRAY DE USUARIOS DE PARSE
                                self.myArrayUsersOfParse.append(user.username!)
                                
                                //AQUI HABIENDO POBLADO EL ARRAY PUES DEBEMOS SABER SI EL USUARIO EN CUESTION QUE ESTAMOS ECUPERANDO DE LA BASE DE DATOS ES UNO DE LOS QUE ESTA EN LA COLUMNA DE SEGUIDOS
                                var isFollowing: Bool = false
                                for followingPerson in followingPeople{
                                    if followingPerson["following"] as? String == user.username{
                                        isFollowing = true
                                    }
                                }
                                //AQUI POBLAMOS CON ESTOS USURIOS ENCONTRADOS SI ES VERDADERO O NO
                                self.followings.append(isFollowing)
                            }
                            
                        }
                        //4 una vez que hayamos sacado nuestros usuarios debo decirle a la tabla recargar los datos
                        self.myTableViewOfParse.reloadData()
                        
                        //AQUI LE DECIMOS AL REFRESHER QUE PARE
                        self.refresher.endRefreshing()
                    }
                }
            } else {
                // Log details of the failure
                print("Error: \(error!) \(error!.userInfo)")
                
                //AQUI LE DECIMOS AL REFRESHER QUE PARE SI HA ENCONTRADO ALGUN ERROR
                self.refresher.endRefreshing()
            }
        }
        
        
    }

    
    func refresh(){
        
        //ESTO SE HACE PERO DEBERIA ACTUAR CUANDO SE RECARGAN LOS USUARIOS LO MAS RECOMENDABLE ES HACER UNA UNA FUNCION
        print("recargando")
        
        //AQUI METEMOS LA FUNCION DE ACTUALIZACION DE LOS USURIOS
        self.updateUsersOfParse()
    }

    // MARK: - Table view data source
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return myArrayUsersOfParse.count
    }


    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath)

        // Configure the cell...
        
        cell.textLabel?.text = myArrayUsersOfParse[indexPath.row]
        
        
        //AQUI DEBO CONFIGURAR LA MARQUITA DE LA DERECHA EL CHECKLIST
        if followings[indexPath.row]{
            
            cell.accessoryType = UITableViewCellAccessoryType.Checkmark

        }else{
            
            
            cell.accessoryType = UITableViewCellAccessoryType.None
        }

        return cell
    }
    

    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let cell: UITableViewCell = tableView.cellForRowAtIndexPath(indexPath)!
        
        if cell.accessoryType == UITableViewCellAccessoryType.Checkmark{
            
            cell.accessoryType = UITableViewCellAccessoryType.None
            
            //Esta consulta nos permitira parametrizar controlar nuestra consulta con mayor precision
            //Cambiamos el nombre de la Tabla (seguidores)
            
            let query = PFQuery(className:"seguidores")
            
            //una condicionen donde el seguidor soy yo currentUser
            query.whereKey("followers", equalTo:(PFUser.currentUser()?.username)!)
            
            //otra condicion si quiero borrar la celda especifica
            query.whereKey("following", equalTo:(cell.textLabel?.text)!)
            
            query.findObjectsInBackgroundWithBlock {
                (objects: [PFObject]?, error: NSError?) -> Void in
                if error == nil {
                    // The find succeeded.
                    print("Successfully retrieved \(objects!.count) scores.")
                    // Do something with the found objects
                    if let objects = objects {
                        for object in objects {
                            
                            //Eliminamos cada uno de esos objetos a seguir
                            object.deleteInBackgroundWithBlock(nil)
                        }
                    }
                } else {
                    // Log details of the failure
                    print("Error: \(error!) \(error!.userInfo)")
                }
            }
        }else{
            
            cell.accessoryType = UITableViewCellAccessoryType.Checkmark
            
            //PARA SEGUIR AL USUARIO creando una tabla de usuarios desde parse.com
            let following = PFObject(className: "seguidores")
            following["following"] = cell.textLabel?.text
            following["followers"] = PFUser.currentUser()?.username
            following.saveInBackgroundWithBlock(nil)
            
        }
    }
    
    
    
   
    
    

}