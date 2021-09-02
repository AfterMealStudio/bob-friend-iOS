//
//  LoginVC.swift
//  bob-friend-iOS
//
//  Created by 김수진 on 2021/08/25.
//

import UIKit

class LoginVC: UIViewController {

    @IBOutlet weak var scrollView: UIScrollView!

    @IBOutlet weak var logoImgView: UIImageView! {
        didSet {
            logoImgView.image = logoImgView.image?.withRenderingMode(.alwaysTemplate)
            logoImgView.tintColor = UIColor(named: "MainColor1")
        }
    }
    @IBOutlet weak var idTxtField: UITextField! {
        didSet { idTxtField.layer.addBorder() }
    }
    @IBOutlet weak var pwdTxtField: UITextField! {
        didSet { pwdTxtField.layer.addBorder() }
    }
    @IBOutlet weak var loginBtn: UIButton! {
        didSet {
            loginBtn.layer.cornerRadius = 5
            loginBtn.setTitleColor(UIColor(named: "White"), for: .normal)
            loginBtn.backgroundColor = UIColor(named: "MainColor1")
        }
    }
    
    var loginVM: LoginVM = LoginVM()
    
    private var keyHeight: CGFloat?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loginVM.delegate = self
        
        // keyboard
        enrollKeyboardNotification()
        enrollRemoveKeyboard()
    }
    
    
    @IBAction func loginBtnClicked(_ sender: Any) {
        removeKeyboard()
        if let id = idTxtField.text, let pwd = pwdTxtField.text {
            loginVM.login(id: id, pwd: pwd)
        }
    }
    
    
}



extension LoginVC: UIScrollViewDelegate {
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        removeKeyboard()
    }
    
}



extension LoginVC: LoginDelegate {
    func didSuccessLogin(_ token: TokenModel) {
        print(token)
    }
    
    func didFailLogin(_ err: Error) {
        let alertController = UIAlertController(title: "로그인 실패 하였습니다", message: nil, preferredStyle: .alert)
        let okBtn = UIAlertAction(title: "확인", style: .default) { [weak self] _ in
            self?.dismiss(animated: true, completion: nil)
        }
        
        alertController.addAction(okBtn)
        present(alertController, animated: true, completion: nil)
    }
    
}



extension LoginVC { //keyboard Management
    
    private func enrollKeyboardNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    
    @objc
    private func keyboardWillShow(_ sender: Notification) {
        if let _ = keyHeight {
            return
        }
        let userInfo: NSDictionary = sender.userInfo! as NSDictionary
        let keyboardFrame: NSValue = userInfo.value(forKey: UIResponder.keyboardFrameEndUserInfoKey) as! NSValue
        let keyboardRectangle = keyboardFrame.cgRectValue
        let keyboardHeight = keyboardRectangle.height
        keyHeight = keyboardHeight
        
        view.frame.size.height -= keyboardHeight
    }
    
    
    @objc
    private func keyboardWillHide(_ sender: Notification) {
        if let keyHeight = keyHeight {
            view.frame.size.height += keyHeight
        }
        keyHeight = nil
    }
    
    
    private func removeKeyboard() {
        view.endEditing(true)
        keyHeight = nil
    }
    
    
    private func enrollRemoveKeyboard() {
        let singleTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tapScrollView))
        scrollView.addGestureRecognizer(singleTapGestureRecognizer)
    }
    
    
    @objc
    private func tapScrollView(sender: UITapGestureRecognizer) {
        removeKeyboard()
    }
    
}
