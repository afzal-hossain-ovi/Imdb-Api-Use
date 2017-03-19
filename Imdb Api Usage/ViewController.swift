//
//  ViewController.swift
//  Imdb Api Usage
//
//  Created by Md AfzaL Hossain on 3/16/17.
//  Copyright © 2017 Md AfzaL Hossain. All rights reserved.
//

import UIKit

class ViewController: UIViewController,UISearchBarDelegate {

    @IBOutlet weak var searchBar: UISearchBar!
  
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var actorNameLbl: UILabel!
    @IBOutlet weak var directorNameLbl: UILabel!
    @IBOutlet weak var movieRatingLbl: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        searchBar.delegate = self
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchMovie(title: searchBar.text!)
        searchBar.text = ""
    }
    
    func searchMovie(title: String) {
        if let movie = title.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed) {
        let url = URL(string: "http://www.omdbapi.com/?t=\(movie)")
        let dataTask = URLSession.shared.dataTask(with: url!) { (data, response, error) in
            if error != nil {
                print("error")
            }else {
                if data != nil {
                    do {
                      let jsonResult = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers) as AnyObject
                        
                        if let poster = jsonResult["Poster"] as? String {
                            let posterUrl = URL(string: poster)
                            DispatchQueue.main.async(execute: {
                                do {
                                    let data = try Data(contentsOf: posterUrl!)
                                    DispatchQueue.main.async(execute: {
                                        self.imgView.image = UIImage(data: data)
                                    })
                                }catch {
                                    print(error.localizedDescription)
                                }
                                
                            })
                        }
                        if let title = jsonResult["Title"] as? String {
                            DispatchQueue.main.async(execute: { 
                                self.titleLbl.text = title
                            })
                        }
                        if let actors = jsonResult["Actors"] as? String {
                            DispatchQueue.main.async(execute: { 
                                self.actorNameLbl.text = actors
                            })
                        }
                        if let director = jsonResult["Director"] as? String {
                            DispatchQueue.main.async(execute: {
                                self.directorNameLbl.text = director
                            })
                        }
                        if let rating = jsonResult["imdbRating"] as? String {
                            DispatchQueue.main.async(execute: {
                                self.movieRatingLbl.text = rating
                            })
                        }
                       
                    }catch {
                        print(error.localizedDescription)
                    }
                }
            }
        }
        dataTask.resume()
        }
        
    }

}

