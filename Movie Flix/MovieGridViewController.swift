//
//  MovieGridViewController.swift
//  Movie Flix
//
//  Created by Richard Basdeo on 2/16/21.
//

import UIKit
import AlamofireImage

class MovieGridViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    var movies = [[String:Any]]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout

        //spacing between the tows
        layout.minimumLineSpacing = 4
        layout.minimumInteritemSpacing = 4

        let width = (view.frame.size.width - layout.minimumInteritemSpacing * 2) / 3
        layout.itemSize = CGSize(width: width, height: width * 3 / 2)

        // Do any additional setup after loading the view.
        let url = URL(string: "https://api.themoviedb.org/3/movie/297762/similar?api_key=a07e22bc18f5cb106bfe4cc1f83ad8ed")!
        let request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 10)
        let session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
        let task = session.dataTask(with: request) { (data, response, error) in
           // This will run when the network request returns
           if let error = error {
              print(error.localizedDescription)
           } else if let data = data {
              let dataDictionary = try! JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]
            
            //save the results to my global array
            self.movies = dataDictionary["results"] as! [[String:Any]]
            self.collectionView.reloadData()
    }
}
        task.resume()
    }
        
    
    
    
    
    
    
}

extension MovieGridViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return movies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MovieGridCell", for: indexPath) as! MovieGridCell
        
        let movie = movies[indexPath.item]
        
        //create the url for the image
        let baseURL = "https://image.tmdb.org/t/p/w780"
        let posterPath = movie["poster_path"] as! String
        let posterUrl = URL(string: baseURL + posterPath)
        
        //use third part library to download image and set imageView's picture
        cell.posterView.af_setImage(withURL: posterUrl!)
        
        return cell
        
        
    }

}
