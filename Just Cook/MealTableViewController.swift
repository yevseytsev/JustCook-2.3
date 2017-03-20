//
//  MealTableViewController.swift
//  Just Cook
//
//  Created by Andriy Yevseytsev on 2016-авг.-3.
//  Copyright © 2017 Andriy Yevseytsev. All rights reserved.
//
import UIKit
import CoreData

class MealTableViewController: UITableViewController, Transportable {
    
    let coreDataManeger = CoreDataManeger.sharedManager
    var fetchedResultsController: NSFetchedResultsController<Recipe>!
    var meal: Meal!
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let recipe: Recipe = fetchedResultsController.object(at: indexPath)
            
            meal = Meal(recipeEntity: recipe)
            deleteRecipe(feedback: { (err) in
                print(err)
            })
            
            //coreDataManeger.delete_recipe(by: (recipe.id?.doubleValue)!)
            coreDataManeger.delete(recipe: recipe)
            initializeFetchedResultsController()
            tableView.reloadData()
        }
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.titleTextAttributes = [ NSFontAttributeName: UIFont(name: "HelveticaNeue-UltraLight", size: 28)!,  NSForegroundColorAttributeName: UIColor(red: 0, green: 0, blue: 0, alpha: 1)]
        
        let backgroundImage = UIImage(named: "fon_eda.jpg")
        let imageView = UIImageView(image: backgroundImage)
        self.tableView.backgroundView = imageView
        imageView.contentMode = .scaleAspectFill
        
        tableView.backgroundColor = UIColor.clear
    }
    

    override func viewWillDisappear(_ animated: Bool) {
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        initializeFetchedResultsController()
        tableView.reloadData()
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = false
    }
    
    func initializeFetchedResultsController() {
        let request = NSFetchRequest<Recipe>(entityName: "Recipe")
        
        request.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
        request.predicate = NSPredicate(format: "isTemp = false")
        
        let moc = coreDataManeger.managedObjectContext
        
        fetchedResultsController = NSFetchedResultsController(fetchRequest: request, managedObjectContext: moc, sectionNameKeyPath: nil, cacheName: nil)
        
        do {
            try fetchedResultsController.performFetch()
        } catch {
            fatalError("Failed to initialize FetchedResultsController: \(error)")
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

    }
    
    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let sections = fetchedResultsController.sections else {
            fatalError("No sections in fetchedResultsController")
        }
        
        let sectionInfo = sections[section]
        
        return sectionInfo.numberOfObjects
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.backgroundColor = UIColor(red: 240/255, green: 227/255, blue: 212/255, alpha: 1) //UIColor(white: 1, alpha: 0.4)
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "MealTableViewCell"
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! MealTableViewCell
        
        let recipe: Recipe = fetchedResultsController.object(at: indexPath)
        
        cell.setInternalField(recipe: recipe)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let recipe: Recipe = fetchedResultsController.object(at: indexPath)
        
        let detailedView = storyboard?.instantiateViewController(withIdentifier: "DetailedView") as! DetailedTableViewController
        
        
        detailedView.recipe = recipe
        self.navigationController?.pushViewController(detailedView, animated: true)
    }
}
