//
//  StorageManager.swift
//  ConcreteChallenge
//
//  Created by Neylor Bagagi on 07/11/21.
//

import Foundation

class StorageManager {
    
    static let share = StorageManager()
    
    func load<T: Decodable>(_ filename: String) -> T {
        let data: Data

        guard let file = Bundle.main.url(forResource: filename, withExtension: nil)
        else {
            fatalError("Couldn't find \(filename) in main bundle.")
        }

        do {
            data = try Data(contentsOf: file)
        } catch {
            fatalError("Couldn't load \(filename) from main bundle:\n\(error)")
        }

        do {
            let decoder = JSONDecoder()
            return try decoder.decode(T.self, from: data)
        } catch {
            fatalError("Couldn't parse \(filename) as \(T.self):\n\(error)")
        }
    }
    
    
    
    var documentsFolder:URL {
        return FileManager.default.urls(for: .documentDirectory, in: .allDomainsMask).first!
    }
    
    func listMovies() throws -> [Movie] {
        // Get the list of files in the documents directory
        let contents = try FileManager.default
            .contentsOfDirectory(at: self.documentsFolder,
         includingPropertiesForKeys: nil)
        
        // Get all files whose path extension is 'json',
        // load them as data, and decode them from JSON
        return try contents.filter { $0.pathExtension == "json" }
            .map { try Data(contentsOf: $0) }
            .map { try JSONDecoder().decode(Movie.self, from: $0) }
    }
    
    func save(movie: Movie) throws {
        let movieData = try JSONEncoder().encode(movie)
        
        let fileName = "\(movie.id).json"
        let destinationURL = self.documentsFolder.appendingPathComponent(fileName)
        
        try movieData.write(to: destinationURL)
    }
    
    func delete(movie: Movie) throws {
        let fileName = "\(movie.id).json"
        let destinationURL = self.documentsFolder.appendingPathComponent(fileName)
        
        if FileManager.default.fileExists(atPath: destinationURL.path) {
            try FileManager.default.removeItem(at: destinationURL)
        }
    }
    
    func checkMovieFavouriteState(movie:Movie) -> Bool {
        var response:Bool = false
        
        do {
            response = try self.listMovies().contains(where: { $0.id == movie.id})
        } catch let error {
            print("\(error)")
        }
        
        return response
    }
    
    func getMovies(byPage page:Int, completion: @escaping (_ data:[Movie],_ error:Error?) -> Void){

        APIClient.share.getMovies(forPage: "\(page)") { (data, error) in
            guard error == nil else {
                completion([], error)
                return
            }
            
            completion(data,nil)
        }
        
    }
    
    
}
