//
//  Course.swift
//  ClassmateConnector
//
//  Created by Fletcher Wells on 2/21/22.
//

import Foundation

/*
 
 Course JSON Format
 
 "Course Name and Number": [
    "Long Title",
    {}, // sections
    [], // prereqs
    "Description"
 ]
 
 */

/*
 
 Section JSON Format
 
 "Section Letter": [
    "CRN",
    [],
    // a bunch of random numbers I don't understand
    1,
    4,
    ...
 ]
 
 */

struct Course: Identifiable, Codable {
    var id: String
    var longTitle = ""
    var description: String? = ""
    var sections: [Section] = []
    
    init(id: String, longTitle: String, description: String?) {
        self.id = id
        self.longTitle = longTitle
        self.description = description
    }
}
