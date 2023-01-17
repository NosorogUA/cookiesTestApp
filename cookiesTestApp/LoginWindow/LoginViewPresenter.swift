//
//  LoginViewPresenter.swift
//  cookiesTestApp
//
//  Created by mac on 1/16/23.
//

import Foundation

protocol LoginViewPresenterProtocol {
    init(view: LoginWindowViewControllerProtocol)
    func login()
    func getData()
}

class LoginViewPresenter: LoginViewPresenterProtocol {
    
    let dataManager = NetworkManager()
        
    private weak var view: LoginWindowViewControllerProtocol?
    
    required init(view: LoginWindowViewControllerProtocol) {
        self.view = view
    }
    
    func login() {
        // mace request
        dataManager.Login { [weak self] result in
//            guard let self = self else { return }
            switch result {
            case .success(let data):
                DispatchQueue.main.async {
                   // to view
                    self?.view?.printMessage("All ok, Data: \(data)")
                }
                print(data)
            case .failure(let error):
                print(error)
                self?.view?.printMessage(error.localizedDescription)
            }
        }
    }
    
    func getData(){
        //get some data
        dataManager.getData { [weak self] result in
            //            guard let self = self else { return }
            switch result {
            case .success(let data):
                print("DATA>>>>> \(data)")
                DispatchQueue.main.async {
                    // to view
                    let message = "Data = \(data)"
                    self?.view?.printMessage(message)
                }
                print(data)
            case .failure(let error):
                print(error)
                
            }
        }
    }
}
