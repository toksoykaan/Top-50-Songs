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

class SongsViewController: UIViewController, AppView, UITableViewDelegate, UITableViewDataSource{
    var songs : SongInfo?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(tableView)
        
        view.backgroundColor = .systemMint
        tableView.delegate = self
        tableView.dataSource = self
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
        
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = songs?.feed.results[indexPath.row].name
        
        
        do {
            let url = URL(string: String(songs?.feed.results[indexPath.row].artworkUrl100 ?? "arbitrary"))
            let data = try Data(contentsOf: (url)!)
            cell.imageView!.image = UIImage(data: data)
        }
        catch{
            print(error)
        }
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (songs?.feed.results.count ?? 50)
    }
    
    var presenter: AppPresenter?
    
    let tableView : UITableView = {
        let table = UITableView()
        table.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return table
    }()
    
    
    
    func update(with songs: SongInfo) {
        DispatchQueue.main.async {
            self.songs = songs
            self.tableView.reloadData()
            self.tableView.isHidden = false
        }
    }
    
    func update(with error: String) {
        let alert = UIAlertController(title: "Something went wrong", message: error, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    
}
