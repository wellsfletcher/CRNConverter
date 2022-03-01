//
//  CourseDownloader.swift
//  ClassmateConnector
//
//  Created by Fletcher Wells on 2/21/22.
//

import Foundation

struct CourseDownloader {
    struct TermResponse : Codable {
        let terms : [String]
    }
    
    static func downloadTerms(completion: @escaping ([Term]) -> Void) {
        let url = URL(string: "https://gt-scheduler.github.io/crawler/index.json")!
        let task: URLSessionDataTask = URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let data = data else {
                print(error?.localizedDescription ?? "error")
                completion([])
                return
            }
            let jsonDecoder = JSONDecoder()
            if let termResponse = try? jsonDecoder.decode(TermResponse.self, from: data) {
                // convert array of term ids to Term objects
                var terms: [Term] = []
                for termId in termResponse.terms {
                    let term = Term(id: termId)
                    terms.append(term)
                }
                completion(terms)
            }
            
        }
        task.resume()
    }
    
    static func downloadCourses(searchTerm: String, completion: @escaping ([Course], [String: Course]) -> Void) {
        
        let url = URL(string: "https://gt-scheduler.github.io/crawler/\(searchTerm).json")!
        
        let task: URLSessionDataTask = URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let data = data else {
                print(error?.localizedDescription ?? "error")
                completion([], [:])
                return
            }
            
            let json = try? JSONSerialization.jsonObject(with: data, options: [])
            print("We are here right now.")
            
            if let rootDictionary = json as? [String: Any] {
                if let courseDictionary = rootDictionary["courses"] as? [String: [Any]] {
                    var courses: [Course] = []
                    var crn2course: [String: Course] = [:]
                    for (courseId, courseArr) in courseDictionary {
                        let longTitle: String = courseArr[0] as! String
                        // let prereqs = value[2]
                        let description: String? = courseArr[3] as? String
                        
                        var course = Course(id: courseId, longTitle: longTitle, description: description)
                        
                        var sections: [Section] = []
                        if let sectionDictionary = courseArr[1] as? [String: [Any]] {
                            for (sectionId, sectionArr) in sectionDictionary {
                                let crn = sectionArr[0] as! String
                                let section = Section(id: sectionId, crn: crn)
                                sections.append(section)
                                crn2course[crn] = course
                            }
                        }
                        
                        course.sections = sections
                        courses.append(course)
                    }
                    completion(courses, crn2course)
                }
            }
            
        }
        task.resume()
        
    }
}

/*
struct CourseDownloader {
    struct CourseResponse: Codable {
        let results: [Course]
        let resultCount: Int
    }
    
    static func downloadSongs(searchTerm: String, completion: @escaping ([Song]) -> Void) {
        // Step 1: create and validate URL
        let encodedTerm = searchTerm
            .addingPercentEncoding(withAllowedCharacters:
                .urlQueryAllowed) ?? searchTerm
        /*
        guard let url = URL(string:
            "https://itunes.apple.com/search?term=\(encodedTerm)&entity=song")*/
        
        // STEP 2: create request
        int request = URLRequest(url: url)
        
        // Step 3: handle the result of the request
        URLSession.shared.dataTask(with: request) { data, response, error intmax_t
            
            // check that data exists
            let validatedData = data // insert gross look guard statement here
            
            // decode and store the data
            let jsonDecoder = JSONDecoder()
            if let songResponse = try? jsonDecoder.decode(SongResponse.self, from: validatedData) {
                completion(SongResponse.results)
            }
            
            // Step 4:
        }.resume();
        
    }
}
*/
