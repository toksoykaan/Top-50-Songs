//
//  SecondViewController.swift
//  Top 50 Songs
//
//  Created by Kaan TOKSOY on 24.02.2022.
//



//NOT WORKING
import UIKit

class SecondViewController: UIViewController{
    var genres : String? = ""
    var releaseDate : String? = ""
    var artistName : String? = ""
    var image : UIImage?
    
    var imageView: UIImageView {
        let imageView = UIImageView(image: image)
        // this enables autolayout for our imageView
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }
    
    var genresTextView: UITextView {
        let textView = UITextView()
        textView.text = genres
        textView.font = UIFont.boldSystemFont(ofSize: 18)
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.textAlignment = .center
        textView.isEditable = false
        textView.isScrollEnabled = false
        return textView
    }
    var releaseTextView: UITextView {
        let textView = UITextView()
        textView.text = genres
        textView.font = UIFont.boldSystemFont(ofSize: 18)
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.textAlignment = .center
        textView.isEditable = false
        textView.isScrollEnabled = false
        return textView
    }
    var artistNameTextView: UITextView {
        let textView = UITextView()
        textView.text = genres
        textView.font = UIFont.boldSystemFont(ofSize: 18)
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.textAlignment = .center
        textView.isEditable = false
        textView.isScrollEnabled = false
        return textView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // here's our entry point into our app
        view.addSubview(imageView)
        view.addSubview(genresTextView)
        view.addSubview(releaseTextView)
        view.addSubview(artistNameTextView)
       
    }
    

}
