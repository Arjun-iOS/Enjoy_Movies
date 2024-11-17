//
//  MoviePopularService.swift
//  Architecture_Demo_By_Arjun
//
//  Created by Arjun Thakur on 15/11/24.
//

import Foundation

enum PopularMoviesUrl {
    case popularMovieUrl //will do later customisation
}

protocol MoviePopularService {
    //associatedtype MoviesDataType
    func fetchPopularMovies(pageNumber: Int, completion: @escaping ([Any]?) -> Void)
}

class MoviePopularServiceImplmentation: MoviePopularService {
    
    let moviePopularUrl = "https://api.themoviedb.org/3/movie/popular?api_key=e7631ffcb8e766993e5ec0c1f4245f93&language=en-US&page=%@"
    
    let defaultSession = URLSession(configuration: .default)
    
    private var dataTask: URLSessionDataTask?
    
    var errorMessage = ""
        
    func fetchPopularMovies(pageNumber: Int, completion: @escaping ([Any]?) -> Void) {
        dataTask?.cancel()
        
        guard let url = URL(string: String(format: moviePopularUrl, "\(pageNumber)") ) else {
            return
        }
        
        dataTask = defaultSession.dataTask(with: url) { [weak self] data, response, error in
            defer {
                self?.dataTask = nil
            }
            
            if let error = error {
                self?.errorMessage += "DataTask error: " + error.localizedDescription + "\n"
            } else if let data = data {
                
                var response: [String: Any]?
                
                do {
                  response = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
                } catch _ as NSError {
                  return
                }
                
                guard let array = response!["results"] as? [Any] else {
                  return
                }
                
                DispatchQueue.main.async {
                    completion(array)
                }
            }
        }
        
        dataTask?.resume()
    }
}
