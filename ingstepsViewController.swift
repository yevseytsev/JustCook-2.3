//
//  ingstepsViewController.swift
//  Just Cook
//
//  Created by Andriy Yevseytsev on 2016-Oct-29.
//  Copyright © 2017 Andriy Yevseytsev. All rights reserved.
//

import UIKit
import CoreData

class ingstepsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UINavigationControllerDelegate {
    
    var recipe: Recipe!
    let coreDataManeger = CoreDataManeger.sharedManager
    
    @IBOutlet weak var directions: UITableView!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var addIng: UIButton!
    @IBOutlet weak var addDir: UIButton!
    
    var fetchedResultsController: NSFetchedResultsController<Recipe>!
    
    override func viewDidLoad() {
        
        ingredients_list.removeAll()
        quantity.removeAll()
        directions_list.removeAll()
        
        super.viewDidLoad()
        ingredients.delegate = self
        ingredients.dataSource = self
        directions.delegate = self
        directions.dataSource = self
        ingredients.estimatedRowHeight = 140
        directions.estimatedRowHeight = 140
        self.navigationItem.rightBarButtonItem = self.editButtonItem
        
        nextButton.layer.shadowOffset = CGSize(width: 0, height: 0)
        nextButton.layer.shadowColor = UIColor.white.cgColor
        nextButton.layer.shadowRadius = 5.0
        nextButton.layer.shadowOpacity = 1.0
        nextButton.layer.masksToBounds = false
        
        addIng.layer.shadowOffset = CGSize(width: 0, height: 0)
        addIng.layer.shadowColor = UIColor.white.cgColor
        addIng.layer.shadowRadius = 10.0
        addIng.layer.shadowOpacity = 1.0
        addIng.layer.masksToBounds = false
        
        addDir.layer.shadowOffset = CGSize(width: 0, height: 0)
        addDir.layer.shadowColor = UIColor.white.cgColor
        addDir.layer.shadowRadius = 10.0
        addDir.layer.shadowOpacity = 1.0
        addDir.layer.masksToBounds = false
        
        navigationItem.rightBarButtonItem?.tintColor = UIColor.black
        navigationItem.leftBarButtonItem?.tintColor = UIColor.black
    }

    @IBAction func add_direction(_ sender: Any) {
        let alert = UIAlertController(title: NSLocalizedString("Add Direction", comment: "-"), message: "", preferredStyle: .alert)
        alert.addTextField { (TextField) in TextField.placeholder = NSLocalizedString("Name of direction", comment: "-")}
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (_) in
            if (alert.textFields![0].text?.characters.count)! > 0 {
                self.directions_list.append(alert.textFields![0].text!)
                self.directions.reloadData()
                let indexPath = IndexPath(row: self.directions_list.count - 1, section: 0)
                self.directions.scrollToRow(at: indexPath, at: .bottom, animated: true)
            }
            
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        present(alert, animated: true, completion: nil)

    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            if(tableView == ingredients){
              ingredients_list.remove(at: indexPath.row)
              quantity.remove(at: indexPath.row)
            }
            if(tableView == directions){
              directions_list.remove(at: indexPath.row)
            }
        tableView.reloadData()
        }
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    @IBOutlet weak var ingredients: UITableView!

