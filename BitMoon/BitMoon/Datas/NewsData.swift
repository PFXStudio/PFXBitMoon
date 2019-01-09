//
//  NewsData.swift
//  BitMoon
//
//  Created by succorer on 2018. 11. 14..
//  Copyright © 2018년 PFXStudio. All rights reserved.
//

import UIKit

class NewsData: NSObject {
    var id = ""
    var guid = ""
    var published_on = 0
    var imageurl = ""
    var title = ""
    var url = ""
    var source = ""
    var body = ""
    var tags = ""
    var categories = ""
    var upvotes = ""
    var downvotes = ""
    var lang = ""
    var source_name = ""
    var source_lang = ""
    var source_img = ""
    
    init(id: String, guid: String, published_on: Int, imageurl: String, title: String, url: String, source: String, body: String, tags: String, categories: String, upvotes: String, downvotes: String, lang: String, source_name: String, source_lang: String, source_img: String) {
        self.id = id
        self.guid = guid
        self.published_on = published_on
        self.imageurl = imageurl
        self.title = title
        self.url = url
        self.source = source
        self.body = body
        self.tags = tags
        self.categories = categories
        self.upvotes = upvotes
        self.downvotes = downvotes
        self.lang = lang
        self.source_name = source_name
        self.source_lang = source_lang
        self.source_img = source_img
    }
}
