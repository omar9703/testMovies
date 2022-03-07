//
//  ViewController.swift
//  testmovie
//
//  Created by Omar Campos on 07/03/22.
//

import UIKit

class ViewController: UIViewController,UITableViewDelegate, UITableViewDataSource {
    
    
    @IBOutlet weak var tableMovie: UITableView!
    var loadin : LoadingView?
    var moviess = [movie]()
    override func viewDidLoad() {
        super.viewDidLoad()
        loadin = LoadingView()
        self.view.addSubview(loadin!)
        tableMovie.register(UINib(nibName: "MovieTableViewCell", bundle: nil), forCellReuseIdentifier: "cell")
        setData()
        // Do any additional setup after loading the view.
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    func setData()
    {
        if let u = UserDefaults.standard.string(forKey: "fecha")
        {
            
        }
        if let m = movieData.Getmovie()
        {
            moviess = m
            self.tableMovie.reloadData()
        }
        else
        {
        loadin?.showLoadingView()
        requestPetition(ofType: moviesRequest.self, typeRequest: .GET, url: "https://api.themoviedb.org/3/movie/top_rated?api_key=53a47f564a291acc8cc7ac8263eee18a") { code, data in
            switch code{
            case 200...299:
                self.moviess = data?.results ?? [movie]()
                self.moviess = Array(self.moviess[..<10])
                DispatchQueue.main.async {
                    for x in self.moviess
                    {
                        movieData.SaveUser(m: x)
                    }
                    self.loadin?.hideLoadingView()
                    self.tableMovie.reloadData()
                }
                break
            default :
                DispatchQueue.main.async {
                    self.loadin?.hideLoadingView()
                }
                break
            }
        }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return moviess.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? MovieTableViewCell else {
            return UITableViewCell()
        }
        cell.titulo.text = moviess[indexPath.row].title
        cell.fecha.text = "Fecha de lanzamiento: \(moviess[indexPath.row].release_date)"
        let url = URL(string: "https://image.tmdb.org/t/p/w500" + moviess[indexPath.row].poster_path)

        DispatchQueue.global().async {
            let data = try? Data(contentsOf: url!) //make sure your image in this url does exist, otherwise unwrap in a if let check / try-catch
            DispatchQueue.main.async {
                
                cell.imagen.image = resizeImage(image: UIImage(data: data!)!, targetSize: CGSize(width: 100, height: 100))
            }
        }
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "desc") as! DescripcionViewController
        vc.movi = moviess[indexPath.row]
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

func resizeImage(image: UIImage, targetSize: CGSize) -> UIImage {
    let size = image.size

    let widthRatio  = targetSize.width  / size.width
    let heightRatio = targetSize.height / size.height

    // Figure out what our orientation is, and use that to form the rectangle
    var newSize: CGSize
    if(widthRatio > heightRatio) {
        newSize = CGSize(width: size.width * heightRatio, height: size.height * heightRatio)
    } else {
        newSize = CGSize(width: size.width * widthRatio,  height: size.height * widthRatio)
    }

    // This is the rect that we've calculated out and this is what is actually used below
    let rect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)

    // Actually do the resizing to the rect using the ImageContext stuff
    UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
    image.draw(in: rect)
    let newImage = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()

    return newImage!
}
