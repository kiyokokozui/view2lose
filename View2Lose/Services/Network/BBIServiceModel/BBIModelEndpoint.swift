//
//  BBIModelEndpoint.swift
//  View2Lose
//
//  Created by Sagar on 5/6/20.
//  Copyright © 2020 Sagar. All rights reserved.
//

import UIKit

protocol BBIRequestDelegate {
    
}

enum BBIRequestIds: Int {
    case BBIRequest = 0
    case BBIRequestLogin = 1
    case BBIRequestCreateNewUser = 2
    case BBIRequestCreateNewClient = 3
    case BBIRequestUpdateUser = 4
    case BBIRequestUpdateUserWorkout = 5
    case BBIRequestDeleteUser = 6
    case BBIRequestAddUserWorkout = 7
    case BBIRequestLoadAllClients = 8
    case BBIRequestDefaultWorkoutByBodyType = 9
    case BBIRequestLoadUserWorkout = 10
    case BBIRequestLoadLookupData = 11
    case BBIRequestWarpImage = 12
    case BBIRequestCalculateBMR = 13
    case BBIRequestLoadAllWorkouts = 14
    case BBIRequestLoadCorporateClients = 15
    case BBIRequestLoadUserRoles = 16
    case BBIRequestLoadBananaWorkout = 17
    case BBIRequestLoadAppleWorkout = 18
    case BBIRequestLoadPearWorkout = 19
    case BBIRequestLoadPotatoWorkout = 20
    case BBIRequestWarpMeLogin = 21
    case BBIRequestLoadWarpMeSystemSettings = 22
    case BBIRequestUpdateWeight = 23
    case BBIRequestUpdateWaistSize = 24
    case BBIRequestUSDAFreeText = 25
    case BBIRequestUSDACalorie = 26
    case BBIRequestCompleteUser = 27
    case BBIRequestUpdateProfile = 28
    case BBIRequestForgotPassword = 29
    case BBIAddCalorieIntakeEntry = 30
    case BBIAddBurnedCaloriesEntry = 31
    case BBIFetchCalorieIntakeForWeek = 32
    case BBIFetchCalorieBurnedForWeek = 33
    case BBIResetCalories = 34
    case BBIRequestWarpImageSMR = 35
    case BBIRequestGetUserImages = 36
    case BBIRequestActivateAccount = 37
    case BBIRequestValidateTeamName = 38
}


let BBIRequestIdByEnums = [
    "None",
    "Login",
    "CreateNewUser",
    "CreateNewClient",
    "UpdateUser",
    "UpdateUserWorkout",
    "DeleteUser",
    "AddUserWorkout",
    "LoadAllClients",
    "DefaultWorkoutByBodyType",
    "LoadUserWorkout",
    "LoadLookupData",
    "WarpImage",
    "CalculateBMR",
    "LoadAllWorkouts",
    "LoadCorporateClients",
    "LoadUserRoles",
    "LoadBananaWorkout",
    "LoadAppleWorkout",
    "LoadPearWorkout",
    "LoadPotatoWorkout",
    "WarpMeLogin",
    "LoadWarpMeSystemSettings",
    "UpdateUserWeight",
    "UpdateUserWaist",
    "search",
    "nutrients",
    "CompleteProfile",
    "Interaction",
    "RetrievePassword",
    "AddUserCalorieEntry",
    "AddUserCalorieBurnEntry",
    "LoadWeeklyCalorieEntries",
    "LoadWeeklyCalorieBurnEntries",
    "ResetTodaysCalories",
    "WarpImage2",
    "GetAllUserImages",
    "ActivateAccount",
    "ValidateTeamName"
]
let BaseURI = "http://104.211.63.244/BBIDataService/service.svc?wsdl"
let URL = "http://104.211.63.244/BBIDataService/service.svc/"

let constantKey = "2706f370-a93a-4c4f-9fd4-3077db1140ff"


class BBIModelEndpoint {

    static let sharedService = BBIModelEndpoint()
    private init() {}
    
