//  CollectionViewController.swift
//  BoxOffice
//
//  Created by 고세림 on 2018. 12. 7..
//  Copyright © 2018년 serim. All rights reserved.

import UIKit

class CollectionViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    @IBOutlet weak var collectionView: UICollectionView?
    @IBOutlet weak var activityindicator: UIActivityIndicatorView?
    let cellIdentifier: String = "movieCell"
    var movies: [Movie] = []
    var refreshControl = UIRefreshControl()
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return movies.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell: IndexCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: self.cellIdentifier, for: indexPath) as? IndexCollectionViewCell else {
            return UICollectionViewCell()
        }
        let movie: Movie = self.movies[indexPath.row]
        DispatchQueue.global().async {
            let imageURL: URL = movie.thumb
            guard let imageData: Data = try? Data(contentsOf: imageURL) else {return}
            DispatchQueue.main.async {
                cell.thumbImage?.image = UIImage(data: imageData)
            }
        }
        if movie.grade == 0 {
            cell.gradeImage?.image = #imageLiteral(resourceName: "ic_allages")
        } else {
            cell.gradeImage?.image = UIImage(named: "ic_" + String(movie.grade))
        }
        cell.titleLabel?.text = movie.title
        cell.ratingLabel?.text = String(movie.reservationGrade)+"위("+String(movie.userRating)+") / "+String(movie.reservationRate)+"%"
        cell.dateLabel?.text = movie.date
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let vc = storyboard?.instantiateViewController(withIdentifier: "movieInfo") as? MovieInfoViewController else { return }
        vc.movieTitle = movies[indexPath.row].title
        vc.movieId = movies[indexPath.row].id
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        guard let code = SortInformation.shared.sortCode else { return }
        activityindicator?.isHidden = false
        activityindicator?.startAnimating()
        sorting(sortCode: code)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "예매율순"
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "ic_settings"), style: .plain, target: self, action: #selector(tapSetting))
        sorting(sortCode: 0)
        collectionView?.addSubview(refreshControl)
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)

    }

    @objc func refresh() {
        OperationQueue.main.addOperation {
            self.collectionView?.reloadData()
        }
        self.refreshControl.endRefreshing()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @objc func tapSetting() {
        self.showAlertController(style: UIAlertControllerStyle.actionSheet)
    }
    
    func showAlertController(style: UIAlertControllerStyle) {
        let alertController: UIAlertController
        alertController = UIAlertController(title: "정렬방식 선택", message: "영화를 어떤 순서로 정렬할까요?", preferredStyle: style)
        let ticketing: UIAlertAction
        ticketing = UIAlertAction(title: "예매율순", style: UIAlertActionStyle.default, handler: { (action: UIAlertAction) in
            SortInformation.shared.sortCode = 0
            self.sorting(sortCode: 0)
        })
        let curation: UIAlertAction
        curation = UIAlertAction(title: "큐레이션", style: UIAlertActionStyle.default, handler: { (action: UIAlertAction) in
            self.navigationItem.title = "큐레이션"
            SortInformation.shared.sortCode = 1
            self.sorting(sortCode: 1)
        })
        let release: UIAlertAction
        release = UIAlertAction(title: "개봉일순", style: UIAlertActionStyle.default, handler: { (action: UIAlertAction) in
            self.navigationItem.title = "개봉일순"
            SortInformation.shared.sortCode = 2
            self.sorting(sortCode: 2)
        })
        let cancelAction: UIAlertAction
        cancelAction = UIAlertAction(title: "취소", style: UIAlertActionStyle.cancel, handler: nil)
        alertController.addAction(ticketing)
        alertController.addAction(curation)
        alertController.addAction(release)
        alertController.addAction(cancelAction)
        if UIDevice.current.userInterfaceIdiom == .pad {
            if let popoverController = alertController.popoverPresentationController {
                popoverController.sourceView = self.view
                popoverController.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY, width: 0, height: 0)
                popoverController.permittedArrowDirections = []
                self.present(alertController, animated: true, completion: nil)
            }
        } else {
            self.present(alertController, animated: true, completion: nil)
        }
    }
    
    func sorting(sortCode: Int) {
        if sortCode == 0 {
            self.navigationItem.title = "예매율순"
        } else if sortCode == 1 {
             self.navigationItem.title = "큐레이션"
        } else {
            self.navigationItem.title = "개봉일순"
        }
        requestMovies(code: sortCode, completionHandler: {(data, error) in
            if let error = error {
                self.showErrorAlertController(style: UIAlertControllerStyle.alert)
                print(error.localizedDescription)
                return
            }
            guard let arr = data else {
                self.showErrorAlertController(style: UIAlertControllerStyle.alert)
                print("error")
                return
            }
            self.movies = arr
            OperationQueue.main.addOperation {
                self.collectionView?.reloadData()
                self.activityindicator?.isHidden = true
                self.activityindicator?.stopAnimating()
            }
        })
    }
    
    func showErrorAlertController(style: UIAlertControllerStyle) {
        let alertController: UIAlertController
        alertController = UIAlertController(title: "Error", message: "정보를 받는 데 실패하였습니다.", preferredStyle: style)
        let okAction: UIAlertAction
        okAction = UIAlertAction(title: "확인", style: UIAlertActionStyle.destructive, handler: nil)
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
}
