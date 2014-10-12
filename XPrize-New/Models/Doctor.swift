//
//  Doctor.swift
//  XPrize-New
//
//  Created by Sihao Lu on 9/10/14.
//  Copyright (c) 2014 DJ.Ben. All rights reserved.
//

import UIKit

typealias SymptomWithErrorHandler = (symptoms: [Symptom]?, error: NSError?) -> Void
typealias SymptomBatchWithErrorHandler = (allSymptoms: [String: [Symptom]], error: NSError?) -> Void
let DoctorPartialErrorKey = "XPrizeDoctorPartialError"
let DoctorErrorDomain = "XPrizeDoctorErrorDomain"

enum DoctorError: Int {
    case SearchSymptomError = 0
    case BatchError = 1
}

class Doctor: NSObject {
    class var sharedDoctor : Doctor {
        struct Static {
            static let instance : Doctor = Doctor()
        }
        return Static.instance
    }

    class var suggestedSymptomKeywords: [String] {
        get {
            return ["Cough", "Headache", "Pain", "Stomach", "Heart"]
        }
    }

    let accessTokenKey = "access_token"
    let accessToken = "72baa3f7457856ef1142a67faa503414"
    let queryURL = "http://aardvark-staging.herokuapp.com/api/v1/concepts.json"
    let queryParamName = "q"

    var searchSymptomRequest: Request?
    var searchController: UISearchController!

    func searchSymptomWithKeyword(symptomName: String, completion: SymptomWithErrorHandler) {
        searchSymptomRequest?.cancel()
        searchSymptomRequest = request(.GET, queryURL, parameters: [queryParamName: symptomName, accessTokenKey: accessToken])
        searchSymptomRequest!.responseJSON { (request, response, symptomsData, error) -> Void in
            if error != nil {
                if error!.isRequestCancelledError() {
                    // Request cancelled: do nothing
                } else {
                    completion(symptoms: nil, error: error)
                }
                return
            }
            let symptoms = Doctor.parseSymptomsJSONDict(symptomsData)
            completion(symptoms: symptoms, error: nil)
        }
    }

    func searchBatchSymptomsWithKeywords(symptomNames: [String], completion: SymptomBatchWithErrorHandler) {
        let syncGroup = dispatch_group_create()
        var allSymptoms = [String: [Symptom]]()
        var allError: NSError?
        var partialErrors = [NSError]()
        for symptomName in symptomNames {
            dispatch_group_enter(syncGroup)
            searchSymptomRequest = request(.GET, queryURL, parameters: [queryParamName: symptomName, accessTokenKey: accessToken])
            searchSymptomRequest!.responseJSON({ (request, response, symptomsData, error) -> Void in
                dispatch_group_leave(syncGroup)
                if error != nil {
                    partialErrors.append(NSError(domain: DoctorErrorDomain, code: DoctorError.SearchSymptomError.rawValue, userInfo: nil))
                    return
                }
                let symptoms = Doctor.parseSymptomsJSONDict(symptomsData)
                allSymptoms[symptomName] = symptoms
            })
        }
        dispatch_group_notify(syncGroup, dispatch_get_main_queue()) {
            if !partialErrors.isEmpty {
                allError = NSError(domain: DoctorErrorDomain, code: DoctorError.BatchError.rawValue, userInfo: [DoctorPartialErrorKey: partialErrors])
            }
            completion(allSymptoms: allSymptoms, error: allError)
        }
    }

    func diagnoseUser(user: User) {
        for i in 0..<5 {
            let test = DiagnoseTest(ID: i)
            if test != nil && find(user.tests, test!) == nil {
                user.tests.append(test!)
            }
        }
    }

    private class func parseSymptomsJSONDict(JSONDict: AnyObject?) -> [Symptom] {
        if let symptomsData: AnyObject = JSONDict {
            let symptoms = (symptomsData as [[String: AnyObject]]).filter {symptomDict -> Bool in
                return (symptomDict["c_type"]! as String) == "dx" || (symptomDict["c_type"]! as String) == "sx"
            }.map { (symptomDict: [String: AnyObject]) -> Symptom in
                    return Symptom(dictionary: symptomDict)
            }
            return symptoms
        } else {
            return [Symptom]()
        }
    }

}

extension NSError {
    func isRequestCancelledError() -> Bool {
        return code == -999
    }
}
