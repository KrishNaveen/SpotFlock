//
//  FeedDetailsViewController.swift
//  Spotflock
//
//  Created by Test on 20/07/19.
//  Copyright © 2019 Naveenkrishna Manda. All rights reserved.
//

import UIKit

class FeedDetailsViewController: UIViewController {
    
    var feed: Feed!

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var shortDesctionLabel: UILabel!
    @IBOutlet weak var fullDesctionLabel: UILabel!
    @IBOutlet weak var likesLabel: UILabel!
    @IBOutlet weak var commentsLabel: UILabel!
    @IBOutlet weak var shareLabel: UILabel!
    @IBOutlet weak var likeView: UIView!
    @IBOutlet weak var commentsView: UIView!
    @IBOutlet weak var shareView: UIView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var articleButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()

        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        scrollView.contentSize = CGSize(width: UIScreen.main.bounds.size.width - 20, height: articleButton.frame.origin.y + 50)
        articleButton.darkenBackgroundOnHighlight()
    }
    
    fileprivate func configureView() {
        titleLabel.text = feed.title
        shortDesctionLabel.text = feed.short_description
        fullDesctionLabel.text = feed.full_description
        likesLabel.text = "\(feed.likes)"
        commentsLabel.text = "\(feed.comments)"
        shareLabel.text = "\(feed.shares)"
        ImageManager.sharedInstance.getImage(from: feed.title_image_url) { [weak self] (uiImage) in
            guard let strongSelf = self, let uiImage = uiImage else { return }
            onMainQueue {
                strongSelf.imageView.image = uiImage
            }
        }
    }
    
    @IBAction func showArticleButtonTapped(_ sender: Any) {
        guard  let urlString = feed.article_url, let url = URL(string: urlString) else { return }
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
}
