//
//  ContentView.swift
//  ClassmateConnector
//
//  Created by Fletcher Wells on 2/21/22.
//

import SwiftUI

struct ContentView: View {
    @State var crnInput: String = "26945, 32615, 33231, 26340, 30709, 28845"
    @State var crns: [Int] = []
    @State var courses: [Course] = []
    
    @State var allCourses: [Course] = []
    @State var crn2course: [String: Course] = [:]
    
    @State var terms: [Term] = [Term(id: "202202", name: "Spring 2022"), Term(id: "202108", name: "Fall 2021")]
    @State var selectedTerm: Term = Term(id: "202202", name: "Spring 2022")
    @State var areCoursesLoaded = false
    
    var body: some View {
        NavigationView {
            VStack {
                Picker("Choose a term", selection: $selectedTerm) {
                    ForEach(terms) { term in
                        Text(term.name).padding()
                    }
                }.padding()
                TextField("Enter CRNs: ", text: $crnInput).padding()
                List {
                    ForEach (self.courses) {
                        course in
                        let str = course.longTitle + ". " + (course.description ?? "")
                        Text(course.id + ": " + str).padding()
                    }
                }
                Button(action: {
                    self.crns = getNumbers(self.crnInput)
                    self.courses = crns2courses(self.crns, self.selectedTerm)
                }, label: {
                    Text("Convert")
                }).disabled(!areCoursesLoaded).padding()
            }.navigationTitle("GT Study Buddy")
        }.onAppear {
            fetchCourses()
        }
    }
    
    func getNumbers(_ csv: String) -> Array<Int> {
        return csv
            .components(separatedBy: ",")
            .flatMap {
                Int($0.trimmingCharacters(in: .whitespaces))
            }
    }
    
    func fetchCourses() {
        CourseDownloader.downloadCourses(searchTerm: selectedTerm.id) { (allCourses, crn2course) in
            self.allCourses = allCourses
            self.crn2course = crn2course
            
            self.areCoursesLoaded = true
            // self.courses = allCourses
        }
    }
    
    func crns2courses(_ crns: [Int], _ term: Term) -> [Course] {
        var courses: [Course] = []
        
        /*
        guard let url = URL(string: "https://gt-scheduler.github.io/crawler/" + term.id + ".json") else {
            return courses
        }
         */
        for crn in crns {
            if let course = crn2course[String(crn)] {
                courses.append(course)
            }
        }
        
        return courses
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
