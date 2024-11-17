//
//  MovieViewModel.swift
//  Architecture_Demo_By_Arjun
//
//  Created by Arjun Thakur on 15/11/24.
//

import Foundation
import UIKit

protocol MovieViewModel: class {
    
    var pageNumber : Int { get set }
    
    //Cache images
    var cache : NSCache<NSNumber, UIImage> { get}
    func upsertCache(with image: UIImage, for itemNumber :NSNumber)
    //load data functions
    func loadImage(with urlString: String, completion: @escaping (UIImage?) -> ())
    
    var moviePopularArray: [Any] { get }
    func fetchPopularMovies(pageNumber: Int, completion: @escaping ([Any]) -> Void)
}

class MovieViewModelImplementation: MovieViewModel {
    
    var pageNumber: Int
    
    var moviePopularArray: [Any] {
        return _moviePopularArray
    }
    
    private var _moviePopularArray: [Any] = []
    private var _popularService: MoviePopularService!
//    private var _movieDetailService: MovieDetailService!
    
    private let _cache = NSCache<NSNumber, UIImage>()
    private let imageUrl = "https://image.tmdb.org/t/p/%@%@"
    private let utilityQueue = DispatchQueue.global(qos: .utility)
    
    init(popularService: MoviePopularService) {
        self._popularService = popularService
        self.pageNumber = 1
    }
    
    func fetchPopularMovies(pageNumber: Int, completion: @escaping ([Any]) -> Void) {
        print("fetchPopularMovies at page number \(pageNumber)")
        _popularService.fetchPopularMovies(pageNumber: pageNumber) {[weak self] (jsonArray) in
            if let jsonArray = jsonArray {
                self?._moviePopularArray.append(contentsOf: jsonArray)
            }
            print(jsonArray)
            completion(jsonArray ?? [])
        }
    }
    
    ///
    /// caching
    ///
    var cache: NSCache<NSNumber, UIImage> {
        return _cache
    }
    
    ///
    /// update cache image
    ///
    func upsertCache(with image: UIImage, for itemNumber :NSNumber) {
        _cache.setObject(image, forKey: itemNumber)
    }
    
    // MARK: - Image Loading
    ///
    /// Loading image with URL String
    /// - Parameter urlString: string of the url image. completion: block callback uiimage
    ///
    func loadImage(with urlString: String, completion: @escaping (UIImage?) -> ()) {
        utilityQueue.async {

            guard let url = URL(string: String(format: self.imageUrl, "w154", urlString)), let data = try? Data(contentsOf: url) else {
                completion(nil)
                return
            }
            let image = UIImage(data: data)
            
            DispatchQueue.main.async {
                completion(image)
            }
        }
    }
}
