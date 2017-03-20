//
//  DetailedTableViewController.swift
//  Just Cook
//
//  Created by Excellence on 11/21/16.
//  Copyright © 2017 Andriy Yevseytsev. All rights reserved.
//

import UIKit

class DetailedTableViewController: UITableViewController {

    var recipe: Recipe!
    let coreDataManeger = CoreDataManeger.sharedManager
    var meal : Meal!
    let height = UIScreen.main.bounds.width
    
    var downloadable : Bool? = false

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.estimatedRowHeight = height
        
        if meal == nil {
            meal = Meal(recipeEntity: recipe)
        }
        
        let backgroundImage = UIImage(named: "fon_eda.jpg")
        let imageView = UIImageView(image: backgroundImage)
        self.tableView.backgroundView = imageView
        imageView.contentMode = .scaleAspectFill
        imageView.alpha = 0.75
        
        if downloadable != nil && downloadable == true {
            self.navigationItem.rightBarButtonItem =  UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(SaveToCoreDarta))
        }
        else {
            self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(editRecipe))
        }
    }
    
    func editRecipe() {
        let nextVC = storyboard?.instantiateViewController(withIdentifier: "dishMainInfoViewController") as! dishMainInfoViewController
    
        nextVC.recipe = recipe
        
        navigationController?.pushViewController(nextVC, animated: true)
    }

    
    func SaveToCoreDarta() {
        if recipe.isTemp {
            recipe.isTemp = false
            coreDataManeger.saveContext()
        }
        promptComfirmation(msg: NSLocalizedString("Recipe saved!", comment: "-"))
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 4, meal.main_photo != nil {
            return CGFloat(height)
        }
        else if indexPath.section == 8, meal.photos.count > 0 {
            return CGFloat(height)
        }
        else {
            return UITableViewAutomaticDimension
        }
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.backgroundColor = UIColor(white: 1, alpha: 0.0)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 9 
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if section == 5 {
            
            return meal.ingredients.count + 1
        } else if section == 6 {
            return meal.steps.count + 1
        } else if section == 8 {
            print(meal.photos.count)
            return meal.photos.count
        } else {
            return 1
        }
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DetailedCell", for: indexPath) as! DetailedTableViewCell

        cell.dishName.isHidden = false
        cell.ingName.isHidden = true
        cell.ingQty.isHidden = true
        cell.dishName.textAlignment = .center
        
        cell.hideImageView(true)
        
        if indexPath.section == 0 {
            cell.dishName.font = UIFont(name: "Savoye LET", size: 80.0)
            cell.dishName.textColor = UIColor(colorLiteralRed: 0/255, green: 0/255, blue: 0/255, alpha: 1)
            cell.dishName.text = meal.name
        }
        
        if indexPath.section == 1 {
            cell.dishName.font = UIFont(name: "Helvetica Neue", size: 25.0)
            cell.dishName.textColor = UIColor(colorLiteralRed: 130/255, green: 130/255, blue: 130/255, alpha: 1)
            cell.dishName.text = meal.type
        }
        
        if indexPath.section == 2 {
            cell.dishName.font = UIFont(name: "Helvetica Neue", size: 20.0)
            cell.dishName.textColor = UIColor(colorLiteralRed: 130/255, green: 130/255, blue: 130/255, alpha: 1)
            cell.dishName.text = meal.time! + " | " + meal.servings!
        }
        
        if indexPath.section == 3 {
            cell.dishName.font = UIFont(name: "Helvetica Neue", size: 20.0)
            cell.dishName.textColor = UIColor(colorLiteralRed: 150/255, green: 150/255, blue: 150/255, alpha: 1)
            if(meal.difficulcy?.intValue == 1) {
                  cell.dishName.text = NSLocalizedString("Easy", comment: "-")
            } else if(meal.difficulcy?.intValue == 2) {
                cell.dishName.text = NSLocalizedString("Medium", comment: "-")
            } else {
                cell.dishName.text = NSLocalizedString("Hard", comment: "-")
            }
        }
        
        if indexPath.section == 4 {
            if meal.main_photo == nil {
                
                cell.dishName.font = UIFont(name: "Helvetica Neue", size: 20)
                cell.dishName.textColor = UIColor(colorLiteralRed: 220/255, green: 220/255, blue: 220/255, alpha: 1)
                cell.dishName.text = NSLocalizedString(" ", comment: "-")
            } else {
                cell.dishName.isHidden = true
                cell.addPhoto(meal.main_photo!)
                
            }
        }
        
        if indexPath.section == 5 {
            if indexPath.row == 0 {
                cell.dishName.font = UIFont(name: "Savoye LET", size: 55.0)
                cell.dishName.textColor = UIColor(colorLiteralRed: 0/255, green: 0/255, blue: 0/255, alpha: 1)
                cell.dishName.textAlignment = .left
                cell.dishName.text = NSLocalizedString("Ingredients", comment: "-")
                cell.dishName.textAlignment = .center
            } else {
                cell.dishName.font = UIFont(name: "Helvetica Neue", size: 15.0)
                cell.dishName.textColor = UIColor(colorLiteralRed: 0/255, green: 0/255, blue: 0/255, alpha: 1)
                cell.dishName.isHidden = true
                cell.ingQty.isHidden = false
                cell.ingName.isHidden = false
                cell.ingName.text = meal.ingredients[indexPath.row - 1]
                cell.ingQty.text = meal.quntity[indexPath.row - 1]
            }
        }
        
        if indexPath.section == 6 {
            if indexPath.row == 0 {
                cell.dishName.font = UIFont(name: "Savoye LET", size: 55.0)
                cell.dishName.textColor = UIColor(colorLiteralRed: 0/255, green: 0/255, blue: 0/255, alpha: 1)
                cell.dishName.textAlignment = .left
                cell.dishName.text = NSLocalizedString("Directions", comment: "-")
                cell.dishName.textAlignment = .center
            } else {
                cell.dishName.font = UIFont(name: "Helvetica Neue", size: 15.0)
                cell.dishName.textColor = UIColor(colorLiteralRed: 0/255, green: 0/255, blue: 0/255, alpha: 1)
                cell.dishName.textAlignment = .left
                cell.dishName.text = meal.steps[indexPath.row - 1]
            }
        }
        
        if indexPath.section == 7 {
            cell.dishName.isHidden = false
            cell.dishName.font = UIFont(name: "Savoye LET", size: 40.0)
            cell.dishName.textColor = UIColor(colorLiteralRed: 0/255, green: 0/255, blue: 0/255, alpha: 1)
            cell.dishName.text = NSLocalizedString("Best with - ", comment: "-") + (meal.recommended_type ?? "" ) + "\n" + (meal.recommended_name ?? "")
        }
        
        if indexPath.section == 8 {
            if meal.photos.count == 0 {
                cell.dishName.isHidden = false
                cell.dishName.font = UIFont(name: "Arial", size: 20.0)
                cell.dishName.textColor = UIColor(colorLiteralRed: 62/255, green: 127/255, blue: 50/255, alpha: 1)
                cell.dishName.text = NSLocalizedString(" ", comment: "-")
            } else {
                cell.dishName.isHidden = true
                cell.addPhoto(meal.photos[indexPath.row])
            }
        }

        return cell
    }
}
