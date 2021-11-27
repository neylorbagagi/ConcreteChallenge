//
//  Cache.swift
//  AfyaChallenge
//
//  Created by Neylor Bagagi on 04/10/21.
//  Copyright © 2021 Cyanu. All rights reserved.
//

import Foundation
import UIKit

/// That is only a Session Cache to provide a better experience
class Cache {

    static let share = Cache()
    var images = NSCache<AnyObject, UIImage>()
    var favourites: [Movie] = [] {
        didSet {
            self.notifyObservers(favourites)
        }
    }

    var observers = [(([Movie]) -> Void)]()

    private var documentsFolder: URL {
        return FileManager.default.urls(for: .documentDirectory, in: .allDomainsMask).first!
    }

    init() {
        do {
            self.favourites = try self.load()
        } catch let error {
            print("\(error)")
        }

    }

    func subscribe(_ observer: @escaping (([Movie]) -> Void) ) {
        self.observers.append(observer)
    }

    func notifyObservers(_ movies: [Movie]) {
        for observer in observers {
            observer(movies)
        }
    }

    private func load() throws -> [Movie] {
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

        self.favourites.append(movie)
    }

    func delete(movie: Movie) throws {
        let fileName = "\(movie.id).json"
        let destinationURL = self.documentsFolder.appendingPathComponent(fileName)

        if FileManager.default.fileExists(atPath: destinationURL.path) {
            try FileManager.default.removeItem(at: destinationURL)
        }

        self.favourites.removeAll(where: {$0.id == movie.id})
    }

    func checkFavouriteState(movie: Movie) -> Bool {
        return self.favourites.contains(where: { $0.id == movie.id})
    }
}
