//
//  User.swift
//  XPrize-New
//
//  Created by Sihao Lu on 9/25/14.
//  Copyright (c) 2014 DJ.Ben. All rights reserved.
//

import UIKit

let UserSymptomsKey = "UserSymptoms"

class User: NSObject {
    private(set) var symptoms = [Symptom]()
    var tests = [DiagnoseTest]()

    class var currentUser : User {
        struct Static {
            static let instance : User = User()
        }
        return Static.instance
    }

    override init() {
        super.init()
        loadPrevious()
    }

    func loadPrevious() {
        if let archivedSymptoms = NSUserDefaults.standardUserDefaults().objectForKey(UserSymptomsKey) as? [NSData] {
            symptoms = archivedSymptoms.map { (symptomData) -> Symptom in
                return NSKeyedUnarchiver.unarchiveObjectWithData(symptomData) as Symptom
            }
        }
    }

    func addSymptom(symptom: Symptom) {
        if find(symptoms, symptom) == nil {
            symptoms.append(symptom)
            synchronizeSymptomsWithLocalStorage()
        }
    }

    func removeSymptom(symptom: Symptom) {
        if let index = find(symptoms, symptom) {
            symptoms.removeAtIndex(index)
            synchronizeSymptomsWithLocalStorage()
        }
    }

    private func synchronizeSymptomsWithLocalStorage() {
        let archivedSymptoms = symptoms.map { (symptom) -> NSData in
            return NSKeyedArchiver.archivedDataWithRootObject(symptom)
        }
        NSUserDefaults.standardUserDefaults().setObject(archivedSymptoms, forKey: UserSymptomsKey)
        NSUserDefaults.standardUserDefaults().synchronize()
    }
}

extension Symptom {
    var chosen: Bool {
        get {
            return find(User.currentUser.symptoms, self) != nil
        }
        set {
            if newValue {
                User.currentUser.addSymptom(self)
            } else {
                User.currentUser.removeSymptom(self)
            }
        }
    }
}
