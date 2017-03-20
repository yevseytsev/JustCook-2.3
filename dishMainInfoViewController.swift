//
//  dishMainInfoViewController.swift
//  Just Cook
//
//  Created by Andriy Yevseytsev on 2016-Oct-24.
//  Copyright © 2017 Andriy Yevseytsev. All rights reserved.
//

import UIKit

class dishMainInfoViewController: UIViewController, UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource{

    @IBOutlet weak var typePicker: UIPickerView!
    @IBOutlet weak var dishName: UITextField!
    @IBOutlet weak var difficulty: UISegmentedControl!
    @IBOutlet weak var timePicker: UIPickerView!
    @IBOutlet weak var servingsPicker: UIPickerView!
    @IBOutlet weak var nextButton: UIButton!
    
    let coreDataManeger = CoreDataManeger.sharedManager
    var recipe: Recipe!
    fileprivate let types = [NSLocalizedString("Breakfast", comment: "-"), NSLocalizedString("Appetizers & Snacks", comment: "-"), NSLocalizedString("Fruits & Vegetables", comment: "-"), "", NSLocalizedString("Meat & Poultry", comment: "-"), NSLocalizedString("BBQ & Grilling", comment: "-"), NSLocalizedString("Seafood & Sushi", comment: "-"), "", NSLocalizedString("Salads & Dressings", comment: "-"), NSLocalizedString("Side Dishes & Grains", comment: "-"), NSLocalizedString("Soups & Stews", comment: "-"), NSLocalizedString("Pasta & Pizza", comment: "-"), NSLocalizedString("Sandwiches & Burgers", comment: "-"), NSLocalizedString("Bread & Bakery", comment: "-"), NSLocalizedString("Sauces & Gravy", comment: "-"), "", NSLocalizedString("Beverages & Cocktails", comment: "-"), "", NSLocalizedString("Pies & Cakes", comment: "-"), NSLocalizedString("Cookies & Candies", comment: "-"), NSLocalizedString("Desserts", comment: "-")]
    
    fileprivate let times = [NSLocalizedString("5 mins", comment: "-"), NSLocalizedString("10 mins", comment: "-"), NSLocalizedString("15 mins", comment: "-"), NSLocalizedString("30 mins", comment: "-"), NSLocalizedString("45 mins", comment: "-"), NSLocalizedString("1 hour", comment: "-"), NSLocalizedString("1 h 15 mins", comment: "-"), NSLocalizedString("1 h 30 mins", comment: "-"), NSLocalizedString("1 h 45 mins", comment: "-"), NSLocalizedString("2 hours", comment: "-"), NSLocalizedString("2 h 30 mins", comment: "-"), NSLocalizedString("3 hours", comment: "-"), NSLocalizedString("3 h 30 mins", comment: "-"), NSLocalizedString("4 hours", comment: "-"), NSLocalizedString("5 hours", comment: "-"), NSLocalizedString("6 hours", comment: "-"), NSLocalizedString("8 hours", comment: "-"), NSLocalizedString("12 hours", comment: "-"), NSLocalizedString("16 hours", comment: "-"), NSLocalizedString("24 hours", comment: "-"), NSLocalizedString("48 hours", comment: "-"), NSLocalizedString("72 hours", comment: "-")]
    
    fileprivate let servings = [NSLocalizedString("1 serving", comment: "-"), NSLocalizedString("2 servings", comment: "-"), NSLocalizedString("3 servings", comment: "-"), NSLocalizedString("4 servings", comment: "-"), NSLocalizedString("6 servings", comment: "-"), NSLocalizedString("9 servings", comment: "-"), NSLocalizedString("12 servings", comment: "-"), NSLocalizedString("16 servings", comment: "-"), NSLocalizedString("24 servings", comment: "-"), NSLocalizedString("36 servings", comment: "-")]
    
    fileprivate var type: String = NSLocalizedString("Breakfast", comment: "-")
    fileprivate var time: String = NSLocalizedString("5 mins", comment: "-")
    fileprivate var serving: String = NSLocalizedString("1 serving", comment: "-")
    fileprivate var diff: Int = 1
    fileprivate var name: String = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        UINavigationBar.appearance().backgroundColor = nil
        
        dishName.delegate = self
        typePicker.delegate = self
        typePicker.dataSource = self
        timePicker.delegate = self
        timePicker.dataSource = self
        servingsPicker.delegate = self
        servingsPicker.dataSource = self
        
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(named: "transparent.png"), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage(named: "transparent.png")
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.view.backgroundColor = UIColor.clear
        
