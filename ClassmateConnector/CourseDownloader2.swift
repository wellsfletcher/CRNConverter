//
//  CourseDownloader2.swift
//  ClassmateConnector
//
//  Created by Fletcher Wells on 2/23/22.
//

import Foundation

/*
struct Section: Codable {
    var title: String
}
 */

struct Course2: Codable {
    var title: String = ""
    var crn: Int = 0
    var sections: [Section] = []
}

struct CourseDownloader2 {
    struct CourseResponse : Codable {
        let courses : [Course2]
        let updatedAt : String
    }
    
    static func downloadCourses(searchTerm: String, completion: @escaping ([Course]) -> Void) {
        
        /*
        let encodedTerm = searchTerm.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? searchTerm
        let url = URL(string: "https://itunes.apple.com/search?term=\(encodedTerm)&entity=song")!
         */
        // https://itunes.apple.com/search?term=bird&entity=song
        /*
        let encodedTerm = searchTerm.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? searchTerm*/
        let encodedTerm = searchTerm
        let url = URL(string: "https://gt-scheduler.github.io/crawler/\(encodedTerm).json")!
        
        let task: URLSessionDataTask = URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let data = data else {
                print(error?.localizedDescription ?? "error")
                completion([])
                return
            }
            
            /*
            let jsonDecoder = JSONDecoder()
            if let songResponse = try? jsonDecoder.decode(CourseResponse.self, from: data) {
                
                
                completion(songResponse.results)
            }
            */
            
            let json = try? JSONSerialization.jsonObject(with: data, options: [])
            let jsonDecoder = JSONDecoder()
            
            print("We are here right now.")
            
            if let dictionary = json as? [String: Any] {
                /*
                if let number = dictionary["someKey"] as? Double {
                    // access individual value in dictionary
                }
                

                for (key, value) in dictionary {
                    // access all key / value pairs in dictionary
                }
                 */
                
                if let nestedDictionary = dictionary["courses"] as? [String: Any] {
                    // access nested dictionary values by key
                    var courses: [Course] = []
                    for (key, value) in nestedDictionary {
                        // access all key / value pairs in dictionary
                        // let course = Course(id: key, crn: 0, title: key)
                        // courses.append(course)
                        // print(key)
                    }
                    print(courses)
                    completion(courses)
                }
            }
            
        }
        task.resume()
        
    }
}
