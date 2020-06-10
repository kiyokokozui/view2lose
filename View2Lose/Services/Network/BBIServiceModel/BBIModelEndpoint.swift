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
    
    public func createNewUsername(username:String, email: String, fullName: String, gender: String, height: Int, weight: Int, waistSize: Int, bodyTypeId: Int, activityLevelId: Int, firstName: String, lastName: String, BMR: String, GoalWeightChange: Int?, GoalWeight: Int, GoalType: Int, Password: String) {
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
        do {
          //  let data = try? JSONSerialization.data(withJSONObject: param as [String: Any], options: [.])
            self.makePostRequest(requestId: BBIRequestCreateNewUser, data: param, delegate: delegate, requestType: POST)

        } catch {
            print(error)
        }
        
        
    }

    
    
    
    
}
