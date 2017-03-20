//
//  adressViewController.swift
//  Just Cook
//
//  Created by Excellence on 11/25/16.
//  Copyright © 2017 Andriy Yevseytsev. All rights reserved.
//
import UIKit
import MessageUI

class adressViewController: UIViewController, UITextFieldDelegate {
    
    var order: Order!
    
    @IBOutlet weak var name: UITextField!
    @IBOutlet weak var adress1: UITextField!
    @IBOutlet weak var adress2: UITextField!
    @IBOutlet weak var zip: UITextField!
    @IBOutlet weak var city: UITextField!
    @IBOutlet weak var Province: UITextField!
    @IBOutlet weak var country: UITextField!
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var phone: UITextField!
    @IBOutlet weak var placeOrder: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //mailViewController.mailComposeDelegate = self
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    
    func checkFields() -> Bool {
        if name.text == nil || name.text!.characters.count == 0 {
            prompt(error: NSLocalizedString("Name is required for shipping!", comment: "-"))
            return false
        }
            
        else if adress1.text == nil || adress1.text!.characters.count == 0 {
            prompt(error: NSLocalizedString("Address is required for shipping!", comment: "-"))
            return false
        }
            
        else if city.text == nil || city.text!.characters.count == 0{
            prompt(error: NSLocalizedString("City is required for shipping!", comment: "-"))
            return false
        }
            
        else if zip.text == nil || zip.text!.characters.count == 0 {
            prompt(error: NSLocalizedString("ZIP code is required for shipping!", comment: "-"))
            return false
        }
            
        else if country.text == nil || country.text!.characters.count == 0 {
            prompt(error: NSLocalizedString("Country is required for shipping!", comment: "-"))
            return false
        }
        return true
    }
    
    
    @IBAction func placeOrderShip(_ sender: Any) {
        guard checkFields() else {
            return
        }
        let address = Address()
        address.name = name.text!
        address.address1 = adress1.text!
        address.address2 = adress2.text
        address.zipCode = zip.text!
        address.city = city.text!
        address.state = Province.text
        address.country = country.text!
        address.email = email.text
        address.phone = phone.text
        order.address = address
        order.uploadOrder()
        successToSent()
    }
    
    func successToSent() {
        let alertController = UIAlertController(title: NSLocalizedString("Success!", comment: "-"), message: NSLocalizedString("Your order is processing, you will get payment email in 24 hours", comment: "-"), preferredStyle: .alert)
        let confirmAction = UIAlertAction(title: "OK", style: .default) {
            (UIAlertAction) -> () in
            let mainVC = self.storyboard?.instantiateViewController(withIdentifier: "ViewController")
            self.navigationController?.pushViewController(mainVC!, animated: true)
        }
        alertController.addAction(confirmAction)
        present(alertController, animated: true, completion: nil)
    }

    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        name.resignFirstResponder()
        adress1.resignFirstResponder()
        adress2.resignFirstResponder()
        zip.resignFirstResponder()
        city.resignFirstResponder()
        Province.resignFirstResponder()
        country.resignFirstResponder()
        phone.resignFirstResponder()
        email.resignFirstResponder()
    }
    
}