    static public func urlWithRequestId(requestId: BBIRequestId)-> String {
        let methodUrlName = String(utf8String: BBIRequestIdByEnums[Int(requestId.rawValue)])
        if let methodUrl = methodUrlName {
            let url = "\(URL)\(methodUrlName!)"
            print(url)
            return url
        }
        return ""
    }
    
    public func makePostRequest(requestId: BBIRequestId, data: [String: Any], delegate: Any, requestType: BBIRequestType) {
        let url = NSURL(string: BBIModelEndpoint.urlWithRequestId(requestId: requestId))

       // let url = NSURL(string: "http://104.211.63.244/BBIDataService/service.svc/CreateNewUser")
        var request = URLRequest(url: url! as URL)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        
        guard let httpbody = try? JSONSerialization.data(withJSONObject: data, options: .prettyPrinted) else {return}
        request.httpBody = httpbody
        
        let session = URLSession.shared
        session.dataTask(with: request) { (data, response, error) in
            if error != nil {
                print(error)
            }
            if let response = response {
                print(response)
            }
            
            if let data = data {
                do {
                    print(data)
                    let json = try JSONSerialization.jsonObject(with: data, options: [.allowFragments])
                    print(json)
                    
                } catch {
                    print(error)
                }
            }
        }.resume()

        
    }
    
    public func makePostRequest(requestId: BBIRequestId, data: [String: Any],requestType: BBIRequestType, completion: @escaping (Result<String, Error>) -> ()) {
        let url = NSURL(string: BBIModelEndpoint.urlWithRequestId(requestId: requestId))

       // let url = NSURL(string: "http://104.211.63.244/BBIDataService/service.svc/CreateNewUser")
        var request = URLRequest(url: url! as URL)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        
        guard let httpbody = try? JSONSerialization.data(withJSONObject: data, options: .prettyPrinted) else {return}
        request.httpBody = httpbody
        
        let session = URLSession.shared
        session.dataTask(with: request) { (data, response, error) in
            if error != nil {
                print(error)
            }
            if let response = response {
                print(response)
            }
            
            if let data = data {
                do {
                    print(data)
                    let json = try JSONSerialization.jsonObject(with: data, options: [.allowFragments])
                    print(json)
                    completion(.success(json as! String))
                    
                } catch {
                    print(error)
                    completion(.failure(error))
                }
            }
        }.resume()

        
    }

    
    public func makeGetRequest(requestId: BBIRequestId, delegate: Any) {
        
    }
    
    public func delegate(requestDelegate: BBIRequestDelegate, hasRequest: BBIRequestId, failedWithJson: Dictionary<String, Any>) {
        
    }
    
    public func makePostRequest(requestId: BBIRequestId, data: Dictionary<String, Any>, completion: @escaping (Result<String, Error>) -> ()){
        
    }
    
    public func makeGetRequest(requestId: BBIRequestId, withParamString: String, completion: @escaping (Result<String, Error>) -> ()) {
        
    }
    
    public func makeRequestWithRequestId(requestId: BBIRequestId, data: Data, requestType: BBIRequestType, completion: @escaping (Result<String, Error>)->()) {
        if requestType == GET {
            //self.makeGetRequest(requestId: requestId, delegate: nil)
        } else {
            let delegate = ""
           // self.makePostRequest(requestId: requestId, data: data, delegate: delegate, requestType: POST)
        }
    }
    typealias resultClosureBlock = (Result<String, Error>) -> ()
    
