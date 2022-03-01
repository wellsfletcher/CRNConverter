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
    
    @State var terms: [Term] = [Term(id: "202202"), Term(id: "202108")]
    @State var selectedTermId: String = "202202"
    @State var areCoursesLoaded = false
    @State var areTermsLoaded = false
    
    var body: some View {
        NavigationView {
            VStack {
                List {
                    Picker("Choose a term", selection: $selectedTermId) {
                        ForEach(terms.reversed()) { term in
                            Text(term.name)// .padding()
                        }
                    }.onChange(of: selectedTermId) { newTerm in
                        // fix: don't refetch when you don't have to
                        self.areCoursesLoaded = false
                        print("fetching courses again")
                        fetchCourses()
                    }.padding()
                    TextField("Enter CRNs: ", text: $crnInput).padding()
                        .onChange(of: crnInput) { newValue in
                            print("updating courses")
                            updateCourses()
                        }
                    
                    SwiftUI.Section(content: {
                        ForEach (self.courses) { course in
                            VStack(alignment: .leading) {
                                Text(course.id + ": " + course.longTitle).font(.headline)
                                Text(course.description ?? "")
                            }.padding()
                        }
                    }, header: {
                        Text("Courses")
                    })
                }
                NavigationLink(destination: ChatsView(courses: $courses), label: {Text("Chat now!")})
                    .disabled(!areCoursesLoaded).padding()
                /*
                Button(action: {
                    // updateCourses()
                }, label: {
                    Text("Convert")
                }).disabled(!areCoursesLoaded).padding()*/
            }.navigationTitle("GT Study Buddy")
        }.onAppear {
            fetchTerms()
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
    
    func fetchTerms() {
        CourseDownloader.downloadTerms { terms in
            self.terms = terms
            self.areTermsLoaded = true
        }
    }
    
    func fetchCourses() {
        CourseDownloader.downloadCourses(searchTerm: selectedTermId) { (allCourses, crn2course) in
            self.allCourses = allCourses
            self.crn2course = crn2course
            self.areCoursesLoaded = true
            updateCourses()
        }
    }
    
    func updateCourses() {
        self.crns = getNumbers(self.crnInput)
        self.courses = crns2courses(self.crns)
    }
    
    func crns2courses(_ crns: [Int]) -> [Course] {
        var courses: [Course] = []
        
        // may also remove invalid CRNs from the crn list here to
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
