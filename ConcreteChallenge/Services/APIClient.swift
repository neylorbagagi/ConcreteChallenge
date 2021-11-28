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

enum APIClientErrors:Error,LocalizedError {
    
    case invalidAPIKey
    case pageRequestLimit
    
    public var errorDescription: String? {
        switch self {
        case .invalidAPIKey:
            return NSLocalizedString("(401) Invalid API key: You must be granted a valid key.", comment: "My error")
        case .pageRequestLimit:
            return NSLocalizedString("(422) page must be less than or equal to 500.", comment: "My error")
        }
    }
}

class APIClient:NSObject {
    
    
    /// ??? Append api version directly to host
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
            
            guard let response = response as? HTTPURLResponse else {
                completion(.failure(error!))
                return
            }
            
            switch response.statusCode {
                case 401:
                    completion(.failure(APIClientErrors.invalidAPIKey))
                    return
                case 422:
                    completion(.failure(APIClientErrors.pageRequestLimit))
                    return
                default:
                    break
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
    
    func getMovies(forPage page:String, completion: @escaping (Result<[Movie], Error>) -> Void) {

        self.requestComponets.path = APIClientEndpoints.movies.rawValue
        self.requestComponets.queryItems?.append(URLQueryItem(name: "page", value: page))
        
        guard let url = self.requestComponets.url else {
            completion(.failure(URLError(.badURL)))
            return
        }
        
        self.request(url: url, type:MoviesRequestResult.self) { (result) in
            switch result{
                case .success(let data):
                    completion(.success(data.results))
                case .failure(let error):
                    completion(.failure(error))
            }
        }
    }
    
    func getMoviesMock(forPage page:String, completion: @escaping (Result<[Movie], Error>) -> Void) {

        let data: Data
        
        switch page {
        case "1":
            data = StorageManager.share.loadData("jsonData1.json")
        case "2":
            data = StorageManager.share.loadData("jsonData2.json")
        case "3":
            data = StorageManager.share.loadData("jsonData3.json")
        default:
            data = StorageManager.share.loadData("jsonData4.json")
        }
        
        do{
            let decoder = JSONDecoder()
            let decodedData = try decoder.decode(MoviesRequestResult.self, from: data)
            completion(.success(decodedData.results))
        } catch let error {
            completion(.failure(error))
        }
    }
    
    func getGenres(completion: @escaping (Result<[Genre], Error>) -> Void) {

        self.requestComponets.path = APIClientEndpoints.genres.rawValue
        
        guard let url = self.requestComponets.url else {
            completion(.failure(URLError(.badURL)))
            return
        }
        
        self.request(url: url, type:GenreRequestResult.self) { (result) in
            switch result{
                case .success(let data):
                    completion(.success(data.genres))
                case .failure(let error):
                    completion(.failure(error))
            }
        }
    }
    
    
}