    public func createNewUsername(username:String, email: String, fullName: String, gender: String, height: Double, weight: Double, waistSize: Int, bodyTypeId: Int, activityLevelId: Int, firstName: String, lastName: String, BMR: String, GoalWeightChange: Int?, GoalWeight: Double, GoalType: Int, Password: String, completion: @escaping (Result<NewUserResponse, Error>) -> ()) {
        let dalegate = ""
        let param = ["Username": username,
                     "Email": email,
                     "FullName": fullName,
                     "Gender": gender,
                     "Height": height,
                     "Weight": weight,
                     "WaistSize": waistSize,
                     "BodyTypeId": bodyTypeId,
                     "ActivityLevelId": activityLevelId,
                     "FirstName": firstName,
                     "LastName": lastName,
                     "BMR": BMR,
                     "GoalWeightChange": GoalWeightChange ?? 0,
                     "GoalWeight": GoalWeight,
                     "GoalType": GoalType,
                     "Password": ""
                     
            ] as [String : Any]
//        do {
//          //  let data = try? JSONSerialization.data(withJSONObject: param as [String: Any], options: [.])
//           self.makePostRequest(requestId: BBIRequestCreateNewUser, data: param, delegate: delegate, requestType: POST)
//           // self.makePostRequest(requestId: <#T##BBIRequestId#>, data: <#T##Dictionary<String, Any>#>, completion: <#T##(Result<String, Error>) -> ()#>)
//        } catch {
//            print(error)
//        }
        
        do {
            let url = NSURL(string: BBIModelEndpoint.urlWithRequestId(requestId: BBIRequestCreateNewUser))

            var request = URLRequest(url: url! as URL)
            request.httpMethod = "POST"
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.setValue("application/json", forHTTPHeaderField: "Accept")
            
            guard let httpbody = try? JSONSerialization.data(withJSONObject: param, options: .prettyPrinted) else {return}
            request.httpBody = httpbody
            
            let session = URLSession.shared
            session.dataTask(with: request) { (data, response, error) in
                if error != nil {
                    print(error)
                }
                if let response = response {
                    print("!!!!!", response)
                }
                 
                if let data = data {
                    print(data)
                    do {
                        let json = try JSONSerialization.jsonObject(with: data, options: [.allowFragments])
                        print("?????", json)
                        
                        let newUser = try JSONDecoder().decode(NewUserResponse.self, from: data)
                        
                        if newUser.ResponseObject != nil {
                            print("Create User Response ===== ", newUser)
                        } else {
                            print("Data is null")
                        }
                        
                        completion(.success(newUser))
                         
                    } catch {
                        print(error.localizedDescription)
                        completion(.failure(error))
                    }
                }
            }.resume()
        }
        
    }
    
    public func login(email: String, completion: @escaping (Result<LoginUserResponse, Error>) -> ()) {
        let dalegate = ""
        let param = ["CredentialUsername": email,
            "CredentialPassword": constantKey
                     
            ] as [String : Any]
        
        do {
            let url = NSURL(string: BBIModelEndpoint.urlWithRequestId(requestId: BBIRequestLogin))

            var request = URLRequest(url: url! as URL)
            request.httpMethod = "POST"
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.setValue("application/json", forHTTPHeaderField: "Accept")
            
            guard let httpbody = try? JSONSerialization.data(withJSONObject: param, options: .prettyPrinted) else {return}
            request.httpBody = httpbody
            
            let session = URLSession.shared
            session.dataTask(with: request) { (data, response, error) in
                if error != nil {
                    print(error)
                }
                if let response = response {
                    print("!!!!!", response)
                }
                 
                if let data = data {
                    print(data)
                    do {
                        let json = try JSONSerialization.jsonObject(with: data, options: [.allowFragments])
                        print("?????", json)
                        
                        let loginUser = try JSONDecoder().decode(LoginUserResponse.self, from: data)
                        
                        if loginUser.ResponseObject != nil {
                            print("login ", loginUser)
                        } else {
                            print("Data is null")
                        }
                        
                        completion(.success(loginUser))
                         
                    } catch {
                        print(error.localizedDescription)
                        completion(.failure(error))
                    }
                }
            }.resume()
        }
    }
    
