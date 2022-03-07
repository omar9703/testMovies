//
//  Mov.swift
//  testmovie
//
//  Created by Omar Campos on 07/03/22.
//

import Foundation
import UIKit
import CoreData
class movieData
{
    public static func SaveUser(m: movie) {
        
        guard let appDelegate =
                UIApplication.shared.delegate as? AppDelegate else {
                    return
                }
        
        // 1
        let managedContext =
        appDelegate.persistentContainer.viewContext
        
        // 2
        //        let entity =
        //          NSEntityDescription.entity(forEntityName: "Usuario",
        //                                     in: managedContext)!
        //
        //        let person = NSManagedObject(entity: entity,
        //                                     insertInto: managedContext)
        //
        //        // 3
        //          person.setValue(user.nombre, forKeyPath: "nombre")
        //          person.setValue(user.apellidoMaterno, forKey: "apellidoMaterno")
        //        person.setValue(user.apellidoPaterno, forKey: "apellidoPaterno")
        //        person.setValue(user.telefono, forKey: "telefono")
        //        person.setValue(user.correo, forKey: "correo")
        //        person.setValue(user.rol, forKey: "rol")
        
        let us = Movie(context: managedContext)
        us.poster_path = m.poster_path
        us.vote_average = m.vote_average
        us.overview = m.overview
        us.release_date = m.release_date
        us.adult = m.adult
        us.backdrop_path = m.backdrop_path
        us.id = Float(m.id)
        us.original_language = m.original_language
        us.original_title = m.original_title
        us.title = m.title
        us.popularity = m.popularity
        us.vote_count = Double(m.vote_count)
        us.video = m.video
        
        // 4
        do {
            try managedContext.save()
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
        
    }
    public static func Getmovie() -> [movie]?
    {
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
              return nil
          }
          
          let managedContext =
            appDelegate.persistentContainer.viewContext
          
          //2
          let fetchRequest =
            NSFetchRequest<NSManagedObject>(entityName: "Movie")
          
          //3
          do {
              let peliculas = try managedContext.fetch(fetchRequest)
              if peliculas.count > 0
              {
                  var pelis = [movie]()
                  for x in peliculas
                  {
                      pelis.append(movie(adult: x.value(forKey: "adult") as! Bool, backdrop_path: x.value(forKey: "backdrop_path") as! String, genre_ids: [Int](), id: x.value(forKey: "id") as! Int, original_language: x.value(forKey: "original_language") as! String, original_title: x.value(forKey: "original_title") as! String, overview: x.value(forKey: "overview") as! String, popularity: x.value(forKey: "popularity") as! Double, poster_path: x.value(forKey: "poster_path") as! String, release_date: x.value(forKey: "release_date") as! String, title: x.value(forKey: "title") as! String, video: x.value(forKey: "video") as! Bool, vote_average: x.value(forKey: "vote_average") as! Double, vote_count: x.value(forKey: "vote_count") as! Int))
                  }
                  return pelis
              }
              else
              {
                  return nil
              }
          } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
              return nil
          }
    }
}
