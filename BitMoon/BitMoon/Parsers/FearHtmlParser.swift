//
//  FearHtmlParser.swift
//  BitMoon
//
//  Created by succorer on 2018. 11. 13..
//  Copyright © 2018년 PFXStudio. All rights reserved.
//

import UIKit
import SwiftyJSON

class FearHtmlParser: ServiceParser {
    /*
     <script>
     var config = {
     type: 'line',
     data: {
     labels: ["Feb 01, 2018","Feb 02, 2018","Feb 03, 2018","Feb 04, 2018","Feb 05, 2018","Feb 06, 2018","Feb 07, 2018","Feb 08, 2018","Feb 09, 2018","Feb 10, 2018","Feb 11, 2018","Feb 12, 2018","Feb 13, 2018","Feb 14, 2018","Feb 15, 2018","Feb 16, 2018","Feb 17, 2018","Feb 18, 2018","Feb 19, 2018","Feb 20, 2018","Feb 21, 2018","Feb 22, 2018","Feb 23, 2018","Feb 24, 2018","Feb 25, 2018","Feb 26, 2018","Feb 27, 2018","Feb 28, 2018","March 01, 2018","March 02, 2018","March 03, 2018","March 04, 2018","March 05, 2018","March 06, 2018","March 07, 2018","March 08, 2018","March 09, 2018","March 10, 2018","March 11, 2018","March 12, 2018","March 13, 2018","March 14, 2018","March 15, 2018","March 16, 2018","March 17, 2018","March 18, 2018","March 19, 2018","March 20, 2018","March 21, 2018","March 22, 2018","March 23, 2018","March 24, 2018","March 25, 2018","March 26, 2018","March 27, 2018","March 28, 2018","March 29, 2018","March 30, 2018","March 31, 2018","April 01, 2018","April 02, 2018","April 03, 2018","April 04, 2018","April 05, 2018","April 06, 2018","April 07, 2018","April 08, 2018","April 09, 2018","April 10, 2018","April 11, 2018","April 12, 2018","April 13, 2018","April 17, 2018","April 18, 2018","April 19, 2018","April 20, 2018","April 21, 2018","April 22, 2018","April 23, 2018","April 24, 2018","April 25, 2018","April 26, 2018","April 27, 2018","April 28, 2018","April 29, 2018","April 30, 2018","May 01, 2018","May 02, 2018","May 03, 2018","May 04, 2018","May 05, 2018","May 06, 2018","May 07, 2018","May 08, 2018","May 09, 2018","May 10, 2018","May 11, 2018","May 12, 2018","May 13, 2018","May 14, 2018","May 15, 2018","May 16, 2018","May 17, 2018","May 18, 2018","May 19, 2018","May 20, 2018","May 21, 2018","May 22, 2018","May 23, 2018","May 24, 2018","May 25, 2018","May 26, 2018","May 27, 2018","May 28, 2018","May 29, 2018","May 30, 2018","May 31, 2018","June 01, 2018","June 02, 2018","June 03, 2018","June 04, 2018","June 05, 2018","June 06, 2018","June 07, 2018","June 08, 2018","June 09, 2018","June 10, 2018","June 11, 2018","June 12, 2018","June 13, 2018","June 14, 2018","June 15, 2018","June 16, 2018","June 17, 2018","June 18, 2018","June 19, 2018","June 20, 2018","June 21, 2018","June 22, 2018","June 23, 2018","June 24, 2018","June 25, 2018","June 26, 2018","June 27, 2018","June 28, 2018","June 29, 2018","June 30, 2018","July 01, 2018","July 02, 2018","July 03, 2018","July 04, 2018","July 05, 2018","July 06, 2018","July 07, 2018","July 08, 2018","July 09, 2018","July 10, 2018","July 11, 2018","July 12, 2018","July 13, 2018","July 14, 2018","July 15, 2018","July 16, 2018","July 17, 2018","July 18, 2018","July 19, 2018","July 20, 2018","July 21, 2018","July 22, 2018","July 23, 2018","July 24, 2018","July 25, 2018","July 26, 2018","July 27, 2018","July 28, 2018","July 29, 2018","July 30, 2018","July 31, 2018","August 01, 2018","August 02, 2018","August 03, 2018","August 04, 2018","August 05, 2018","August 06, 2018","August 07, 2018","August 08, 2018","August 09, 2018","August 10, 2018","August 11, 2018","August 12, 2018","August 13, 2018","August 14, 2018","August 15, 2018","August 16, 2018","August 17, 2018","August 18, 2018","August 19, 2018","August 20, 2018","August 21, 2018","August 22, 2018","August 23, 2018","August 24, 2018","August 25, 2018","August 26, 2018","August 27, 2018","August 28, 2018","August 29, 2018","August 30, 2018","August 31, 2018","September 01, 2018","September 02, 2018","September 03, 2018","September 04, 2018","September 05, 2018","September 06, 2018","September 07, 2018","September 08, 2018","September 09, 2018","September 10, 2018","September 11, 2018","September 12, 2018","September 13, 2018","September 14, 2018","September 15, 2018","September 16, 2018","September 17, 2018","September 18, 2018","September 19, 2018","September 20, 2018","September 21, 2018","September 22, 2018","September 23, 2018","September 24, 2018","September 25, 2018","September 26, 2018","September 27, 2018","September 28, 2018","September 29, 2018","September 30, 2018","October 01, 2018","October 02, 2018","October 03, 2018","October 04, 2018","October 05, 2018","October 06, 2018","October 07, 2018","October 08, 2018","October 09, 2018","October 10, 2018","October 11, 2018","October 12, 2018","October 13, 2018","October 14, 2018","October 15, 2018","October 16, 2018","October 17, 2018","October 18, 2018","October 19, 2018","October 20, 2018","October 21, 2018","October 22, 2018","October 23, 2018","October 24, 2018","October 25, 2018","October 26, 2018","October 27, 2018","October 28, 2018","October 29, 2018","October 30, 2018","October 31, 2018","November 01, 2018","November 02, 2018","November 03, 2018","November 04, 2018","November 05, 2018","November 06, 2018","November 07, 2018","November 08, 2018","November 09, 2018","November 10, 2018","November 11, 2018","November 12, 2018",],
     datasets: [{
     label: "Crypto Fear & Greed Index",
     fill: false,
     backgroundColor: '#ccc',
     borderColor: '#ccc',
     data: [
     "30","15","40","24","11","8","36","30","44","54","31","42","35","55","71","67","74","63","67","74","54","44","39","31","33","37","44","41","38","47","56","44","55","59","37","39","37","39","40","41","41","40","32","33","31","29","29","37","36","36","28","32","30","31","24","24","18","12","16","16","11","22","22","17","19","20","17","21","18","20","18","23","26","24","25","26","32","31","28","29","64","47","55","54","61","59","56","52","55","56","63","67","56","62","53","63","41","44","40","40","40","32","31","37","31","32","41","30","26","27","25","23","19","22","16","38","25","24","27","40","41","26","42","38","40","39","24","15","19","19","17","26","22","23","27","32","34","37","28","17","15","16","21","18","20","16","22","27","27","31","33","37","34","34","38","39","37","29","33","29","29","32","36","39","42","44","47","43","46","44","49","54","53","47","54","54","53","48","39","39","36","31","23","25","25","23","19","21","18","18","21","16","18","21","19","24","27","26","19","21","18","19","22","19","18","19","19","22","17","21","18","19","26","17","14","17","18","13","15","18","14","20","23","24","28","25","21","24","24","31","35","38","43","37","37","42","42","37","34","35","33","36","29","37","34","29","26","31","28","19","13","15","18","20","24","23","26","24","21","21","27","24","23","25","29","33","35","34","31","32","29","36","36","41","42","42","48","51","47","52","54","52",
     ],
     }]
     },
     options: {
     responsive: true,
     tooltips: {
     mode: 'index',
     intersect: false,
     },
     hover: {
     mode: 'nearest',
     intersect: true
     },
     scales: {
     xAxes: [{
     display: true,
     scaleLabel: {
     display: false,
     labelString: 'Day'
     }
     }],
     yAxes: [{
     display: true,
     scaleLabel: {
     display: true,
     labelString: 'Value'
     },
     ticks: {
     beginAtZero: true,
     steps: 10,
     stepValue: 5,
     max: 100
     }
     }]
     }
     }
     };
     
     window.onload = function() {

 */
    override func parseWithHtml(htmlString: String) -> Bool {
        ChartData.sharedFearLabels.removeAllObjects()
        ChartData.sharedFearDatas.removeAllObjects()

        let startLabelRange = htmlString.range(of: "labels: [")
        let startLabelIndex = startLabelRange!.upperBound
        
        let startLabelString = String(htmlString[startLabelIndex...])
        
        let endLabelRange = startLabelString.range(of: "\",]")
        let endLabelIndex = endLabelRange!.lowerBound
        
        let subLabelString = String(startLabelString[..<endLabelIndex])
        let labelTokens = subLabelString.components(separatedBy: "\",")
        
        for token in labelTokens {
            let label = token.replacingOccurrences(of: "\"", with: "")
            ChartData.sharedFearLabels.add(label)
        }
        
        let startDataRange = htmlString.range(of: "data: [")
        let startDataIndex = startDataRange!.upperBound
        
        let startDataString = String(htmlString[startDataIndex...])
        
        let endDataRange = startDataString.range(of: "],")
        let endDataIndex = endDataRange!.lowerBound
        
        let subDataString = String(startDataString[..<endDataIndex])
        let dataTokens = subDataString.components(separatedBy: "\",")
        
        var index = 0
        for token in dataTokens {
            var dataString = token.replacingOccurrences(of: "\n\t                        \"", with: "")
            dataString = dataString.replacingOccurrences(of: "\"", with: "")
            let numberData:Int? = Int(dataString)
            if let data:Int = numberData
            {
                ChartData.sharedFearDatas.add(data)
                index += 1
            }
        }
        
        if (ChartData.sharedFearLabels.count != ChartData.sharedFearDatas.count) {
            ChartData.sharedFearLabels.removeAllObjects()
            ChartData.sharedFearDatas.removeAllObjects()
            print("changed fear page parse!")
            
            return false
        }
        
        return true
    }
}
