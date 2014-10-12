//
//  Symptom.swift
//  XPrize-New
//
//  Created by Sihao Lu on 9/10/14.
//  Copyright (c) 2014 DJ.Ben. All rights reserved.
//

import UIKit

class Symptom: NSObject, DictionaryLiteralConvertible, DebugPrintable, NSCoding, Equatable {
    let name: String
    let slug: String
    let brief: String?
    
    override var debugDescription: String {
        get {
            return "Symptom: {name: \(name), slug: \(slug), brief: \(brief)}"
        }
    }
    
    required init(name: String, slug: String, brief: String?) {
        self.name = name
        self.slug = slug
        self.brief = brief
    }
    
    required init(dictionaryLiteral elements: (String, String)...) {
        var name = ""
        var slug = ""
        for (let key, let value) in elements {
            if key == "name" {
                name = value
            } else if key == "slug" {
                slug = value
            } else if key == "brief" {
                self.brief = value
            }
        }
        self.name = name
        self.slug = slug
    }
    
    init(dictionary: [String: AnyObject?]) {
        self.name = (dictionary["name"]! as String)
        self.slug = (dictionary["slug"]! as String)
        self.brief = nil
        if dictionary["brief"] != nil && !(dictionary["brief"]! is NSNull) {
            self.brief = (dictionary["brief"]! as String)
        }
    }
    
    // MARK: NSCoding
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(name, forKey: "name")
        aCoder.encodeObject(slug, forKey: "slug")
        if let briefString = brief {
            aCoder.encodeObject(briefString, forKey: "brief")
        }
    }
    
    required init(coder aDecoder: NSCoder) {
        name = aDecoder.decodeObjectForKey("name") as String
        slug = aDecoder.decodeObjectForKey("slug") as String
        brief = aDecoder.decodeObjectForKey("brief") as? String
    }
}

func == (lhs: Symptom, rhs: Symptom) -> Bool {
    return lhs.slug == rhs.slug
}