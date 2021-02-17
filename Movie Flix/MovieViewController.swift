//
//  ViewController.swift
//  Movie Flix
//
//  Created by Richard Basdeo on 2/10/21.
//

import UIKit
import AlamofireImage

class MovieViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    //array of dictionaries to hold the results from the api call
    var movies = [[String:Any]]()
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        //interact with the table view
        tableView.delegate = self
        tableView.dataSource = self
        
        //api call
        //Code provided by course portal
        let url = URL(string: "https://api.themoviedb.org/3/movie/now_playing?api_key=a07e22bc18f5cb106bfe4cc1f83ad8ed")!
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
            
            //update tableView with the new data
            self.tableView.reloadData()

           }
        }
        task.resume()
    }
    
    //how many rows we want
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //creting a cell for the table view
        let cell = tableView.dequeueReusableCell(withIdentifier: "MovieCell") as! MovieCell
        let movie = movies[indexPath.row]
        let title = movie["title"] as! String
        let synopis = movie["overview"] as! String
        
        //giving the particular cell at index path a title and synopsis
        cell.titleLabel.text = title
        cell.synopsisLabel.text = synopis
        
        //create the url for the image
        let baseURL = "https://image.tmdb.org/t/p/w185"
        let posterPath = movie["poster_path"] as! String
        let posterUrl = URL(string: baseURL + posterPath)
        
        //use third part library to download image and set imageView's picture
        cell.posterView.af_setImage(withURL: posterUrl!)
        
        return cell
        
    }
    
    //prepare for segue function
    //Need to know which movie was tapped on
    // When know which movie pass that movie to the DetailsViewController
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        //get the selected movie
        let cell = sender as! UITableViewCell
        let indexPath = tableView.indexPath(for: cell)!
        let movie = movies[indexPath.row]
        
        let detailsViewController = segue.destination as! MovieDetailsViewController
        detailsViewController.movie = movie
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