        nextButton.layer.shadowOffset = CGSize(width: 0, height: 0)
        nextButton.layer.shadowColor = UIColor.white.cgColor
        nextButton.layer.shadowRadius = 5.0
        nextButton.layer.shadowOpacity = 1.0
        nextButton.layer.masksToBounds = false
    }
    
    
    @IBAction func difficulty_sel(_ sender: AnyObject) {
        diff = difficulty.selectedSegmentIndex + 1;
    }
    
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        var result = false
        
            if dishName.text?.characters.count == 0{
                prompt(error: NSLocalizedString("Please Enter the Dish Name", comment: "-"))
                result = false
            }
            else
            {
                name = dishName.text!
                let data = ["name": name as AnyObject,
                            "type": type as AnyObject,
                            "time": time as AnyObject,
                            "serving": serving as AnyObject,
                            "difficulty": diff as AnyObject,
                            "id": Date().timeIntervalSince1970 as AnyObject
                            ]
                
                coreDataManeger.update(recipe: recipe, data: data)
                result = true
            }
        return result
    }
    
    @available(iOS 2.0, *)
    public func numberOfComponents(in pickerView: UIPickerView) -> Int
    {
        return 1
    }
    
    
    // returns the # of rows in each component..
    @available(iOS 2.0, *)
    public func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int
    {
        if pickerView.tag == 1 {
            return types.count
        }
        if pickerView.tag == 2 {
            return times.count
        }
        if pickerView.tag == 3 {
            return servings.count
        }
        return 0
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String?{
        
        if pickerView.tag == 1 {
            return types[row]
        }
        if pickerView.tag == 2 {
            return times[row]
        }
        if pickerView.tag == 3 {
            return servings[row]
        }
        return ""
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int){
        dishName.resignFirstResponder()
        if pickerView.tag == 1 {
            type = types[row]
        }
        if pickerView.tag == 2 {
            time = times[row]
        }
        if pickerView.tag == 3 {
            serving = servings[row]
        }
    }

    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        name = dishName.text!
        return true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        dishName.resignFirstResponder()
        name = dishName.text!
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        if self.isMovingFromParentViewController, recipe.isFinished == false {
            coreDataManeger.delete(recipe: recipe)
        }
    }
    

    @IBAction func cancelAdding(_ sender: AnyObject) {
        if recipe.isFinished == false {
            coreDataManeger.delete(recipe: recipe)
        }

        let rootViewController = self.storyboard?.instantiateViewController(withIdentifier: "ViewController")
        present(rootViewController!, animated: true, completion: nil)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        prepareFields()
    }
    
    func prepareFields() {
        dishName.text = recipe.name ?? ""
        let typeIndex = types.index(of: recipe.type ?? "NULL") ?? -1
        if typeIndex != -1 {
            typePicker.selectRow(typeIndex, inComponent: 0, animated: false)
        }
        else {
            typePicker.selectRow(0, inComponent: 0, animated: false)
        }
        
        let timeIndex = times.index(of: recipe.time ?? "NULL") ?? -1
        if timeIndex != -1 {
            timePicker.selectRow(timeIndex, inComponent: 0, animated: false)
        }
        else {
            timePicker.selectRow(0, inComponent: 0, animated: false)
        }
        
        let servingIndex = servings.index(of: recipe.serving ?? "NULL") ?? -1
        if servingIndex != -1 {
            servingsPicker.selectRow(servingIndex, inComponent: 0, animated: false)
        }
        else {
            servingsPicker.selectRow(0, inComponent: 0, animated: false)
        }
        
        if let dif = recipe.difficulty?.intValue, recipe.difficulty?.intValue != 0  {
            difficulty.selectedSegmentIndex = dif - 1
        }
        else {
            difficulty.selectedSegmentIndex = 0
        }
    }
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        recipe.name = dishName.text
        recipe.type = types[typePicker.selectedRow(inComponent: 0)]
        recipe.time = times[timePicker.selectedRow(inComponent: 0)]
        recipe.serving = servings[servingsPicker.selectedRow(inComponent: 0)]
        recipe.difficulty = NSNumber(value: difficulty.selectedSegmentIndex + 1)
        
        let nextVC = segue.destination as! ingstepsViewController
        nextVC.recipe = recipe
        
    }
}
