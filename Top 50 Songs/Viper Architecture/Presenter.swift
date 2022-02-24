//
//  Presenter.swift
//  Top 50 Songs
//
//  Created by Kaan TOKSOY on 22.02.2022.
//

import Foundation


enum FetchError: Error{
    case noInternet
    case urlIsBroken
}


protocol AppPresenter {
    var router : AppRouter? { get set }
    var interactor : AppInteractor? { get set }
    var view: AppView? { get set }
    
    func interactionDidFetchSongs(with result: Result<SongInfo, Error>)
    
    
}

class SongPresenter: AppPresenter{
    func interactionDidFetchSongs(with result: Result<SongInfo, Error>) {
        switch result{
        case.success(let songs):
            view?.update(with: songs)
        case.failure:
            view?.update(with: "Error while presenting songs")
        }
    }
    
    
    var interactor: AppInteractor? {
        didSet{
            interactor?.getAlbums()
        }
    }
    
    var view: AppView?
    
    var router: AppRouter?
    
    
}
