//
//  StreamData.swift
//  Spotflock
//
//  Created by Naveenkrishna Manda on 19/07/19.
//  Copyright © 2019 Naveenkrishna Manda. All rights reserved.
//

import UIKit

struct StreamData: Codable {
    var kstream: StreamContent
}

struct StreamContent: Codable {
    var data: [Feed]
    var first_page_url: String?
    var next_page_url: String?
    var prev_page_url: String?
    var per_page: Int
}

struct Feed: Codable {
    var title: String
    var short_description: String?
    var full_description: String?
    var title_image_url: String?
    var description_image_url: String?
    var article_url: String?
    var likes: Int
    var comments: Int
    var shares: Int
}
