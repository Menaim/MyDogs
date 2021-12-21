//
//  AddDogsViewController.swift
//  My Dogs
//
//  Created by Menaim on 20/12/2021.
//

import UIKit
import CoreData

class AddDogsViewController: UIViewController {
    
    //MARK: - Outlets
    @IBOutlet weak var textFieldDogName: UITextField!
    
    @IBOutlet weak var textFieldDogColor: UITextField!
    
    @IBOutlet weak var textFieldFavoriteTreat: UITextField!
    
    @IBOutlet weak var imageViewDogImageOutlet: UIImageView!
    
    
    //MARK: - Vars
    var dog: Dog?
    // May be we have a value or not
    
    //MARK: - CoreData Vars
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    lazy var context = NSManagedObjectContext.init(concurrencyType: .mainQueueConcurrencyType)
    
    //MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        context = appDelegate.persistentContainer.viewContext
    }
    
    
  
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        setData()
    }
    
    //MARK: - Set Data
    func setData() {
        
        guard dog != nil else {
            debugPrint("Error")
            return
            
        }
        
        textFieldDogName.text = dog!.dogName
        self.title = dog!.dogName
        
        textFieldDogColor.text = dog!.dogColor
        textFieldFavoriteTreat.text = dog!.dogFavoriteTreat
        
        guard let data = dog!.dogImage else {return}
        
        imageViewDogImageOutlet.image = UIImage(data: data)
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Delete", style: .plain, target: self, action: #selector(deleteDog))
        
    }
    
    
    //MARK: - Save Data
    func saveData () {
        
        if dog != nil {
            
            dog!.dogName = textFieldDogName.text
            dog!.dogColor = textFieldDogColor.text
            dog!.dogFavoriteTreat = textFieldFavoriteTreat.text
            dog!.dogImage = imageViewDogImageOutlet.image?.jpegData(compressionQuality: 1)
            
        }
        
        else {
            
            let myDog = Dog(context: context)
            myDog.dogName = textFieldDogName.text
            myDog.dogColor = textFieldDogColor.text
            myDog.dogFavoriteTreat = textFieldFavoriteTreat.text
            myDog.dogImage = imageViewDogImageOutlet.image?.jpegData(compressionQuality: 1)
            // jpegData is helping us to transform the image into data to be able to save it inside the coreData
        }
        
        do {
            try context.save()
        }
        catch {
            print(error)
        }
        
        self.navigationController?.popViewController(animated: true)
        
    }
    
    //MARK: - Import Picture
    func importPicture() {
        
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            let imagePickerController = UIImagePickerController()
            imagePickerController.sourceType = .photoLibrary
            imagePickerController.delegate = self
            self.present(imagePickerController, animated: true, completion: nil)
        }
    }
    
    
    
    //MARK: - Delete Dog
    @objc func deleteDog() {
        
        context.delete(dog!)
        
        do{
            try context.save()
            self.navigationController?.popViewController(animated: true)
        }
        catch{
            print("\(error)")
        }
    }
    
    //MARK: - Actions
    
    @IBAction func buttonAddPhotoAction(_ sender: Any) {
        importPicture()
    }
    
    
    @IBAction func buttonAddDogAction(_ sender: Any) {
        saveData()
    }
}


//MARK: - Picker Extension

extension AddDogsViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        let image = info[.originalImage] as? UIImage
        imageViewDogImageOutlet.image = image
        picker.dismiss(animated: true, completion: nil)
    }
}
