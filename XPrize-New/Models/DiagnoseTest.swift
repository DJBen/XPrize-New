//
//  DiagnoseTest.swift
//  XPrize-New
//
//  Created by Sihao Lu on 10/3/14.
//  Copyright (c) 2014 DJ.Ben. All rights reserved.
//

import UIKit

var rawTestList: NSArray?

let diagnoseTestNames = ["Urinary Tract Infection", "Cholesterol", "Strep Infection", "Mononucleosis Infection", "Sleep Apnea"]

class DiagnoseTest: NSObject, Equatable {
    enum TestType: Int {
        case UrinaryTractInfection = 0
        case Cholesterol
        case StrepInfection
        case MononucleosisInfection
        case SleepApnea
    }

    let typeCount = 5

    enum TestResult {
        case Unknown
        case Positive
        case Negative
    }
    private(set) var type: TestType
    private(set) var result: TestResult = .Unknown
    private(set) var shortDescription: String?
    private(set) var longDescription: String?
    private(set) var steps = [String]()
    private(set) var stepImages = [UIImage]()
    private(set) var testInfo: NSDictionary?
    var name: String {
        get {
            return diagnoseTestNames[type.rawValue]
        }
    }

   class func preloadDataFileWithPath(path: String) -> Bool {
       rawTestList = NSArray(contentsOfFile: path)
       return rawTestList != nil
   }

    init(type: TestType) {
       self.type = type
       super.init()
    }

    init?(ID: Int) {
        self.type = TestType(rawValue: ID)!
        super.init()
        if rawTestList == nil {
           return nil
        }
        if ID < 0 || ID >= rawTestList!.count {
           return nil
        }
        let testData = rawTestList![ID] as NSDictionary
        shortDescription = (testData["shortDescription"] as? String)
        longDescription = (testData["longDescription"] as? String)
        if let rawSteps = testData["stepText"] as? [String] {
            steps = rawSteps
        }
        if let stepImageNames = testData["stepImages"] as? [String] {
            for imageName in stepImageNames {
                if let image = UIImage(named: imageName) {
                    stepImages.append(image)
                }
            }
        }
    }

    func imageAtStep(step: Int) -> UIImage? {
        if step < 0 || step >= stepImages.count {
            return nil
        }
        return stepImages[step]
    }
}

func == (lhs: DiagnoseTest, rhs: DiagnoseTest) -> Bool {
    return lhs.type == rhs.type
}
