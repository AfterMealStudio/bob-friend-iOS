//
//  Keyboard.swift
//  bob-friend-iOS
//
//  Created by 김수진 on 2021/08/27.
//

import UIKit

class Keyboard {
    
    let vc: UIViewController
    
    var keyHeight: CGFloat?
    var keyBoardFlag = false
    
    init (_ vc: UIViewController) {
        self.vc = vc
        enrollNotification()
    }
    
    func enrollNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keyboardWillShow(_ sender: Notification) {
        if keyBoardFlag {
            vc.view.frame.size.height += keyHeight!
            keyBoardFlag = false
        }
        let userInfo: NSDictionary = sender.userInfo! as NSDictionary
        let keyboardFrame: NSValue = userInfo.value(forKey: UIResponder.keyboardFrameEndUserInfoKey) as! NSValue
        let keyboardRectangle = keyboardFrame.cgRectValue
        let keyboardHeight = keyboardRectangle.height
        keyHeight = keyboardHeight
        
        vc.view.frame.size.height -= keyboardHeight
        keyBoardFlag = true
    }
    
    @objc func keyboardWillHide(_ sender: Notification) {
        vc.view.frame.size.height += keyHeight!
        keyBoardFlag = false
    }
    

    func remove(keyboardUsers: [UIView]) { // keyboardUsers = [txtField, ...]
        keyboardUsers.forEach({
            $0.resignFirstResponder()
        })
    }
    
    func remove() {
        vc.view.endEditing(true)
    }
    
}
