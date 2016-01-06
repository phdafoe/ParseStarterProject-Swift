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


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        //1
        //Traemos y pegamos la clave de parse este es el punto de entrada
        Parse.setApplicationId("p4v937otvTXnQJBxoHKyir8Dyk11Gdmnh4KiRj1P", clientKey: "AMkhLVbXY6ssb3TcJLt6NTtHgD2pYPpkJpYnpd0S")
        
        return true
        
    }
}