    @IBAction func ing(_ sender: Any) {
      let alert = UIAlertController(title: NSLocalizedString("Add Ingredient", comment: "-"), message: "", preferredStyle: .alert)
      alert.addTextField { (TextField) in TextField.placeholder = NSLocalizedString("Name of ingredient", comment: "-")}
      alert.addTextField { (TextField) in TextField.placeholder = NSLocalizedString("Quantity", comment: "-")}
      alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (_) in
        if (alert.textFields![0].text?.characters.count)! > 0 {
            self.ingredients_list.append(alert.textFields![0].text!)
            self.quantity.append(alert.textFields![1].text ?? "")
            self.ingredients.reloadData()
            let indexPath = IndexPath(row: self.ingredients_list.count - 1, section: 0)
            self.ingredients.scrollToRow(at: indexPath, at: .bottom, animated: true)
        }
        
        }))
      alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
      present(alert, animated: true, completion: nil)
    }
    
    fileprivate var name: String?
    fileprivate var ingredients_list = [String]()
    fileprivate var quantity = [String]()
    
    fileprivate var directions_list = [String]()
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if tableView == ingredients {
            return ingredients_list.count
        }
        else {
         return directions_list.count
        }
    }
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        ingredients.setEditing(editing, animated: animated)
        directions.setEditing(editing, animated: animated)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func initializeFetchedResultsController() {
        let request = NSFetchRequest<Recipe>(entityName: "Recipe")
        
        request.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
        
        let moc = coreDataManeger.managedObjectContext
        
        fetchedResultsController = NSFetchedResultsController(fetchRequest: request, managedObjectContext: moc, sectionNameKeyPath: nil, cacheName: nil)
        
        do {
            try fetchedResultsController.performFetch()
        } catch {
            fatalError("Failed to initialize FetchedResultsController: \(error)")
        }
        
    }
    
    
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        if(tableView == ingredients){
            let tmp = ingredients_list[sourceIndexPath.row]
            ingredients_list.remove(at: sourceIndexPath.row)
            ingredients_list.insert(tmp, at: destinationIndexPath.row)
            let tmp_qnt = quantity[sourceIndexPath.row]
            quantity.remove(at: sourceIndexPath.row)
            quantity.insert(tmp_qnt, at: destinationIndexPath.row)
            ingredients.reloadData()
        }
        if(tableView == directions){
            let tmp = directions_list[sourceIndexPath.row]
            directions_list.remove(at: sourceIndexPath.row)
            directions_list.insert(tmp, at: destinationIndexPath.row)
            directions.reloadData()

        }

    }
    
    // Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
    // Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)
    
    @available(iOS 2.0, *)
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        if tableView == directions {
            let cell = tableView.dequeueReusableCell(withIdentifier: "direction", for: indexPath) as! dirTableViewCell
            cell.direction_name.text = directions_list[indexPath.row]
            return cell
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ingredients", for: indexPath) as! ingTableViewCell
        cell.name.text = ingredients_list[indexPath.row]
        cell.qty.text = quantity[indexPath.row]
        cell.name.numberOfLines = 0
        cell.qty.numberOfLines = 0
        return cell
    }

    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        var result = false
        
            if ingredients_list.count == 0{
                prompt(error: NSLocalizedString("Please, add an ingredient", comment: "-"))
                result = false
            }
            else
            {
                coreDataManeger.deleteStep(from: recipe)
                coreDataManeger.deleteIngs(from: recipe)
                
                for i in 0..<ingredients_list.count {
                   let ingredient: Ingredient = coreDataManeger.create(entity: "Ingredient") as! Ingredient
                   ingredient.setValuesForKeys(["Ingredient":ingredients_list[i], "index": i, "quantity": quantity[i]])
                    recipe.addToIngredients(ingredient)
                }
                
                for i in 0..<directions_list.count {
                    let direction: Step = coreDataManeger.create(entity: "Step") as! Step
                    direction.setValuesForKeys(["step":directions_list[i], "index": i])
                    recipe.addToSteps(direction)
                }

                
                result = true
            }
        return result
    }

    override func viewWillAppear(_ animated: Bool) {
        prepareFields()
    }
    
    func prepareFields() {
        let sorter = NSSortDescriptor(key: "index", ascending: true)
        if recipe.ingredients != nil && (recipe.ingredients?.count)! > 0  {
            ingredients_list.removeAll()
            quantity.removeAll()
            for ing in recipe.ingredients!.sortedArray(using: [sorter]) as! [Ingredient] {
                ingredients_list.append(ing.ingredient ?? "")
                quantity.append(ing.quantity ?? "")
            }
        }
        
        if recipe.steps != nil && (recipe.steps?.count)! > 0 {
            directions_list.removeAll()
            for st in recipe.steps?.sortedArray(using: [sorter]) as! [Step] {
                directions_list.append(st.step ?? "")
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let nextVC = segue.destination as! RecommendedViewController
            nextVC.recipe = recipe
    }


}
