//
//  DetailViewController.swift
//  Homepwner
//
//  Created by cm on 16/2/16.
//  Copyright © 2016年 cm. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController,UITextFieldDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate {
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var serialNumberField: UITextField!
    @IBOutlet weak var valueField: UITextField!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    
    var item:Item! {
        didSet{
            navigationItem.title = item.name
        }
    }
    
    var imageStroe:ImageStore!
    
    let numberFormatter:NSNumberFormatter = {
        let formatter = NSNumberFormatter()
        formatter.numberStyle = .DecimalStyle
        formatter.minimumFractionDigits = 2
        formatter.maximumFractionDigits = 2
        return formatter
    }()
    
    let dateFormatter:NSDateFormatter = {
       let formatter = NSDateFormatter()
        formatter.dateStyle  = .MediumStyle
        formatter.timeStyle = .NoStyle
        return formatter
    }()
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        nameField.text = item.name
        serialNumberField.text = item.serialNumber
        valueField.text = numberFormatter.stringFromNumber(item.valueInDollars)
        dateLabel.text = dateFormatter.stringFromDate(item.dateCreated)
        
        let key = item.imageKey
        let imageToDisplay = imageStroe.imageForKey(key)
        imageView.image = imageToDisplay
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        view.endEditing(true)
        
        item.name = nameField.text!
        item.serialNumber = serialNumberField.text
        
        if let valueText = valueField.text, value = numberFormatter.numberFromString(valueText) {
            item.valueInDollars = value.integerValue
        } else {
            item.valueInDollars = 0
        }
    }
    
    @IBAction func endEdit(sender: AnyObject) {
        view.endEditing(true)
    }
    
    @IBAction func takePicture(sender: AnyObject) {
        let imagePickController = UIImagePickerController()
        if UIImagePickerController.isSourceTypeAvailable(.Camera) {
            imagePickController.sourceType = .Camera
        } else {
            imagePickController.sourceType = .PhotoLibrary
        }
        
        imagePickController.delegate = self
        presentViewController(imagePickController, animated: true, completion: nil)
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        let image = info[UIImagePickerControllerOriginalImage] as! UIImage
        imageView.image = image
        imageStroe.setImage(image, forKey: item.imageKey)
        dismissViewControllerAnimated(true, completion: nil)
    }

    
}
