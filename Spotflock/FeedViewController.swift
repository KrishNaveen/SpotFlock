//
//  FeedViewController.swift
//  Spotflock
//
//  Created by Krish on 17/07/19.
//  Copyright © 2019 Krish. All rights reserved.
//

import UIKit

class FeedViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        SearviceManager.sharedInstance.fetchFeed()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationItem.setHidesBackButton(true, animated: false)
        self.title = "Your Feed!"
    }
    
    @IBAction func logoutButtonTapped(_ sender: Any) {
        navigationController?.popToRootViewController(animated: true)
    }
}
