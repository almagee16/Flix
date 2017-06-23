//
//  DetailViewController.swift
//  Flix
//
//  Created by Alvin Magee on 6/21/17.
//  Copyright © 2017 Alvin Magee. All rights reserved.
//

import UIKit

enum MovieKeys{
    static let title = "title"
    static let release = "release_date"
    static let overview = "overview"
    static let backdropPath = "backdrop_path"
    static let posterPath = "poster_path"
}

class DetailViewController: UIViewController {

    @IBOutlet weak var backdropImageView: UIImageView!
    
    @IBOutlet weak var posterImageView: UIImageView!
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var releaseDateLabel: UILabel!
    
    @IBOutlet weak var overviewLabel: UILabel!
    
    var movie: [String: Any]?
    
    let baseURL = "https://www.youtube.com/watch?v="
    var movieURL = ""
    var newURL = ""

    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let movie = movie{
            titleLabel.text = movie[MovieKeys.title] as? String
            releaseDateLabel.text = movie[MovieKeys.release] as? String
            overviewLabel.text = movie[MovieKeys.overview] as? String
            let backdropPathString = movie[MovieKeys.backdropPath] as! String
            let posterPathString = movie[MovieKeys.posterPath] as! String
            let baseURLString = "https://image.tmdb.org/t/p/w500"
            
            
            let backdropURL = URL(string: baseURLString + backdropPathString)!
            backdropImageView.af_setImage(withURL: backdropURL)
            
            
            let posterPathURL = URL(string: baseURLString + posterPathString )!
            posterImageView.af_setImage(withURL: posterPathURL)
        }
        
        let movieID = movie!["id"] as! Int
        
        
        let url = URL(string: "https://api.themoviedb.org/3/movie/\(movieID)/videos?api_key=9de51b38f7946867db601fbbff1cc7e5&language=en-US")!
        
        let request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 10)
        
        let session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
        
        let task = session.dataTask(with: request) { (data, response, error) in
            // This will run when the network request returns
            if let error = error {
                // self.networkError()
                
            } else if let data = data {
                
                let dataDictionary = try! JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]
                let results = dataDictionary["results"] as! NSArray
                let dictResults = results[0] as! [String: Any]
                self.movieURL = dictResults["key"] as! String
                self.newURL = self.baseURL + self.movieURL
                //                let movies = dataDictionary["results"] as! [[String: Any]]
                //                self.movies = movies
                //                self.tableView.reloadData()
                //                self.refreshControl.endRefreshing()
                //                self.activityIndicator.stopAnimating()
                
            }
        }
        task.resume()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
   
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let controller = segue.destination as! VideoViewController
        controller.videoURL = newURL
       
        
    }
 

}
