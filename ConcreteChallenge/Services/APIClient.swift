//
//  APIClient.swift
//  ConcreteChallenge
//
//  Created by Neylor Bagagi on 01/11/21.
//

import Foundation

enum APIClientEndpoints:String {
    case movies = "/3/movie/popular"
    case genres = "/3/genre/movie/list"
}

class APIClient:NSObject {
    
    
    /// TODO: Append api version directly to host
    static let share = APIClient()
    private let scheme = "https"
    private let host = "api.themoviedb.org"
    private let api_version = "/3/"
    private var api_key:String = ""
    private var requestComponets:URLComponents = URLComponents()
    
    
    override init() {
        
        /// Protecting my APIKEY, so I look for my .getingore file call Keys.plist
        /// If it does not exist apply the self.apikey as set before
        if let path = Bundle.main.path(forResource: "Keys", ofType: "plist") {
            guard let keys = NSDictionary(contentsOfFile: path) else { return }
            self.api_key = keys["apikey"] as! String
        }
        
        self.requestComponets.scheme = self.scheme
        self.requestComponets.host = self.host
        self.requestComponets.queryItems = [
                URLQueryItem(name: "api_key", value: self.api_key)
             ]
        
    }
    
    
    
    private func request<T:Codable>(url:URL, type:T.Type, completion: @escaping (Result<T, Error>) -> Void){
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard error == nil else {
                completion(.failure(error!))
                return
            }

            do{
                let decoder = JSONDecoder()
                let decodedData = try decoder.decode(T.self, from: data!)
                completion(.success(decodedData))
            } catch let error {
                completion(.failure(error))
            }
        }.resume()
        
    }
    
    func getMovies(forPage page:String, completion: @escaping (_ data:[Movie], _ error:Error?) -> Void) {

        self.requestComponets.path = APIClientEndpoints.movies.rawValue
        self.requestComponets.queryItems?.append(URLQueryItem(name: "page", value: page))
        
        guard let url = self.requestComponets.url else {
            completion([],URLError(.badURL))
            return
        }
        
        self.request(url: url, type:MoviesRequestResult.self) { (result) in
            switch result{
                case .success(let data):
                    completion(data.results, nil)
                case .failure(let error):
                    completion([], error)
            }
        }
    }
    
    
//    /// This function is only responsible for execute the api requests
//    /// - Parameters:
//    ///     - url: `URL()`
//    /// - Returns:
//    ///     - data: Data?,
//    ///     - response: Response?,
//    ///     - error: Error?
//    private func apiRequest<T:Codable>(url:URL, type:T.Type, completion: @escaping (_ data:T?,_ response:URLResponse?,_ error:Error?) -> Void){
//
//        URLSession.shared.dataTask(with: url) { (data, response, error) in
//            guard error == nil else {
//                completion(nil,nil,error)
//                return
//            }
//
//            do{
//                let decoder = JSONDecoder()
//                let decodedData = try decoder.decode(T.self, from: data!)
//                completion(decodedData,nil, nil)
//            } catch let error {
//                completion(nil,nil,error)
//            }
//        }.resume()
//    }
//
//    func getMovies(forPage page:String, completion: @escaping (_ data:[Movie], _ error:Error?) -> Void) {
//
//
//        self.requestComponets.path = Endpoints.movies.rawValue
//        self.requestComponets.queryItems = [
//                URLQueryItem(name: "api_key", value: self.api_key),
//                URLQueryItem(name: "page", value: page)
//             ]
//
//        guard let url = self.requestComponets.url else {
//            completion([], APIClientError.invalidURL(reason: "\(String(describing: self.requestComponets.url)) is not a valid URL"))
//            return
//
//        }
//
//        self.apiRequest(url: url, type:[Movie].self) { (data, response, error) in
//            guard let data = data, error == nil else {
//                completion([],error)
//                return
//            }
//            completion(data,nil)
//        }
//    }
}
