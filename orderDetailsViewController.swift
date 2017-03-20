//
//  orderDetailsViewController.swift
//  Just Cook
//
//  Created by Excellence on 11/24/16.
//  Copyright © 2017 Andriy Yevseytsev. All rights reserved.
//
import UIKit
import MessageUI

class orderDetailsViewController: UIViewController, UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource{
    
    @IBOutlet weak var author: UITextField!
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var color: UIPickerView!
    @IBOutlet weak var ship: UIButton!
    fileprivate let colors = [NSLocalizedString("Standard (Prep Cook Only)", comment: "-"), " ",NSLocalizedString("Pearl (Sous-Chef Only)", comment: "-"), NSLocalizedString("Gold (Sous-Chef Only)", comment: "-"), NSLocalizedString("Red Wine (Sous-Chef Only)", comment: "-"), NSLocalizedString("Sky Blue (Sous-Chef Only)", comment: "-"), NSLocalizedString("Olive Green (Sous-Chef Only)", comment: "-"), NSLocalizedString("Light Grey (Sous-Chef Only)", comment: "-")," ", NSLocalizedString("White (Executive Chef Only)", comment: "-"), NSLocalizedString("Red (Executive Chef Only)", comment: "-"), NSLocalizedString("Royal Blue (Executive Chef Only)", comment: "-"), NSLocalizedString("Brown (Executive Chef Only)", comment: "-"), NSLocalizedString("Midnight (Executive Chef Only)", comment: "-"), NSLocalizedString("Black (Executive Chef Only)", comment: "-")]
    let manager = CoreDataManeger.sharedManager
    
    var order: Order!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    
    func detectType(of data: Data) -> String {
        var c: UInt8 = 0
        data.copyBytes(to: &c, count: 1)
        switch c {
        case 0xFF:
            return "jpeg"
        case 0x89:
            return "png"
        default:
            break;
        }
        return ""
    }
    
    func checkEmail() -> Bool {
        if author.text == nil || author.text!.characters.count == 0  {
            prompt(error: NSLocalizedString("Provide the Author Name!", comment: "-"))
            return false
        }
        
        if email.text == nil || email.text!.characters.count == 0  {
            prompt(error: NSLocalizedString("Provide the E-Mail for payment!", comment: "-"))
            return false
        }
        
        return true
    }
    
    /*func successToSent() {
        let alertController = UIAlertController(title: NSLocalizedString("Success!", comment: "-"), message: NSLocalizedString("Your order is processing, you will get payment email in 24 hours", comment: "-"), preferredStyle: .alert)
        let confirmAction = UIAlertAction(title: "OK", style: .default) {
            (UIAlertAction) -> () in
            let mainVC = self.storyboard?.instantiateViewController(withIdentifier: "ViewController")
            self.navigationController?.pushViewController(mainVC!, animated: true)
        }
        alertController.addAction(confirmAction)
        present(alertController, animated: true, completion: nil)
    }
    
    func cancelOrder() {
        let alertController = UIAlertController(title: NSLocalizedString("Order canceled", comment: "-"), message: NSLocalizedString("You can order your CookBook at any time", comment: "-"), preferredStyle: .alert)
        let confirmAction = UIAlertAction(title: "OK", style: .default) {
            (UIAlertAction) -> () in
            let mainVC = self.storyboard?.instantiateViewController(withIdentifier: "ViewController")
            self.navigationController?.pushViewController(mainVC!, animated: true)
        }
        alertController.addAction(confirmAction)
        present(alertController, animated: true, completion: nil)
    }*/
    
    @available(iOS 2.0, *)
    public func numberOfComponents(in pickerView: UIPickerView) -> Int
    {
        return 1
    }
    
    
    // returns the # of rows in each component..
    @available(iOS 2.0, *)
    public func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int
    {
        return colors.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String?{
        
        return colors[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int){
        author.resignFirstResponder()
        email.resignFirstResponder()
        if pickerView.tag == 1 {
            
            order.color = colors[row]
        }
        
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        author.resignFirstResponder()
        email.resignFirstResponder()
        if textField == author {
            order.author = textField.text
        } else if textField == email {
            order.email = textField.text
        }
        return true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        author.resignFirstResponder()
        email.resignFirstResponder()
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        return checkEmail()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        order.color = colors[color.selectedRow(inComponent: 0)]
        order.author = author.text ?? ""
        order.email = email.text
        
        let nextVC = segue.destination as! adressViewController
        nextVC.order = order
    }
}
