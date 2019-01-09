//
//  newsListParser.swift
//  BitMoon
//
//  Created by succorer on 2018. 12. 12..
//  Copyright © 2018년 PFXStudio. All rights reserved.
//

import UIKit
import SwiftyJSON

class newsListParser: ServiceParser {
    override func parseWithJson(jsonString: String) -> Any {
        var newsDatas = Array<NewsData>()
        if let jsonDict = JSON(parseJSON: jsonString).object as? NSDictionary {
            if let message = jsonDict.object(forKey: "Response") as? String {
                if message != "Success" {
                    return newsDatas
                }
            }
            
            /*
{\"id\":\"721076\",\"guid\":\"https://www.ccn.com/?p=154098\",\"published_on\":1544750105,\"imageurl\":\"https://images.cryptocompare.com/news/ccn/8wclBpwAnEU.jpeg\",\"title\":\"German Stock Exchange Giant to Launch Crypto Trading — How it Will Affect the European Market\",\"url\":\"https://www.ccn.com/german-stock-exchange-giant-to-launch-crypto-trading-how-it-will-affect-the-european-market/\",\"source\":\"ccn\",\"body\":\"On December 12, Boerse Stuttgart, the second-biggest stock exchange in Germany and the ninth-largest in Europe, said in an official statement that it plans to introduce a crypto trading platform by the second quarter of 2019. Alexander Höptner, the CEO of Boerse Stuttgart GmbH, stated: &#8220;With its combination of technology and banking expertise, solarisBank isThe post German Stock Exchange Giant to Launch Crypto Trading &#8212; How it Will Affect the European Market appeared first on CCN\",\"tags\":\"Exchanges|News|Trading|Boerse Stuttgart|europe|germany|solarisBank\",\"categories\":\"Trading|Exchange|Business|Market|Technology\",\"upvotes\":\"0\",\"downvotes\":\"0\",\"lang\":\"EN\",\"source_info\":{\"name\":\"CCN\",\"lang\":\"EN\",\"img\":\"https://images.cryptocompare.com/news/default/ccn.png\"}}
 */
            
            if let datas = jsonDict.object(forKey: "Data") as? NSArray {
                for value in datas {
                    var newsData: NewsData?
                    guard let dataDict = value as? NSDictionary,
                        let id = dataDict.object(forKey: "id"),
                        let guid = dataDict.object(forKey: "guid"),
                        let published_on = dataDict.object(forKey: "published_on"),
                        let imageurl = dataDict.object(forKey: "imageurl"),
                        let title = dataDict.object(forKey: "title"),
                        let url = dataDict.object(forKey: "url"),
                        let source = dataDict.object(forKey: "source"),
                        let body = dataDict.object(forKey: "body"),
                        let tags = dataDict.object(forKey: "tags"),
                        let categories = dataDict.object(forKey: "categories"),
                        let upvotes = dataDict.object(forKey: "upvotes"),
                        let downvotes = dataDict.object(forKey: "downvotes"),
                        let lang = dataDict.object(forKey: "lang"),
                        let source_info = dataDict.object(forKey: "source_info") as? NSDictionary,
                        let source_name = source_info.object(forKey: "name"),
                        let source_lang = source_info.object(forKey: "lang"),
                        let source_img = source_info.object(forKey: "img")
                        else {
                            continue
                        }
                    
                    newsData = NewsData(id: id as! String, guid: guid as! String, published_on: published_on as! Int, imageurl: imageurl as! String, title: title as! String, url: url as! String, source: source as! String, body: body as! String, tags: tags as! String, categories: categories as! String, upvotes: upvotes as! String, downvotes: downvotes as! String, lang: lang as! String, source_name: source_name as! String, source_lang: source_lang as! String, source_img: source_img as! String)
                    newsDatas.append(newsData!)
                }
                
                return newsDatas
            }
        }
        
        return newsDatas
    }

}
