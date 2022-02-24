//
//  Interactor.swift
//  Top 50 Songs
//
//  Created by Kaan TOKSOY on 22.02.2022.
//

import Foundation


protocol AppInteractor{
    var presenter : AppPresenter? {get set}
    
    func getAlbums()
    
}

class UserInteractor: AppInteractor{
    
    
    let url = URL(string: "https://rss.applemarketingtools.com/api/v2/us/music/most-played/50/albums.json")
    var presenter: AppPresenter?
    
    //IF INTERNET CONNECTION IS OK
    
    func getAlbums() {
        let task  = URLSession.shared.dataTask(with: url!) { [weak self] data, _, error in
            guard let data = data, error == nil else {
                self?.presenter?.interactionDidFetchSongs(with: .failure(FetchError.urlIsBroken))
                return
            }
            do{
                let entities = try JSONDecoder().decode(SongInfo.self, from: data)
                self?.presenter?.interactionDidFetchSongs(with: .success(entities))
            }catch{
                self?.presenter?.interactionDidFetchSongs(with: .failure(error))
        }
    }
        task.resume()
    }
    
}
