//
//  UserDetailsViewController.swift
//  ParseStarterProject-Swift
//
//  Created by Shree Sampath on 7/27/16.
//  Copyright © 2016 Parse. All rights reserved.
//

import UIKit
import Parse

class UserDetailsViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    
    @IBOutlet weak var userImage: UIImageView!
    
    @IBAction func updateProfileImage(_ sender: AnyObject) {
        
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = UIImagePickerControllerSourceType.photoLibrary
        imagePicker.allowsEditing = false
        
        self.present(imagePicker, animated: true, completion: nil)
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            
            userImage.image = image
            
        }
        
        self.dismiss(animated: true, completion: nil)
        
    }
    
    @IBOutlet weak var genderSwitch: UISwitch!
    
    @IBOutlet weak var errorLabel: UILabel!
    
    @IBOutlet weak var interestedInSwitch: UISwitch!
    
    @IBAction func update(_ sender: AnyObject) {
        
        PFUser.current()?["isFemale"] = genderSwitch.isOn
        
        PFUser.current()?["isInterestedInWomen"] = interestedInSwitch.isOn
        
        let imageData = UIImagePNGRepresentation(userImage.image!)
        
        PFUser.current()?["photo"] = PFFile(name: "profile.png", data: imageData!)
        
        PFUser.current()?.saveInBackground(block: { (success, error) in
            
            if error != nil {
                
                var errorMessage = "Update failed - please try again"
                
                if let parseError = error?.userInfo["error"] as? String {
                    
                    errorMessage = parseError
                    
                }
                
                self.errorLabel.text = errorMessage
                
            } else {
                
                print("Updated")
                
                self.performSegue(withIdentifier: "showSwipingViewController", sender: self)
                
            }
            
        })
        
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()

        if let isFemale = PFUser.current()?["isFemale"] as? Bool {
            
            genderSwitch.setOn(isFemale, animated: false)
            
        }
        
        if let isInterestedInWomen = PFUser.current()?["isInterestedInWomen"] as? Bool {
            
            interestedInSwitch.setOn(isInterestedInWomen, animated: false)
            
        }
        
        if let photo = PFUser.current()?["photo"] as? PFFile {
            
            photo.getDataInBackground(block: { (data, error) in
                
                if let imageData = data {
                    
                    if let downloadedImage = UIImage(data: imageData) {
                        
                        self.userImage.image = downloadedImage
                        
                    }
                    
                }
                
            })
            
        }
        
        
        let urlArray = ["http://vignette4.wikia.nocookie.net/the-jetsons/images/6/63/Jane_Jetson.jpg/revision/latest?cb=20131012164053", "http://orig04.deviantart.net/a7b1/f/2012/163/a/0/lin_bamf_beifong_by_rhandi_mask-d537smd.jpg", "http://f.tqn.com/y/animatedtv/1/L/-/3/leela.jpg", "http://vignette3.wikia.nocookie.net/simpsons/images/0/0b/Marge_Simpson.png/revision/20140826010629", "http://vignette4.wikia.nocookie.net/scoobydoo/images/3/37/Daphne-1.jpg/revision/latest?cb=20100723063039", "http://i646.photobucket.com/albums/uu186/strummin_along/geocache/velma_zps842ed69b.gif"]
        
        var counter = 0
        
        for urlString in urlArray {
            
            counter += 1
            
            let url = URL(string: urlString)!
            
            do {
            
            let data = try Data(contentsOf: url)
                
            let imageFile = PFFile(name: "photo.png", data: data)
                
            let user = PFUser()
                
            user["photo"] = imageFile
            
            user.username = String(counter)
                
            user.password = "password"
                
            user["isInterestedInWomen"] = false
            
            user["isFemale"] = true
                
            let acl = PFACL()
                
            acl.getPublicWriteAccess = true
            
            user.acl = acl
                
            user.signUpInBackground(block: { (success, error) in
                
                if success {
                    
                    print("User signed up")
                    
                }
                
            })
                
            } catch {
                
                print("Could not get data")
                
            }
            
        }
        
        
        
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
