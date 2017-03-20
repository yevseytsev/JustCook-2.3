//
//  photosViewController.swift
//  Just Cook
//
//  Created by Andriy Yevseytsev on 2016-Oct-29.
//  Copyright © 2017 Andriy Yevseytsev. All rights reserved.
///Users/Andrew/Desktop/Excellence/JustCook/application/codes/photosViewController.swift
import UIKit
import AVFoundation
import MobileCoreServices

enum SourceType {
    case photoLibrary
    case camera
}

class photosViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITableViewDelegate, UITableViewDataSource, Transportable {
    var indicator: UIActivityIndicatorView!
    let maneger = CoreDataManeger.sharedManager
    var meal: Meal!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var photosTableView: UITableView!
    @IBOutlet weak var shareSwitch: UISwitch!
    var recipe: Recipe!
    
    var freshTableView = true
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "photo", for: indexPath) as! photoTableViewCell
        if photos.count == 0 {
            cell.placeholder.isHidden = false
            cell.photo.image = UIImage()
        } else {
            cell.placeholder.isHidden = true
            cell.photo.image = photos[indexPath.row]
            
        }
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if photos.count == 0 {
            return 1
        } else {
            return photos.count
        }
        
    }
    
    @IBAction func cameraTap(_ sender: AnyObject) {
        guard UIImagePickerController.isSourceTypeAvailable(.camera) == true else {
            return
        }
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = .camera
        imagePicker.allowsEditing = true
        imagePicker.delegate = self
        self.present(imagePicker, animated: true, completion: nil)
        self.SourceType = .camera
    }
    
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        if photos.count > 0{
            return true
        }
        return false
    }
    
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let tmp = photos[sourceIndexPath.row]
        photos.remove(at: sourceIndexPath.row)
        photos.insert(tmp, at: destinationIndexPath.row)
    }
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        photosTableView.setEditing(editing, animated: animated)
    }
    
    
    @IBAction func libraryTap(_ sender: AnyObject) {
        guard UIImagePickerController.isSourceTypeAvailable(.photoLibrary) == true else {
            return
        }
        let imagePicker = UIImagePickerController()
        imagePicker.mediaTypes = UIImagePickerController.availableMediaTypes(for: .photoLibrary)!
        imagePicker.allowsEditing = true
        imagePicker.delegate = self
        self.present(imagePicker, animated : true, completion: nil)
        self.SourceType = .photoLibrary
    }
    
    var photos = [UIImage]()
    
    var SourceType: SourceType = .camera
    
    @IBAction func saveRecipe(_ sender: Any) {
        maneger.deletePhotos(from: recipe)
        print(photos.count)
        if photos.count > 0 {
            for i in 0..<photos.count{
                let photo: Photo = maneger.create(entity: "Photo") as! Photo
                let imageData = UIImagePNGRepresentation(photos[i])
                photo.setValuesForKeys(["photo": imageData, "index": i])
                recipe.addToPhotos(photo)
            }
        }
        
        if shareSwitch.isOn {
            view.isUserInteractionEnabled = false
            indicator.isHidden = false
            indicator.startAnimating()
            meal = Meal(recipeEntity: recipe)
            uploadRecipe(toOrder: nil){
                serverID in
                
                if serverID.compare(NSLocalizedString("Internet is required for publishing or searching recipes", comment: "-")) == .orderedSame || serverID.compare(NSLocalizedString("Need to login with Facebook for using publishing or searching recipes", comment: "-")) == .orderedSame {
                    self.view.isUserInteractionEnabled = true
                    self.indicator.isHidden = true
                    self.indicator.stopAnimating()
                    
                    self.prompt(error: serverID)
                    return
                }
                
                self.view.isUserInteractionEnabled = true
                self.recipe.setValue(serverID, forKey: "serverID")
                self.recipe.setValue(true, forKey: "isFinished")
                CoreDataManeger.sharedManager.saveContext()
                CoreDataManeger.sharedManager.saveContext()
                self.indicator.isHidden = true
                self.indicator.stopAnimating()
                
                self.navigationController?.pushViewController((self.storyboard?.instantiateViewController(withIdentifier: "ViewController"))!, animated: true)
            }
        }
        else {
            self.recipe.setValue(true, forKey: "isFinished")
            CoreDataManeger.sharedManager.saveContext()
            navigationController?.pushViewController((storyboard?.instantiateViewController(withIdentifier: "ViewController"))!, animated: true)
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        photosTableView.delegate = self
        photosTableView.dataSource = self
        
        nextButton.layer.shadowOffset = CGSize(width: 0, height: 0)
        nextButton.layer.shadowColor = UIColor.white.cgColor
        nextButton.layer.shadowRadius = 5.0
        nextButton.layer.shadowOpacity = 1.0
        nextButton.layer.masksToBounds = false
        
        self.navigationItem.rightBarButtonItem = self.editButtonItem
        
        indicator = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
        indicator.color = UIColor.black
        indicator.center = view.center
        indicator.isHidden = true
        indicator.stopAnimating()
        view.addSubview(indicator)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        let mediaType = info[UIImagePickerControllerMediaType] as! String
        let originalImage: UIImage!
        let editedImage: UIImage!
        let imageToSave: UIImage!
        
        if CFStringCompare(mediaType as CFString, kUTTypeImage, .compareCaseInsensitive) == CFComparisonResult.compareEqualTo {
            editedImage = info[UIImagePickerControllerEditedImage] as? UIImage
            originalImage = info[UIImagePickerControllerOriginalImage] as? UIImage
            
            if editedImage != nil {
                imageToSave = editedImage
            } else
            {
                imageToSave = originalImage
            }
            if SourceType == .camera {
                UIImageWriteToSavedPhotosAlbum(imageToSave!, nil, nil, nil)
            }
            photos.append(imageToSave)
            freshTableView = false
            DispatchQueue.main.async {
                self.photosTableView.reloadData()
            }
        }
        picker.dismiss(animated: true, completion: nil)
        
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete, photos.count > 0 {
            photos.remove(at: indexPath.row)
            tableView.reloadData()
        }
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        if photos.count > 0{
            return true
        }
        return false
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        prepareFields()
        if freshTableView == false {
            freshTableView = true
        }
    }
    
    func prepareFields() {
        guard freshTableView else {
            return
        }
        guard let phos = recipe.photos  else {
            return
        }
        
        guard phos.count > 0 else {
            return
        }
        
        let sorter = NSSortDescriptor(key: "index", ascending: true)
        
        for enty in phos.sortedArray(using: [sorter]) as! [Photo] {
            photos.append(UIImage(data: enty.photo!)!)
        }
    }
    
    // MARK: - Navigation
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    
}
