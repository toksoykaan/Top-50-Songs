//
//  Entity.swift
//  Top 50 Songs
//
//  Created by Kaan TOKSOY on 22.02.2022.
//

import Foundation

// Application's Model Basically, Formed based on API's structre

struct SongInfo : Codable {
    let feed: Feed
}

struct Feed : Codable{
    let results : [Results]
}

struct Results : Codable{
    let name : String
    let genres : [Genres]
    let releaseDate : String
    let artistName : String
    let artworkUrl100 : String //Picture
}

struct Genres : Codable {
    let name : String //Genre name comes from results[0].genres[0] !
}

//feed.results[0].genres[0].name
//feed.results[0].releaseDate
//feed.results[0].artistName
//feed.results[0].artworkUrl100
//feed.results[0].name

