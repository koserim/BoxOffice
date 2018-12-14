//
//  Request.swift
//  BoxOffice
//
//  Created by 고세림 on 2018. 12. 7..
//  Copyright © 2018년 serim. All rights reserved.
//

import Foundation

typealias MovieCompletionBlock = (_ data: [Movie]?, _ error: Error?) -> ()
typealias MovieInfoCompletionBlock = (_ data: MovieInfo?, _ error: Error?) -> ()
typealias CommentCompletionBlock = (_ data: [Comment]?, _ error: Error?) -> ()

func requestMovies(code: Int, completionHandler: @escaping MovieCompletionBlock) {
    guard let url: URL = URL(string: "http://connect-boxoffice.run.goorm.io/movies?order_type=\(code)") else {return}
    let session: URLSession = URLSession(configuration: .default)
    let dataTask: URLSessionDataTask = session.dataTask(with: url) {(data: Data?, response: URLResponse?, error: Error?) in
        if let error = error {
            print(error.localizedDescription)
            completionHandler(nil, error)
            return
        }
        guard let data = data else {return}
        do {
            let apiResponse: MovieAPIResponse = try JSONDecoder().decode(MovieAPIResponse.self, from: data)
            completionHandler(apiResponse.movies, nil)
        } catch(let err) {
            print(err.localizedDescription)
        }
    }
    dataTask.resume()
}

func requestMovieInfos(id: String, completionHandler: @escaping MovieInfoCompletionBlock) {
    guard let url: URL = URL(string: "http://connect-boxoffice.run.goorm.io/movie?id=\(id)") else {return}
    let session: URLSession = URLSession(configuration: .default)
    let dataTask: URLSessionDataTask = session.dataTask(with: url) {(data: Data?, response: URLResponse?, error: Error?) in
        if let error = error {
            print(error.localizedDescription)
            completionHandler(nil, error)
            return
        }
        guard let data = data else {return}
        do {
            let apiResponse: MovieInfo = try JSONDecoder().decode(MovieInfo.self, from: data)
            completionHandler(apiResponse, nil)
        } catch(let err) {
            print(err.localizedDescription)
        }
    }
    dataTask.resume()
}

func requestComments(movieId: String, completionHandler: @escaping CommentCompletionBlock) {
    guard let url: URL = URL(string: "http://connect-boxoffice.run.goorm.io/comments?id=\(movieId)") else {return}
    let session: URLSession = URLSession(configuration: .default)
    let dataTask: URLSessionDataTask = session.dataTask(with: url) {(data: Data?, response: URLResponse?, error: Error?) in
        if let error = error {
            print(error.localizedDescription)
            completionHandler(nil, error)
            return
        }
        guard let data = data else {return}
        do {
            let apiResponse: CommentAPIResponse = try JSONDecoder().decode(CommentAPIResponse.self, from: data)
            completionHandler(apiResponse.comments, nil)
        } catch(let err) {
            print(err.localizedDescription)
        }
    }
    dataTask.resume()
}

