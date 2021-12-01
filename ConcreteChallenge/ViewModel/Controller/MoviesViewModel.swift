//
//  MoviesViewModel.swift
//  ConcreteChallenge
//
//  Created by Neylor Bagagi on 01/11/21.
//

import Foundation
import UIKit

class MoviesViewModel: NSObject {

    var data: Bindable<[Movie]> = Bindable<[Movie]>([])
    private var dataCache: [Movie] = []
    private var isSearching: Bool = false
    private var pageToRequest = 1
    private var reachPageLimit: Bool = false
    var isReachPageLimit: Bool { return reachPageLimit }

    func requestData() {

        if !self.isSearching && !self.reachPageLimit {
            APIClient.share.getMovies(forPage: "\(self.pageToRequest)") { (result) in
                switch result {
                case .success(let data):
                    if !data.isEmpty {
                        self.pageToRequest += 1
                    }
                    self.dataCache.append(contentsOf: data)
                    self.data.value!.append(contentsOf: data)

                case .failure(let error):
                    print("\(error.localizedDescription)")
                    if error.localizedDescription.contains("(422)") {
                        self.reachPageLimit = true
                    }
                    self.data.value?.append(contentsOf: [])
                }
            }
        }
    }

    func restoreData() {
        self.data.value = self.dataCache
    }

    func searchData(searchText: String) {
        self.isSearching = true
        self.data.value = self.dataCache.filter({$0.title.contains(searchText)})

        if searchText == "" {
            self.restoreData()
        }
    }

    func stopSearchData() {
        self.isSearching = false
        self.restoreData()
    }

    func collectionSelectedData(_ indexPath: IndexPath) -> Movie? {
        guard let movie = self.data.value?[indexPath.row] else {
            print("Register not found")
            return nil
        }
        return movie
    }
}

extension MoviesViewModel: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        self.data.value?.count ?? 0
    }

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "movieCollectionCell",
                                                      for: indexPath) as? MovieCollectionViewCell

        let viewModel = MovieCellViewModel(movie: self.data.value![indexPath.row])

        // Here was to use an Method Dependency Injection
        cell?.configure(viewModel: viewModel)
        return cell ?? UICollectionViewCell()
    }

    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String,
                        at indexPath: IndexPath) -> UICollectionReusableView {
        let view = collectionView.dequeueReusableSupplementaryView(ofKind: "bottom",
                                                                   withReuseIdentifier: "viewForSupplementary",
                                                                   for: indexPath) as? SupplementaryReusableView

        if !self.reachPageLimit {
            view?.configure(style: .requestingData)
        } else {
            view?.configure(style: .reachedDataLimit)
        }

        return view ?? UICollectionReusableView()
    }
}
