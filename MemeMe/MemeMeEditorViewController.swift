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
    @IBOutlet weak var navBar: UINavigationBar!
    @IBOutlet weak var toolBar: UIToolbar!
    weak var activeTextField: UITextField!

    let memeTextAttributes:[NSAttributedString.Key: Any] = [
        NSAttributedString.Key.strokeColor: UIColor.black,
        NSAttributedString.Key.foregroundColor: UIColor.white,
        NSAttributedString.Key.font: UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
        NSAttributedString.Key.strokeWidth: -4.0
    ]

    // UIViewController methods
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        initialSetup()
        hideBars(false) // Make sure navBar and toolBar are visible
        subscribeToKeyboardNotifications()
    }

    override func viewWillDisappear(_ animated: Bool) {
        // Unsubscribe from the keyboard notifications that were subscribed to
        // in the beginning
        unsubscribeFromKeyboardNotifications()
    }

    // MARK: Action methods
    @IBAction func cameraAction(_ sender: Any) {
        generateUIImagePicker(withSourceType: .camera)
    }

    @IBAction func albumAction(_ sender: Any) {
        generateUIImagePicker(withSourceType: .photoLibrary)
    }

    @IBAction func sharingAction(_ sender: Any) {
        let memedImage = generateMemedImage()
        let memeToShare = [memedImage]
        let activityVC = UIActivityViewController(activityItems: memeToShare as [Any], applicationActivities: nil)
        activityVC.completionWithItemsHandler = {
            (activityType:UIActivity.ActivityType?, completed: Bool, retItems:[Any]?, error: Error?) in
            if completed {
                // Only call save() if sharing was completed
                self.save()
            }
        }
        present(activityVC, animated: true, completion: nil)
    }

    @IBAction func cancelAction(_ sender: Any) {
        self.view.endEditing(true) // Dismiss keyboard
        memeImageView.image = UIImage() // Clear out image
        initialSetup() // Reset to initial view
    }

    // MARK: Meme methods
    func save() {
        let memedImage = generateMemedImage()

        let meme = Meme(topText: topTextField.text!, bottomText: bottomTextField.text!, originalImage: memeImageView.image!, memedImage: memedImage)
    }

    func generateMemedImage() -> UIImage {
        hideBars(true) // Do not want to see navBar and toolBar in the memed image

        UIGraphicsBeginImageContext(self.view.frame.size)
        view.drawHierarchy(in: self.view.frame, afterScreenUpdates: true)
        let memedImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()

        hideBars(false) // Bring back navBar and toolBar

        return memedImage
    }

    // MARK: MemeMeEditorViewController helper methods

    // Generates and presents a UIImagePickerController
    func generateUIImagePicker(withSourceType sourceType: UIImagePickerController.SourceType) {
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        pickerController.sourceType = sourceType
        present(pickerController, animated: true, completion: nil)
    }

    // Sets the initial view for textFields, disables sharing button
    // and checks to see if camera functionality is available
    func initialSetup() {
        cameraButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
        enableSharing(false)
        setupTextField(topTextField, withString: "TOP")
        setupTextField(bottomTextField, withString: "BOTTOM")
    }

    // Sets textField text attributes and text
    func setupTextField(_ textField: UITextField, withString str: String) {
        textField.defaultTextAttributes = memeTextAttributes
        textField.textAlignment = .center
        textField.delegate = self
        textField.text = str
    }

    // Hids navBar and toolBar
    func hideBars(_ isHidden: Bool) {
        // If bars are hidden then make background black
        if isHidden {
            self.view.backgroundColor = .black
        } else {
            // This allows background to be white to see the status bar
            self.view.backgroundColor = .white
        }
        navBar.isHidden = isHidden
        toolBar.isHidden = isHidden
    }

    func enableSharing(_ isEnabled: Bool) {
        sharingButton.isEnabled = isEnabled
    }

    // MARK: Keyboard methods

    // Checks if keyboard covers textField
    // if so then shift view
    @objc func keyboardDidShow(_ notification: Notification) {
        var viewFrame = view.frame
        viewFrame.size.height -= getKeyboardHeight(notification)

        if !viewFrame.contains(activeTextField.frame.origin) {
            view.frame.origin.y -= getKeyboardHeight(notification)
        }
    }

    // Shift view back to its original state
    @objc func keyboardDidHide(_ notification: Notification) {
        if view.frame.origin.y != 0 {
            view.frame.origin.y = 0
        }
    }

    // Returns height of keyboard
    func getKeyboardHeight(_ notification: Notification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue

        return keyboardSize.cgRectValue.height
    }

    func subscribeToKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardDidShow(_:)), name: UIResponder.keyboardDidShowNotification, object: nil)

        NotificationCenter.default.addObserver(self, selector: #selector(keyboardDidHide(_:)), name: UIResponder.keyboardDidHideNotification, object: nil)
    }

    func unsubscribeFromKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardDidShowNotification, object: nil)

        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardDidHideNotification, object: nil)
    }

    // MARK: UITextFieldDelegate methods
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField.text == "TOP" || textField.text == "BOTTOM" {
            textField.text = ""
        }
        // Used to find out of textfield is being covered by keyboard
        activeTextField = textField
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        // Clear out this value
        activeTextField = nil
    }

    // Dismiss keyboard when return key is pressed
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()

        return true
    }

    // MARK: UIImagePickerControllerDelegate methods
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        // Only set image if a picture (not video) has been selected
        if let img = info[.originalImage] as? UIImage {
            memeImageView.image = img
        }
        picker.dismiss(animated: true, completion: { () in
            self.enableSharing(true)
        })
    }
}

