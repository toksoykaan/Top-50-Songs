//
//  Router.swift
//  Top 50 Songs
//
//  Created by Kaan TOKSOY on 22.02.2022.
//

import Foundation
import UIKit

// Application's entry point declaration to be used in SceneDelegate

typealias EntryPoint = AppView & UIViewController

protocol AppRouter{
    var entryView : EntryPoint? {get}
    
    static func start() -> AppRouter
}

class SongsRouter : AppRouter{
    var entryView: EntryPoint?
    
    static func start() -> AppRouter {
        let router = SongsRouter()
        
        var view : AppView = SongsViewController()
        var presenter: AppPresenter = SongPresenter()
        var interactor: AppInteractor = UserInteractor()
        
        view.presenter = presenter
        
        interactor.presenter = presenter
        
        presenter.router = router
        presenter.view = view
        presenter.interactor = interactor
        
        router.entryView = view as? EntryPoint
        
        return router
    }
}

