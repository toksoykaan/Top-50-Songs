//
//  View.swift
//  Top 50 Songs
//
//  Created by Kaan TOKSOY on 22.02.2022.
//

import Foundation
import UIKit



protocol AppView{
    var presenter: AppPresenter? {get set}
    
    func update(with songs: SongInfo) // Interactor'dan akan bilgiyi buraya çekmek için kullandığımız fonksiyonlar
    func update(with error: String) //Error message TBD later
}

class SongsViewController: UIViewController, AppView, UITableViewDelegate, UITableViewDataSource, UISearchResultsUpdating, UISearchBarDelegate{
    
    var songs : SongInfo?
    var images : [String: Data] = [:] //Caching the images to reduce Network usage and UI Image Load Delay
    var presenter: AppPresenter?
    var imageCache = NSCache<NSIndexPath,NSData>()
    let refreshControl = UIRefreshControl()
    
    var searchArray : [Results] = []
    var tableArray : [Results]  = []
    override func viewDidLoad() {
        super.viewDidLoad()
        //Table View Functionality
        
        view.addSubview(tableView)
        
        tableView.delegate = self
        tableView.dataSource = self
        self.navigationItem.title = "Top 50 Albums"
        
        // Search Functionality
        navigationItem.searchController = searchController
        searchController.searchResultsUpdater = self
        initSearchController()
        
        refreshControl.attributedTitle = NSAttributedString(string: "Refreshing")
        
           refreshControl.addTarget(self, action: #selector(self.refresh(_:)), for: .valueChanged)
           tableView.addSubview(refreshControl) // not required when using UITableViewController
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
        
    }
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        if !isSearching {
            DispatchQueue.main.async { [self] in
            cell.textLabel?.text = songs?.feed.results[indexPath.row].name
            
            cell.textLabel?.numberOfLines = 0
            //Cached the downloading data
            if let data = imageCache.object(forKey: indexPath as NSIndexPath){
                cell.imageView!.image = UIImage(data: data as Data)
            }else{
            do {
                let url = URL(string: String(songs?.feed.results[indexPath.row].artworkUrl100 ?? "arbitrary"))
                let data = try Data(contentsOf: (url)!)
                imageCache.setObject(data as NSData, forKey: indexPath as NSIndexPath)
                cell.imageView!.image = UIImage(data: data)
            }
            catch{
                print(error)
                }
                    }
            }
            return cell
        }else{
            DispatchQueue.main.async { [self] in
                print(searchArray.count)
                print(indexPath.row)
            cell.textLabel?.text = searchArray[indexPath.item].name
            do {
                let url = URL(string: searchArray[indexPath.item].artworkUrl100)
                let data = try Data(contentsOf: (url)!)
                cell.imageView!.image = UIImage(data: data)
            }
            catch{
                print(error)
                }
            
            }
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = SecondViewController()
        vc.artistName = songs?.feed.results[indexPath.row].artistName
        vc.genres = songs?.feed.results[indexPath.row].genres[0].name
        vc.releaseDate = songs?.feed.results[indexPath.row].releaseDate
        do {
            let url = URL(string: String(songs?.feed.results[indexPath.row].artworkUrl100 ?? "arbitrary"))
            let data = try Data(contentsOf: (url)!)
            vc.image = UIImage(data: data)
        }
        catch{
            print(error)
        }
        self.present(vc, animated: true, completion: nil)
        
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (songs?.feed.results.count ?? 50)
    }
    
    
    
    let tableView : UITableView = {
        let table = UITableView()
        table.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return table
    }()
    
    @objc func refresh(_ sender: AnyObject) {
        imageCache.removeAllObjects()
        viewDidLoad()
        
        refreshControl.endRefreshing()
    }
    
    func update(with songs: SongInfo) {
        DispatchQueue.main.async {
            self.songs = songs
            for i in 0...49{
                self.tableArray.append(songs.feed.results[i])
            }
            self.tableView.reloadData()
        }

    }
    
    func update(with error: String) {
        let alert = UIAlertController(title: "Something went wrong", message: error, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    //Search functionality
    
    let searchController = UISearchController(searchResultsController: nil)
    var isSearching = false
    
    func initSearchController(){
        searchController.loadViewIfNeeded()
        searchController.searchResultsUpdater = self
        searchController.searchBar.placeholder = "Search"
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.enablesReturnKeyAutomatically = false
        searchController.searchBar.returnKeyType = UIReturnKeyType.done
        definesPresentationContext = true
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        searchController.searchBar.delegate = self
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        
            let searchText = searchController.searchBar.text!
            if !searchText.isEmpty{
                isSearching = true
                searchArray.removeAll()
                for cellInfo in tableArray{
                    if cellInfo.name.lowercased().contains(searchText.lowercased()){
                        searchArray.append(cellInfo)
                    }
                }
            }else{
                isSearching = false
                searchArray.removeAll()
                searchArray = tableArray
                
            }
        
        tableView.reloadData()
        
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        isSearching = false
        tableView.reloadData()
        
    }
    

}
