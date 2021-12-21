//
//  DogsViewController.swift
//  My Dogs
//
//  Created by Menaim on 20/12/2021.
//

import UIKit
import CoreData

class DogsViewController: UIViewController {

    //MARK: - Outlets
    @IBOutlet weak var dogsCollectionView: UICollectionView!
    
    //MARK: - Vars
    var dogs: [Dog] = []
    
    //MARK: - CoreData Vars
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    lazy var context = NSManagedObjectContext.init(concurrencyType: .mainQueueConcurrencyType)
    
    //MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "Dogs" // setting the title
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add , target: self, action: #selector(addDog)) // adding the + button
        context = appDelegate.persistentContainer.viewContext // setting my coreData Container
        
//        dogsCollectionView.delegate = self
//        dogsCollectionView.dataSource = self
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        fetchData()
    }

    
    
    
    
    
    //MARK: - Add Dog
   @objc func addDog() {
        
       let storyboard = UIStoryboard(name: "Main",bundle: nil)
       
       let addDogsViewController = storyboard.instantiateViewController(withIdentifier: String(describing: AddDogsViewController.self)) as? AddDogsViewController
       self.navigationController?.pushViewController(addDogsViewController!, animated: true)
    }
    
    
    
    
    
    

    // MARK: - Fetching Data
    func fetchData(){
        let fetchRequest = NSFetchRequest<Dog>(entityName: "Dog")
        
        do {
            dogs = try context.fetch(fetchRequest)
            
            DispatchQueue.main.async {
                self.dogsCollectionView.reloadData()
            }
        }
        catch {
            print(error)
        }
    }

   

}

//MARK: - CollectionView Datasource
extension DogsViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return dogs.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = dogsCollectionView.dequeueReusableCell(withReuseIdentifier: String(describing: DogCell.self), for: indexPath) as? DogCell else {return UICollectionViewCell()}
        
        cell.lblDogName.text = dogs[indexPath.item].dogName
        
        if let imageData = dogs[indexPath.item].dogImage {
            cell.imageViewDogImage.image = UIImage(data: imageData)
        }
        
        return cell
        
        
    }
    
    
    
}

//MARK: - CollectionView Delegate
extension DogsViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let storyboard = UIStoryboard(name: "Main",bundle: nil)
        
        let addDogsViewController = storyboard.instantiateViewController(withIdentifier: "AddDogsViewController") as? AddDogsViewController
        addDogsViewController?.dog = dogs[indexPath.row]
        self.navigationController?.pushViewController(addDogsViewController!, animated: true)
    }
    
}
