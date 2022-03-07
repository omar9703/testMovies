//
//  Request.swift
//  testmovie
//
//  Created by Omar Campos on 07/03/22.
//

import Foundation

struct moviesRequest : Codable
{
    let page : Int
    let results : [movie]
}
struct movie : Codable
{
    let adult : Bool
    let backdrop_path : String
    let genre_ids : [Int]
    let id : Int
    let original_language : String
    let original_title : String
    let overview : String
    let popularity : Double
    let poster_path : String
    let release_date : String
    let title : String
    let video : Bool
    let vote_average : Double
    let vote_count : Int
}
enum typeRequest : String {
    case POST
    case GET
    case DELETE
    case PUT
}
func requestPetition<T : Decodable>(ofType type:T.Type,typeRequest : typeRequest, url : String, parameters : [String:Any] = [String:Any](),basic :String = "",completion: @escaping (Int, T?)->Void){
    var dataReturn : T?
    debugPrint(url)
    var requestParams = URLRequest(url: URL(string: url)!)
    var Bearer : String = ""
    var httpResponseCode : Int = 0
    
    switch typeRequest {
    case .GET:
        if basic != ""
        {
            let logindata = basic.data(using: String.Encoding.utf8)!
            let base64LoginString = logindata.base64EncodedString()
            requestParams.setValue("Basic \(base64LoginString)", forHTTPHeaderField: "Authorization")
        }
        requestParams.httpMethod = typeRequest.rawValue
        break
    case .DELETE:
        requestParams.httpMethod = typeRequest.rawValue
        break
    case .POST, .PUT:
        requestParams.setValue("application/json", forHTTPHeaderField: "Content-Type")
        if basic != ""
        {
            let logindata = basic.data(using: String.Encoding.utf8)!
            let base64LoginString = logindata.base64EncodedString()
            requestParams.setValue("Basic \(base64LoginString)", forHTTPHeaderField: "Authorization")
        }
        requestParams.httpMethod = typeRequest.rawValue
        break
    }
    
    if !parameters.isEmpty{
        requestParams.httpBody = try! JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted)
    }
    
    let task = URLSession.shared.dataTask(with: requestParams) {(data, response, error) in
        if let httpResponse = response as? HTTPURLResponse {
            httpResponseCode = httpResponse.statusCode
            debugPrint(httpResponse.statusCode)
            debugPrint(data ?? Data())
            debugPrint(String(data: data ?? Data(), encoding: .utf8)!)
        }
        let decoder = JSONDecoder()
        do {
            let dataResponse = try decoder.decode(type, from: data ?? Data())
            dataReturn = dataResponse
            debugPrint(":::::::::::::::::_____::::::::::::::")
            debugPrint(dataResponse)
            debugPrint(":::::::::::::::::_____::::::::::::::")
        } catch {
            print(error.localizedDescription)
        }
        completion(httpResponseCode,dataReturn)
    }
    task.resume()
}