    public func getAllUserImages(email: String, completion: @escaping (Result<LoginUserResponse, Error>) -> ()) {
        let dalegate = ""
        let param = ["CredentialUsername": email,
            "CredentialPassword": constantKey
                     
            ] as [String : Any]
        
        do {
            let url = NSURL(string: BBIModelEndpoint.urlWithRequestId(requestId: BBIRequestGetUserImages))

            var request = URLRequest(url: url! as URL)
            request.httpMethod = "POST"
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.setValue("application/json", forHTTPHeaderField: "Accept")
            
            guard let httpbody = try? JSONSerialization.data(withJSONObject: param, options: .prettyPrinted) else {return}
            request.httpBody = httpbody
            
            let session = URLSession.shared
            session.dataTask(with: request) { (data, response, error) in
                if error != nil {
                    print(error)
                }
                if let response = response {
                    print("!!!!!", response)
                }
                 
                if let data = data {
                    print(data)
                    do {
                        let json = try JSONSerialization.jsonObject(with: data, options: [.allowFragments])
                        print("?????", json)
                        
                        let loginUser = try JSONDecoder().decode(LoginUserResponse.self, from: data)
                        
                        if loginUser.ResponseObject != nil {
                            print("login ", loginUser)
                        } else {
                            print("Data is null")
                        }
                        
                        completion(.success(loginUser))
                         
                    } catch {
                        print(error.localizedDescription)
                        completion(.failure(error))
                    }
                }
            }.resume()
        }
    }
    
    public func updateUserWeight(userId: Int, weight: String, measureType: String, completion: @escaping (Result<UpdateWWRes, Error>) -> ()) {
        let dalegate = ""
        let param = ["UserId": userId,
                     "Weight": weight,
                     "MeasurementType": measureType
                     
            ] as [String : Any]
        
        do {
            let url = NSURL(string: BBIModelEndpoint.urlWithRequestId(requestId: BBIRequestUpdateWeight))

            var request = URLRequest(url: url! as URL)
            request.httpMethod = "POST"
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.setValue("application/json", forHTTPHeaderField: "Accept")
            
            guard let httpbody = try? JSONSerialization.data(withJSONObject: param, options: .prettyPrinted) else {return}
            request.httpBody = httpbody
            
            let session = URLSession.shared
            session.dataTask(with: request) { (data, response, error) in
                if error != nil {
                    print(error)
                }
                if let response = response {
                    print("!!!!!", response)
                }
                 
                if let data = data {
                    print(data)
                    do {
                        let json = try JSONSerialization.jsonObject(with: data, options: [.allowFragments])
                        print("?????", json)
                        
                        let updateWeight = try JSONDecoder().decode(UpdateWWRes.self, from: data)
                        
                        if updateWeight.ResponseMessage != nil {
                            print("login ", updateWeight)
                        } else {
                            print("Data is null")
                        }
                        
                        completion(.success(updateWeight))
                         
                    } catch {
                        print(error.localizedDescription)
                        completion(.failure(error))
                    }
                }
            }.resume()
        }
    }
    
