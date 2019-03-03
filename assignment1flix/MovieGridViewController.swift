//
//  MovieGridViewController.swift
//  assignment1flix
//
//  Created by Dean Pektas on 3/3/19.
//  Copyright © 2019 dean. All rights reserved.
//

import UIKit
import AlamofireImage

class MovieGridViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var movies = [[String:Any]]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        
        layout.minimumLineSpacing = 4
        layout.minimumInteritemSpacing = 2
        
        let width = (view.frame.size.width - layout.minimumInteritemSpacing * 2) / 2
        layout.itemSize = CGSize(width: width, height: width * 3 / 2)

        
        
        let url = URL(string: "https://api.themoviedb.org/3/movie/297762/similar?api_key=4f56c62d303bb9a0c4aeb5ce81e5c2b6")!
        let request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 10)
        let session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
        let task = session.dataTask(with: request) { (data, response, error) in
            // This will run when the network request returns
            if let error = error {
                print(error.localizedDescription)
            } else if let data = data {
                let dataDictionary = try! JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]
                
                self.movies = dataDictionary["results"] as! [[String:Any]]
                
                
                self.collectionView.reloadData()
                print(self.movies)
                
                
            }
        }
        task.resume()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return movies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MovieGridCell", for: indexPath) as! MovieGridCell
        
        let movie = movies[indexPath.item]
        
        let baseUrl = "https://image.tmdb.org/t/p/w500"
        let posterPath = movie["poster_path"] as! String
        let posterUrl = URL(string: baseUrl + posterPath)
        
        cell.posterView.af_setImage(withURL: posterUrl!)
        
        return cell
    }
    

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        print("Loading the details screen collection view")
        
        //find the selected movie
        let cell = sender as! UICollectionViewCell
        let indexPath = collectionView.indexPath(for: cell)!
        let movie = movies[indexPath.item]
        
        
        //pass the selected movie to the collection view controller
        let collectionViewController = segue.destination as! MovieCollectionViewController
        collectionViewController.movie = movie
        
    }

}
