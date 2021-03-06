//
//  SuperheroViewController.swift
//  Flix
//
//  Created by Alvin Magee on 6/22/17.
//  Copyright © 2017 Alvin Magee. All rights reserved.
//

import UIKit
import AlamofireImage

class SuperheroViewController: UIViewController, UICollectionViewDataSource {

    @IBOutlet weak var superheroActivityIndicator: UIActivityIndicatorView!

    @IBOutlet weak var superheroCollectionView: UICollectionView!

    
    var movies: [[String: Any]] = []
    

    let alertController = UIAlertController(title: "Network Error", message: "Please Try again", preferredStyle: .actionSheet)
    
    var refreshControl: UIRefreshControl!


    
    override func viewDidLoad() {
        super.viewDidLoad()
                // Do any additional setup after loading the view.
        superheroCollectionView.dataSource = self
        
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(SuperheroViewController.didPullToRefresh(_:)), for: .valueChanged)
        superheroCollectionView.insertSubview(refreshControl, at: 0)
        
        let OKAction = UIAlertAction(title: "OK", style: .default) {(action) in
            self.fetchMovies()
        // add the OK action to the alert controller
        }
        self.alertController.addAction(OKAction)
        
        print ("right before fetch movies")
        fetchMovies()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return movies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = superheroCollectionView.dequeueReusableCell(withReuseIdentifier: "SuperheroCollectionViewCell", for: indexPath) as! SuperheroCollectionViewCell
        
        let movie = movies[indexPath.row]
        
        let posterPathString = movie["poster_path"] as! String
        let baseURLString = "https://image.tmdb.org/t/p/w500"
        let posterURL = URL(string: baseURLString + posterPathString)!
        cell.cellImageView.af_setImage(withURL: posterURL)
        
        return cell
    }
    
    func didPullToRefresh(_ refreshControl: UIRefreshControl) {
         self.superheroActivityIndicator.startAnimating()
        fetchMovies()
    }
        
    func fetchMovies() {
        let url = URL(string: "https://api.themoviedb.org/3/movie/297762/similar?api_key=9de51b38f7946867db601fbbff1cc7e5&language=en-US&page=1")!
            
        let request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 10)
            
        let session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
            
        let task = session.dataTask(with: request) { (data, response, error) in
                // This will run when the network request returns
            if let error = error {
                self.networkError()
                    
            } else if let data = data {
                let dataDictionary = try! JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]
                let movies = dataDictionary["results"] as! [[String: Any]]
                self.movies = movies
                self.superheroCollectionView.reloadData()
                 self.refreshControl.endRefreshing()
                 self.superheroActivityIndicator.stopAnimating()
            }
        }
        task.resume()
    }
        
    func networkError() {
        self.present(self.alertController, animated: true) {
                // optional code for what happens after the alert controller has finished presenting
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let cell = sender as! UICollectionViewCell
        if let indexPath = superheroCollectionView.indexPath(for: cell) {
            
            let movie = movies[indexPath.row]
            let detailViewController = segue.destination as! DetailViewController
            detailViewController.movie = movie
        }
    }


}
