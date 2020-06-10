//
//  InstagramApi.swift
//  InstaLogin
//
//  Created by purich purisinsits on 17/4/20.
//  Copyright © 2020 purich purisinsits. All rights reserved.
//

import Foundation

class InstagramApi {
    static let shared = InstagramApi()
    
    private let instagramAppID = "645726012670990"
    private let redirectURIURLEncoded = "https%3A%2F%2Fwww.google.com%2F"
    private let redirectURI = "https://www.google.com"
    private let app_secret = "983bb213689f1a926e4611de869497ca"
    private let boundary = "boundary=\(NSUUID().uuidString)"
    private init () {}
    
    private enum BaseURL: String {
      case displayApi = "https://api.instagram.com/"
      case graphApi = "https://graph.instagram.com/"
    }
    private enum Method: String {
      case authorize = "oauth/authorize"
      case access_token = "oauth/access_token"
    }
    
    
    func authorizeApp(completion: @escaping (_ url: URL?) -> Void ) {
      let urlString = "\(BaseURL.displayApi.rawValue)\(Method.authorize.rawValue)?app_id=\(instagramAppID)&redirect_uri=\(redirectURIURLEncoded)&scope=user_profile,user_media&response_type=code"
        let request = URLRequest(url: Foundation.URL(string: urlString)!)
      let session = URLSession.shared
      let task = session.dataTask(with: request, completionHandler: {  data, response, error in
        if let response = response {
          print("RESPONSE: ", response)
          completion(response.url)
        }
      })
      task.resume()
    }
    
    private func getTokenFromCallbackURL(request: URLRequest) -> String? {
        let requestURLString = (request.url?.absoluteString)! as String
        
        if (requestURLString.starts(with: "\(redirectURI)?code=")) {
            print("Response uri:",requestURLString)
        
            if let range = requestURLString.range(of: "\(redirectURI)?code=") {
                let checkKey = String(requestURLString[range.upperBound...].dropLast(2))
                print("KEY: ", checkKey)
                return checkKey
            }
        }
        return nil
    }
    
    private func getFormBody(_ parameters: [[String : String]], _ boundary: String) -> Data {
        var body = ""
        let error: NSError? = nil
        
        for param in parameters {
            let paramName = param["name"]!
            
            body += " — \(boundary)\r\n"
            body += "Content-Disposition:form-data; name=\"\(paramName)\""
            
            if let filename = param["fileName"] {
                let contentType = param["content-type"]!
                var fileContent: String = ""
            
                do {
                    fileContent = try String(contentsOfFile: filename, encoding: String.Encoding.utf8)
                }
                catch {
                    print("fileContent: ", error)
                }
            
                if (error != nil) {
                    print(error!)
                }
            
                body += "; filename=\"\(filename)\"\r\n"
                body += "Content-Type: \(contentType)\r\n\r\n"
                body += fileContent
            }
            else if let paramValue = param["value"] {
                body += "\r\n\r\n\(paramValue)"
            }
        }
      return body.data(using: .utf8)!
    }
    
    func getTestUserIDAndToken(request: URLRequest, completion: @escaping (InstagramTestUser) -> Void){
        guard let authToken = getTokenFromCallbackURL(request: request)
            else {
                return
            }
        let headers = [
            "content-type": "multipart/form-data; boundary=\(boundary)"
        ]
        let parameters = [
            [
                "name": "app_id",
                "value": instagramAppID
            ],
            [
                "name": "app_secret",
                "value": app_secret
            ],
            [
                "name": "grant_type",
                "value": "authorization_code"
            ],
            [
                "name": "redirect_uri",
                "value": redirectURI
            ],
            [
                "name": "code",
                "value": authToken
            ]
        ]
        
        var request = URLRequest(url: Foundation.URL(string:   BaseURL.displayApi.rawValue + Method.access_token.rawValue)!)
        
        let postData = getFormBody(parameters, boundary)
        request.httpMethod = "POST"
        request.allHTTPHeaderFields = headers
        request.httpBody = postData
        
        let session = URLSession.shared
        let dataTask = session.dataTask(with: request, completionHandler: {(data, response, error) in
            if (error != nil) {
                print(error!)
            }
            else {
                do {
                    let jsonData = try JSONDecoder().decode(InstagramTestUser.self, from: data!)
                    print(jsonData)
                    completion(jsonData)
                }
                catch let error as NSError{
                    print(error)
                }
            }
        })
        dataTask.resume()
    }
    
    func getInstagramUser(testUserData: InstagramTestUser, completion: @escaping (InstagramUser) -> Void) {
        let urlString = "\(BaseURL.graphApi.rawValue)\(testUserData.user_id)?fields=id,username&access_token=\(testUserData.access_token)"
        let request = URLRequest(url: Foundation.URL(string: urlString)!)
        let session = URLSession.shared
        print("urlString")
        let dataTask = session.dataTask(with: request, completionHandler: {(data, response, error) in
            if (error != nil) {
                print(error!)
            }
            else {
                let httpResponse = response as? HTTPURLResponse
                print(httpResponse!)
            }
            do {
                let jsonData = try JSONDecoder().decode(InstagramUser.self, from: data!)
                
                completion(jsonData)
            }
            catch let error as NSError {
                print(error)
            }
        })
        dataTask.resume()
    }
}
