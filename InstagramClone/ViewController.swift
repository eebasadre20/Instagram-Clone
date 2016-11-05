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
    var signupActive = true
    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var signUpBtn: UIButton!
    @IBOutlet weak var loginBtn: UIButton!
    
    @IBOutlet weak var alreadyRegistered: UILabel!
    var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
    
    @IBAction func signup(sender: AnyObject) {
        if username.text == "" || password.text == "" {
            displayAlert("Oop! Something wrong.", message: "Please enter username and password")
        } else {
            activityIndicator = UIActivityIndicatorView(frame: CGRectMake(0,0,50,50))
            activityIndicator.center = self.view.center
            activityIndicator.hidesWhenStopped = true
            activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.Gray
            view.addSubview(activityIndicator)
            activityIndicator.startAnimating()
            UIApplication.sharedApplication().beginIgnoringInteractionEvents()
            
            signup()
        }
    }
    
    @IBAction func login(sender: AnyObject) {
        if signupActive == true {
           signUpBtn.setTitle("Login", forState: UIControlState.Normal)
           alreadyRegistered.text = "Not yet registered?"
           loginBtn.setTitle("Sign up", forState: UIControlState.Normal)
           signupActive = false
        } else {
            signUpBtn.setTitle("Sign up", forState: UIControlState.Normal)
            alreadyRegistered.text = "Already registered?"
            loginBtn.setTitle("Login", forState: UIControlState.Normal)
            signupActive = true

        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
//        let testObject = PFObject(className: "TestObject")
//        testObject["foo"] = "bar"
//        testObject.saveInBackgroundWithBlock { (success, error) -> Void in
//            if( error != nil ) {
//                print(error)
//            } else {
//                print("Object successfully saved.")
//            }
//        }

        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func signup() {
        var errorMsg = "Please! Try again later."
        
        if signupActive == true {
            let user = PFUser()
            user.username =  username.text
            user.password =  password.text
        
            user.signUpInBackgroundWithBlock { (success, error) -> Void in
                self.activityIndicator.stopAnimating()
                UIApplication.sharedApplication().endIgnoringInteractionEvents()
            
                if error == nil {
                    // Signup successful
                } else {
                    if let error = error!.userInfo["error"] as? String {
                        errorMsg = error
                        self.displayAlert("Oops! Something in Signup.", message: errorMsg)
                    }
                }
            }
        } else {
            PFUser.logInWithUsernameInBackground(username.text!, password: password.text!, block: { (user, error) -> Void in
                self.activityIndicator.stopAnimating()
                UIApplication.sharedApplication().endIgnoringInteractionEvents()

                if user != nil {
                    // logged in
                } else {
                    if let error = error!.userInfo["error"] as? String {
                        errorMsg = error
                        self.displayAlert("Sorry! Failed to login.", message: errorMsg)
                    }
                }
            })
        }
    
    }
    
    func displayAlert(title: String, message: String) {
        if #available(iOS 8.0, *) {
            let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: { (action) -> Void in
                self.dismissViewControllerAnimated(true, completion: nil)
            }))
            
            self.presentViewController(alert, animated: true, completion: nil)
        } else {
            // Fallback on earlier versions
        }

    }
}