    public func updateUserWaist(userId: Int, waist: String, measureType: String, completion: @escaping (Result<UpdateWWRes, Error>) -> ()) {
        let dalegate = ""
        let param = ["UserId": userId,
                     "WaistSize": waist,
                     "MeasurementType": measureType
                     
            ] as [String : Any]
        
        do {
            let url = NSURL(string: BBIModelEndpoint.urlWithRequestId(requestId: BBIRequestUpdateWaistSize))

            var request = URLRequest(url: url! as URL)
            request.httpMethod = "POST"
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.setValue("application/json", forHTTPHeaderField: "Accept")
            
            guard let httpbody = try? JSONSerialization.data(withJSONObject: param, options: .prettyPrinted) else {return}
            request.httpBody = httpbody
            
            let session = URLSession.shared
            session.dataTask(with: request) { (data, response, error) in
                if error != nil {
                    print(error)
                }
                if let response = response {
                    print("!!!!!", response)
                }
                 
                if let data = data {
                    print(data)
                    do {
                        let json = try JSONSerialization.jsonObject(with: data, options: [.allowFragments])
                        print("?????", json)
                        
                        let updateWaist = try JSONDecoder().decode(UpdateWWRes.self, from: data)
                        
                        if updateWaist.ResponseMessage != nil {
                            print("login ", updateWaist)
                        } else {
                            print("Data is null")
                        }
                        
                        completion(.success(updateWaist))
                         
                    } catch {
                        print(error.localizedDescription)
                        completion(.failure(error))
                    }
                }
            }.resume()
        }
    }
    
    
    public func warpImageWithImageData1(_ imageData: Data, leftWaist: [Int: Int], rightWaist: [Int: Int], yKneeCoord: [Int: Int], leftNaval: [String: Int], rightNaval: [String: Int], leftHips: [Int: Int], rightHips: [Int: Int], midChest: [Int: Int], leftBi: [Int: Int], rightBi: [Int: Int], bodyTypeId: Int, waistInInches: Float, userId: String, blurface: Int) {
        let dalegate = ""
        let params = ["leftWaist": leftWaist,
                        "rightWaist": rightWaist,
                        "YKneeCoord": yKneeCoord,
                        "leftNavel": leftNaval,
                        "rightNavel": rightNaval,
                        "leftHips": leftHips,
                        "rightHips": rightHips,
                        "midChest": midChest,
                        "leftBi": leftBi,
                        "rightBi": rightBi,
                        "BodyTypeID": bodyTypeId,
                        "WaistInInches": waistInInches,
                        "Base64EncodedImageData": imageData,
                        "UserId": userId,
                        "BlurFace": blurface ]  as [String : Any]
        
        do {
            self.makePostRequest(requestId: BBIRequestWarpImage, data: params, delegate: delegate, requestType: POST)
        } catch {
            print(error)
        }
    }
    
    public func warpImageWithImageData(_ imageData: Data, leftNavel: [String: Int],  rightNavel: [String: Int], bodyTypeId: Int, topOfHead: Int, bottomOfFeet: Int, heightInInches: Int, userName: String, waistInInches: Float, userId: Int, blurface: Int, completion: @escaping (Result<WarpImageResponse, Error>) -> ()  ) {
          let dalegate = ""
        let imageDataString = imageData.base64EncodedString(options: Data.Base64EncodingOptions(rawValue: 0))
          let params = [
                        
                          "leftNavel": leftNavel,
                          "rightNavel": rightNavel,
                          "TopOfHead" : topOfHead,
                          "BottomOfFeet" : bottomOfFeet,
                          "BodyTypeID": bodyTypeId,
                          "WaistInInches": waistInInches,
                          "LargestNavelInInches" : waistInInches,
                          "Base64EncodedImageData": imageDataString,
                          "UserId": userId,
                          "UserName": userName]  as [String : Any]
                        //  "BlurFace": blurface ]  as [String : Any]
          
          do {
             // self.makePostRequest(requestId: BBIRequestWarpImage, data: params, delegate: delegate, requestType: POST)
          //  self.makePostRequest(requestId: BBIRequestWarpImage, data: params, completion: completion)
            let url = NSURL(string: BBIModelEndpoint.urlWithRequestId(requestId: BBIRequestWarpImage))

           var request = URLRequest(url: url! as URL)
           request.httpMethod = "POST"
           request.setValue("application/json", forHTTPHeaderField: "Content-Type")
           request.setValue("application/json", forHTTPHeaderField: "Accept")
           
           guard let httpbody = try? JSONSerialization.data(withJSONObject: params, options: .prettyPrinted) else {return}
           request.httpBody = httpbody
           
           let session = URLSession.shared
           session.dataTask(with: request) { (data, response, error) in
               if error != nil {
                   print(error)
               }
               if let response = response {
                   print(response)
               }
               
               if let data = data {
                   do {
                    let json = try JSONSerialization.jsonObject(with: data, options: [.allowFragments])
                    print(json)
                    let warpImage = try JSONDecoder().decode(WarpImageResponse.self, from: data)
                    print(warpImage.ResponseObject)
                    completion(.success(warpImage))
                       
                   } catch {
                       print(error)
                       completion(.failure(error))
                   }
               }
           }.resume()
          } catch {
              print(error)
          }
      }

    
    
    
    
}
