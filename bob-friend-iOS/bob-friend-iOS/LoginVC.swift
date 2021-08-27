//
//  LoginVC.swift
//  bob-friend-iOS
//
//  Created by 김수진 on 2021/08/25.
//

import UIKit

class LoginVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        setUI()
    }

    @IBOutlet weak var logoImgView: UIImageView!
    @IBOutlet weak var idTxtField: UITextField!
    @IBOutlet weak var pwdTxtField: UITextField!
    @IBOutlet weak var loginBtn: UIButton!
    
    func setUI() {
        setLogoImageView()
        setTxtFields()
        setLoginBtn()
    }
    
    func setLogoImageView() {
        logoImgView.image = logoImgView.image?.withRenderingMode(.alwaysTemplate)
        logoImgView.tintColor = UIColor(named: "MainColor1")
    }
    
    func setTxtFields() {
        idTxtField.layer.addUnderBar()
        pwdTxtField.layer.addUnderBar()
    }
    
    func setLoginBtn() {
        loginBtn.layer.cornerRadius = 5
        loginBtn.setTitleColor(UIColor(named: "White"), for: .normal)
        loginBtn.backgroundColor = UIColor(named: "MainColor1")
    }

}
