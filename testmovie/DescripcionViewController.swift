//
//  DescripcionViewController.swift
//  testmovie
//
//  Created by Omar Campos on 07/03/22.
//

import UIKit

class DescripcionViewController: UIViewController {
    @IBOutlet weak var titulo: UILabel!
    @IBOutlet weak var rating: UILabel!
    
    @IBOutlet weak var descripcion: UILabel!
    @IBOutlet weak var fecha: UILabel!
    @IBOutlet weak var imagen: UIImageView!
    public var movi : movie?
    override func viewDidLoad() {
        super.viewDidLoad()
        titulo.text = movi?.title
        fecha.text = "Fecha de lanzamiento: \(movi!.release_date)"
        descripcion.text = movi?.overview
        rating.text = "Rating: \(movi?.vote_average)"
        let url = URL(string: "https://image.tmdb.org/t/p/w500" + movi!.poster_path)

        DispatchQueue.global().async {
            let data = try? Data(contentsOf: url!) //make sure your image in this url does exist, otherwise unwrap in a if let check / try-catch
            DispatchQueue.main.async {
                
                self.imagen.image = UIImage(data: data!)
            }
        }
        // Do any additional setup after loading the view.
    }
    

    

}
