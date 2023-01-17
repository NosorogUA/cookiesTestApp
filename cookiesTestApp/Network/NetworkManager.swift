//
//  NetworkManager.swift
//  cookiesTestApp
//
//  Created by mac on 1/16/23.
//

import Foundation

protocol NetworkManagerProtocol {
    func Login (completion: @escaping ((Result<[String : Any], Error>) -> Void))
    func getData(completion: @escaping ((Result<CoursesModel, Error>) -> Void))
}

class NetworkManager: NetworkManagerProtocol {
   
    var body: [String : Any] = [
        "email": "stepan@gmail.com",
        "phone": "+380667187072",
        "otp": 12345
    ]
    
    private let baseURL = "https://crypto-crew-dev-backend.lampawork.com/api/v1/auth/verify"
    
    private let secondUrl = "https://crypto-crew-dev-backend.lampawork.com/api/v1/courses/?page=5&limit=10"
    
    // create post request
    func Login (completion: @escaping ((Result<[String : Any], Error>) -> Void)) {
        print("setup login")
        let jsonData = try? JSONSerialization.data(withJSONObject: body)
        guard let url = URL(string: baseURL) else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = jsonData
        let session = URLSession.shared
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard
                let url = response?.url,
                let httpResponse = response as? HTTPURLResponse,
                let fields = httpResponse.allHeaderFields as? [String: String]
            else { return }
            print(response)
            let cookies = HTTPCookie.cookies(withResponseHeaderFields: fields, for: url)
            HTTPCookieStorage.shared.setCookies(cookies, for: url, mainDocumentURL: nil)
            for cookie in cookies {
                var cookieProperties = [HTTPCookiePropertyKey: Any]()
                cookieProperties[.name] = cookie.name
                cookieProperties[.value] = cookie.value
                cookieProperties[.domain] = cookie.domain
                cookieProperties[.path] = cookie.path
                cookieProperties[.version] = cookie.version
                cookieProperties[.expires] = cookie.expiresDate //Date().addingTimeInterval(31536000)
//                cookieProperties[.expires] = cookie.expiresDate
                
                let newCookie = HTTPCookie(properties: cookieProperties)
                HTTPCookieStorage.shared.setCookie(newCookie!)
                
                print("name: \(cookie.name) value: \(cookie.value)  exp'\(cookie.expiresDate!)")
            }
        }
        task.resume()
    }
    
    func getData(completion: @escaping ((Result<CoursesModel, Error>) -> Void)) {
        guard let url = URL(string: secondUrl) else { return }
        // Info: https://stackoverflow.com/questions/34590992/swift-how-to-set-cookie-in-nsmutableurlrequest
        let jar = HTTPCookieStorage.shared
        let cookieHeaderField = ["Set-Cookie": "key=value"] // Or ["Set-Cookie": "key=value, key2=value2"] for multiple cookies
        let cookies = HTTPCookie.cookies(withResponseHeaderFields: cookieHeaderField, for: url)
        print("Cookies: >>>>>>>>>>>. \(cookies)")
        jar.setCookies(cookies, for: url, mainDocumentURL: url)
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
           
            if response != nil {
                print("response>>>>>>>>>>>\(response)")
                if let httpResponse = response as? HTTPURLResponse, (httpResponse.statusCode == 401 || httpResponse.statusCode == 403) {
                    // get new access token
                    print("httpResponse.statusCode not valid:", httpResponse.statusCode)
                }
            }
            
            guard let data = data, error == nil else {
                completion(.failure(error!))
                return
            }
            do {
                let json = try JSONDecoder().decode(CoursesModel.self, from: data)
                // return Data
                completion(.success(json))
            } catch {
                print(error.localizedDescription)
                completion(.failure(error))
            }
        }
        task.resume()
    }
}
