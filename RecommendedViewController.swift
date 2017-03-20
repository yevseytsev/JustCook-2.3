//
//  RecommendedViewController.swift
//  Just Cook
//
//  Created by Andriy Yevseytsev on 2016-Nov-12.
//  Copyright © 2017 Andriy Yevseytsev. All rights reserved.
//

import UIKit
import CoreData

class RecommendedViewController: UIViewController, UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource, UINavigationControllerDelegate {
    
    @IBOutlet weak var name: UITextField!
    @IBOutlet weak var picker_types: UIPickerView!
    @IBOutlet weak var nextButton: UIButton!
    
    fileprivate var baverage: String = ""
    var recipe: Recipe!
    
    fileprivate let types = [NSLocalizedString("No Recommended Beverage", comment: "-"), NSLocalizedString("Water", comment: "-"), NSLocalizedString("Soda", comment: "-"), NSLocalizedString("Tonic Water", comment: "-"), NSLocalizedString("Soft Drink", comment: "-"), NSLocalizedString("Juice", comment: "-"), NSLocalizedString("Nectar", comment: "-"), NSLocalizedString("Milk", comment: "-"), NSLocalizedString("Coffee", comment: "-"), NSLocalizedString("Tea", comment: "-"), NSLocalizedString("Cider", comment: "-"), NSLocalizedString("Wine", comment: "-"), NSLocalizedString("Brandy", comment: "-"), NSLocalizedString("Beer", comment: "-"), NSLocalizedString("Whisky", comment: "-"), NSLocalizedString("Other", comment: "-")]
    fileprivate var type: String = NSLocalizedString("No Recommended Beverage", comment: "-")
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        name.delegate = self
        picker_types.delegate = self
        picker_types.dataSource = self
        
        nextButton.layer.shadowOffset = CGSize(width: 0, height: 0)
        nextButton.layer.shadowColor = UIColor.white.cgColor
        nextButton.layer.shadowRadius = 9.0
        nextButton.layer.shadowOpacity = 1
        nextButton.layer.masksToBounds = false

        navigationItem.leftBarButtonItem?.tintColor = UIColor.white
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
        return types.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String?{
        return types[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int){
        name.resignFirstResponder()
        type = types[row]
        
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        baverage = name.text!
        return true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        name.resignFirstResponder()
        baverage = name.text!
    }

    override func viewWillAppear(_ animated: Bool) {
        prepareFileds()
    }
    
    func prepareFileds() {
        name.text = recipe.recommended ?? ""
        let recomdIndex = types.index(of: recipe.recommended_type ?? "") ?? -1
        if recomdIndex != -1 {
            picker_types.selectRow(recomdIndex, inComponent: 0, animated: false)
        }
        else {
            picker_types.selectRow(0, inComponent: 0, animated: false)
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        baverage = name.text!
        
        recipe.setValue(baverage, forKey: "recommended")
        recipe.setValue(type, forKey: "recommended_type")
        let nextVC = segue.destination as! photosViewController
        nextVC.recipe = recipe
    }
}
