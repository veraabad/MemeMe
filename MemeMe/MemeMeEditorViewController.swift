//
//  MemeMeEditorViewController.swift
//  MemeMe
//
//  Created by Abad Vera on 11/12/18.
//  Copyright © 2018 Abad Vera. All rights reserved.
//

import UIKit

class MemeMeEditorViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {

    @IBOutlet weak var topTextField: UITextField!
    @IBOutlet weak var bottomTextField: UITextField!
    @IBOutlet weak var memeImageView: UIImageView!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var sharingButton: UIBarButtonItem!

    let memeTextAttributes:[NSAttributedString.Key: Any] = [
        NSAttributedString.Key.strokeColor: UIColor.black,
        NSAttributedString.Key.foregroundColor: UIColor.white,
        NSAttributedString.Key.font: UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
        NSAttributedString.Key.strokeWidth: -4.0
    ]
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        initialSetup()
    }

    func initialSetup() {
        cameraButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
        setupTextField(topTextField, withString: "TOP")
        setupTextField(bottomTextField, withString: "BOTTOM")
    }

    func setupTextField(_ textField: UITextField, withString str: String) {
        textField.defaultTextAttributes = memeTextAttributes
        textField.textAlignment = .center
        textField.delegate = self
        textField.text = str
    }

    @IBAction func cameraAction(_ sender: Any) {
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        pickerController.sourceType = .camera
        present(pickerController, animated: true, completion: nil)
    }

    @IBAction func albumAction(_ sender: Any) {
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        pickerController.sourceType = .photoLibrary
        present(pickerController, animated: true, completion: nil)
    }

    @IBAction func sharingAction(_ sender: Any) {
    }

    @IBAction func cancelAction(_ sender: Any) {
    }

    // MARK: UITextFieldDelegate methods
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField.text == "TOP" || textField.text == "BOTTOM" {
            textField.text = ""
        }
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()

        return true
    }

    // MARK: UIImagePickerControllerDelegate methods
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let img = info[.originalImage] as? UIImage {
            print("AV :: mediaType selected")
            memeImageView.image = img
        }
        picker.dismiss(animated: true, completion: nil)
    }
}

