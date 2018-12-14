//
//  MovieInfoViewController.swift
//  BoxOffice
//
//  Created by 고세림 on 2018. 12. 7..
//  Copyright © 2018년 serim. All rights reserved.
//

import UIKit

class MovieInfoViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UITextViewDelegate, UIGestureRecognizerDelegate{

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var thumbImage: UIImageView?
    @IBOutlet weak var gradeImage: UIImageView?
    @IBOutlet weak var titleLabel: UILabel?
    @IBOutlet weak var dateLabel: UILabel?
    @IBOutlet weak var genreDurationLabel: UILabel?
    @IBOutlet weak var reservationLabel: UILabel?
    @IBOutlet weak var userRatingLabel: UILabel?
    @IBOutlet weak var avrRatingStackView: UIStackView?
    @IBOutlet weak var avrRatingImage1: UIImageView?
    @IBOutlet weak var avrRatingImage2: UIImageView?
    @IBOutlet weak var avrRatingImage3: UIImageView?
    @IBOutlet weak var avrRatingImage4: UIImageView?
    @IBOutlet weak var avrRatingImage5: UIImageView?
    @IBOutlet weak var audienceLabel: UILabel?
    @IBOutlet weak var activityindicator: UIActivityIndicatorView?
    
    let synopsisCellIdentifier: String = "synopsisCell"
    let directorCellIdentifier: String = "directorCell"
    let commentLabelIdentifier: String = "commentLabel"
    let commentCellIdentifier: String = "commentCell"
    let thumbCellIdentifier: String = "thumbCell"
    var movieInfos : MovieInfo?
    var comments: [Comment] = []
    var movieTitle: String?
    var movieId: String?
    var starImageArray: [UIImageView] = []
    var emptyStar: UIImage = #imageLiteral(resourceName: "ic_star_large")
    var halfStar: UIImage = #imageLiteral(resourceName: "ic_star_large_half")
    var fullStar: UIImage = #imageLiteral(resourceName: "ic_star_large_full")
    var rating: Float = 0 {
        didSet {
            if rating != oldValue {
                refreshingView()
            }
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        } else if section == 1 {
            return 1
        } else {
            return self.comments.count+1
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return UITableViewAutomaticDimension
        } else if indexPath.section == 1 {
            return 150.0
        } else {
            return UITableViewAutomaticDimension
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            guard let cell: SynopsisTableViewCell =
                tableView.dequeueReusableCell(withIdentifier: self.synopsisCellIdentifier, for: indexPath) as? SynopsisTableViewCell else {
                    return UITableViewCell()
            }
            cell.synopsisView?.text = movieInfos?.synopsis
            guard let newWidth = cell.synopsisView?.frame.size.width else { return cell }
            let newSize = cell.synopsisView?.sizeThatFits(CGSize(width: newWidth, height: CGFloat.greatestFiniteMagnitude))
            guard let newSizeWidth = newSize?.width else { return cell }
            guard let newSizeHeight = newSize?.height else { return cell }
            cell.synopsisView?.frame.size = CGSize(width: newSizeWidth, height: newSizeHeight+20)
            cell.synopsisView?.isScrollEnabled = false
            cell.synopsisView?.delegate = self
            return cell
        } else if indexPath.section == 1 {
            guard let cell: DirectorTableViewCell =
                tableView.dequeueReusableCell(withIdentifier: self.directorCellIdentifier, for: indexPath) as? DirectorTableViewCell else {
                    return UITableViewCell()
            }
            cell.directorLabel?.text = movieInfos?.director
            cell.actorText?.text = movieInfos?.actor
            cell.actorText?.isScrollEnabled = false
            cell.actorText?.delegate = self
            return cell
        } else {
            if indexPath.row == 0 {
                guard let cell: CommentLabelCell =
                    tableView.dequeueReusableCell(withIdentifier: self.commentLabelIdentifier, for: indexPath) as? CommentLabelCell else {
                        return UITableViewCell()
                }
                return cell
            } else {
                guard let cell: CommentTableViewCell =
                    tableView.dequeueReusableCell(withIdentifier: self.commentCellIdentifier,for: indexPath) as? CommentTableViewCell else {
                        return UITableViewCell()
                }
                cell.prepareForReuse()
                let comment: Comment = self.comments[indexPath.row-1]
                cell.writerLabel?.text = comment.writer
                let date = Date(timeIntervalSince1970: comment.timestamp)
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
                let strDate = dateFormatter.string(from: date)
                cell.dateLabel?.text = strDate
                cell.contentText?.text = comment.contents
                let newSize = cell.contentText?.sizeThatFits(CGSize(width: 255, height: CGFloat.greatestFiniteMagnitude))
                guard let newSizeWidth = newSize?.width else { return cell }
                cell.contentText?.frame.size = CGSize(width: newSizeWidth, height: (newSize?.height)!+20)
                cell.contentText?.isScrollEnabled = false
                cell.contentText?.delegate = self
                cell.userRating = Float(comment.rating) / 2.0
                return cell
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if titleLabel?.text == "제목" {
            manageActivitiIndicator(bool: false)
            guard let movieId = self.movieId else { return }
            requestMovieInfosAndComments(movieId: movieId)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.activityindicator?.isHidden = true
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.navigationItem.title = self.movieTitle
        let tapGesture: UITapGestureRecognizer = UITapGestureRecognizer()
        tapGesture.delegate = self
        self.thumbImage?.addGestureRecognizer(tapGesture)
        self.thumbImage?.isUserInteractionEnabled = true
        for i in 0 ..< 5 {
            guard let imageView = avrRatingStackView?.arrangedSubviews[i] as? UIImageView else { return }
            self.starImageArray.append(imageView)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        guard let vc = storyboard?.instantiateViewController(withIdentifier: "thumbCell") as? ThumbViewController else { return true }
        vc.thumbImage = self.thumbImage?.image
        self.navigationController?.present(vc, animated: true, completion: nil)
        return true
    }
    
    func commentChanged() {
        guard let movieId = self.movieId else { return }
        requestComments(movieId: movieId, completionHandler: {(data, error) in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            guard let arr = data else {
                print("error")
                return
            }
            self.comments = arr
            OperationQueue.main.addOperation {
                self.tableView.reloadData()
            }
        })
    }
    
    func refreshingView() {
        for i in 0 ..< 5 {
            let imageView: UIImageView? = self.starImageArray[i]
            if self.rating >= Float(i+1) {
                imageView?.image = self.fullStar
            } else if self.rating > Float(i) && self.rating < Float(i+1) {
                imageView?.image = self.halfStar
            } else {
                imageView?.image = self.emptyStar
            }
        }
    }
    
    func showAlertController(style: UIAlertControllerStyle) {
        let alertController: UIAlertController
        alertController = UIAlertController(title: "Error", message: "정보를 받는 데 실패하였습니다.", preferredStyle: style)
        let okAction: UIAlertAction
        okAction = UIAlertAction(title: "확인", style: UIAlertActionStyle.destructive, handler: nil)
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    func requestMovieInfosAndComments(movieId: String) {
        requestMovieInfos(id: movieId, completionHandler: {(data, error) in
            if let error = error {
                self.showAlertController(style: UIAlertControllerStyle.alert)
                print(error.localizedDescription)
                return
            }
            guard let arr = data else {
                self.showAlertController(style: UIAlertControllerStyle.alert)
                print("error")
                return
            }
            self.movieInfos = arr
            OperationQueue.main.addOperation {
                guard let movieInfos: MovieInfo = self.movieInfos else { return }
                DispatchQueue.global().async {
                    let imageURL: URL = movieInfos.image
                    guard let imageData: Data = try? Data(contentsOf: imageURL) else {return}
                    DispatchQueue.main.async {
                        self.thumbImage?.image = UIImage(data: imageData)
                    }
                }
                self.titleLabel?.text = movieInfos.title
                if movieInfos.grade == 0 {
                    self.gradeImage?.image = #imageLiteral(resourceName: "ic_allages")
                } else {
                    self.gradeImage?.image = UIImage(named: "ic_" + String(movieInfos.grade))
                }
                self.dateLabel?.text = movieInfos.date+" 개봉"
                self.genreDurationLabel?.text = movieInfos.genre+"/"+String(movieInfos.duration)+"분"
                self.reservationLabel?.text = String(movieInfos.reservationGrade)+"위 "+String(movieInfos.reservationRate)+"%"
                self.userRatingLabel?.text = String(movieInfos.userRating)
                self.rating = Float(movieInfos.userRating)/2.0
                self.audienceLabel?.text = String(movieInfos.audience)
                self.manageActivitiIndicator(bool: true)
                self.tableView.reloadData()
            }
        })
        requestComments(movieId: movieId, completionHandler: {(data, error) in
            if let error = error {
                self.showAlertController(style: UIAlertControllerStyle.alert)
                print(error.localizedDescription)
                return
            }
            guard let arr = data else {
                self.showAlertController(style: UIAlertControllerStyle.alert)
                print("error")
                return
            }
            self.comments = arr
            OperationQueue.main.addOperation {
                self.tableView.reloadData()
            }
        })
    }
    
    func manageActivitiIndicator(bool: Bool) {
        if bool {
            self.activityindicator?.stopAnimating()
            self.activityindicator?.isHidden = bool
        } else {
            self.activityindicator?.startAnimating()
            self.activityindicator?.isHidden = bool
        }
    }

}
//rating 관련 코드는 https://www.raywenderlich.com/3115-uiview-tutorial-for-ios-how-to-make-a-custom-uiview-in-ios-5-a-5-star-rating-view 을 참고하였습니다.

