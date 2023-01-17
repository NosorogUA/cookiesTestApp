//
//  ViewController.swift
//  cookiesTestApp
//
//  Created by mac on 1/16/23.
//

import UIKit

protocol LoginWindowViewControllerProtocol: AnyObject {
    func printMessage(_ message: String)
}

class LoginWindowViewController: UIViewController, LoginWindowViewControllerProtocol {
    

    var presenter: LoginViewPresenterProtocol!
    
    @IBOutlet weak var messageLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
       setupView()
    }

    func setupView() {
        presenter = LoginViewPresenter(view: self)
    }
    
    func printMessage(_ message: String) {
        messageLabel.text = message
    }
    
    @IBAction func secondRequestButtonAction(_ sender: Any) {
        presenter.getData()
    }
    
    @IBAction func loginButtonAction(_ sender: Any) {
        presenter.login()
    }
}

