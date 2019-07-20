//
//  FeedViewController.swift
//  Spotflock
//
//  Created by Krish on 17/07/19.
//  Copyright © 2019 Krish. All rights reserved.
//

import UIKit

class FeedViewController: UIViewController {
    fileprivate var lastKnownIndex = 0
    fileprivate var feeds = [Feed]()
    fileprivate var streamData: StreamData!
    @IBOutlet weak var tableView: UITableView!
    fileprivate let imagePlaceHolderplaceHolder = UIImage(named: "PlaceHolder")!
    fileprivate var imageSize = CGSize(width: 50, height: 50)
    
    fileprivate let cellIdentifier = "FEEDCELL"
    fileprivate var selectedFeed: Feed!
    var placeHolderImage: UIImage {
        return redraw(imagePlaceHolderplaceHolder)!
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 70
        
        SearviceManager.sharedInstance.fetchFeed { [weak self](streamData) in
            guard let strongSelf = self else { return }
            strongSelf.streamData = streamData
            strongSelf.feeds.append(contentsOf: streamData.kstream.data)
            onMainQueue {
                strongSelf.tableView.reloadData()
            }
        }
        // Do any additional setup after loading the view.
    }
    
    fileprivate func fetchNextPage() {
        guard let nextPageURL = streamData.kstream.next_page_url else { return }
        SearviceManager.sharedInstance.fetchFeed(from: nextPageURL, completion: { [weak self](streamData) in
            guard let strongSelf = self else { return }
            strongSelf.streamData = streamData
            strongSelf.feeds.append(contentsOf: streamData.kstream.data)
        })
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationItem.setHidesBackButton(true, animated: false)
        self.title = "Your Feed!"
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        SearviceManager.sharedInstance.cancelAllRequests()
    }
    
    @IBAction func logoutButtonTapped(_ sender: Any) {
        navigationController?.popToRootViewController(animated: true)
    }
}

extension FeedViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        lastKnownIndex = feeds.count
        return lastKnownIndex
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier)!
        let feed = feeds[indexPath.row]
        cell.textLabel?.numberOfLines = 0
        cell.detailTextLabel?.numberOfLines = 0
        cell.textLabel?.text = feed.title
        cell.detailTextLabel?.text = feed.short_description
        cell.imageView?.image = self.placeHolderImage
        let imageView = cell.imageView // image view constraints pin all edges to the cell edges
        imageView?.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        imageView?.translatesAutoresizingMaskIntoConstraints = true
        imageView?.contentMode = .scaleAspectFit
        ImageManager.sharedInstance.getImage(from: feed.title_image_url ?? feed.description_image_url) { [cell](uiImage) in
            onMainQueue {
                if let uiImage = uiImage {
                    cell.imageView?.image = self.redraw(uiImage)
                } else {
                    cell.imageView?.image = self.placeHolderImage
                }
            }
        }
        if indexPath.row == feeds.count - streamData.kstream.per_page {
            fetchNextPage()
        }
        if let row = tableView.indexPathsForVisibleRows?.last?.row, row == lastKnownIndex - 1 {
            tableView.reloadData()
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedFeed = feeds[indexPath.row]
        performSegue(withIdentifier: AppConstants.segueKeyToNavigateFeedDetails, sender: self)
    }
    
    fileprivate func redraw(_ image: UIImage) -> UIImage? {
        UIGraphicsBeginImageContext(imageSize)
        image.draw(in: CGRect(origin: CGPoint.zero, size: imageSize))
        let imageToReturn = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return imageToReturn
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let feedDetails = segue.destination as! FeedDetailsViewController
        feedDetails.feed = selectedFeed
    }
}
