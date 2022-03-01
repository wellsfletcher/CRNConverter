//
//  Term.swift
//  ClassmateConnector
//
//  Created by Fletcher Wells on 2/21/22.
//

import Foundation

struct Term: Identifiable, Hashable {
    var id: String
    var name: String {
        get {
            let year: String = String(id.prefix(4))
            let month: String = String(id.suffix(2))
            var semester = ""
            
            if (month == "02") {
                semester = "Spring"
            } else if (month == "05") {
                semester = "Summer"
            } else if (month == "08") {
                semester = "Fall"
            }
            
            var term = year
            if !semester.isEmpty {
                term = semester + " " + year
            }
            
            return term
        }
    }
}
