//
//  BithumbParser.h
//  BitExchange
//
//  Created by PFXStudio on 2018. 4. 8..
//  Copyright © 2018년 PFXStudio. All rights reserved.
//

#import <WebKit/WebKit.h>

@interface TurtleParser : NSObject
    - (NSArray *)parseWithHTMLString:(NSString *)htmlString;
@end
