//
//  BithumbParser.m
//  BitExchange
//
//  Created by PFXStudio on 2018. 4. 8..
//  Copyright © 2018년 PFXStudio. All rights reserved.
//

#import "TurtleParser.h"

@interface TurtleParser ()

@end

@implementation TurtleParser

- (NSArray *)parseWithHTMLString:(NSString *)htmlString {
    
    // <div id="volume_line" style="display: none;">
    // <div class="clearfix"></div>
    NSString *key = @"turtle";
    NSRange startBodyRange = [htmlString rangeOfString:@"<div id=\"volume_line\" style=\"display: none;\">"];
    NSRange endBodyRange = [htmlString rangeOfString:@"<div class=\"clearfix\"></div>"];
    if (startBodyRange.length <= 0 || endBodyRange.length <= 0) {
        return nil;
    }
    
    NSRange jsonRange;
    jsonRange.location = startBodyRange.location + startBodyRange.length;
    jsonRange.length = endBodyRange.location - jsonRange.location;
    
    NSString *jsonText = [htmlString substringWithRange:jsonRange];
    jsonText = [jsonText stringByReplacingOccurrencesOfString:@"</div>" withString:@""];
    NSData *jsonData = [jsonText dataUsingEncoding:NSUTF8StringEncoding];
    NSError *error;
    NSArray *jsonDatas = [NSJSONSerialization JSONObjectWithData:jsonData options:kNilOptions error:& error];
    NSArray *datas = [[jsonDatas firstObject] objectForKey:@"data"];
    NSInteger dataCount = [datas count];
    if (dataCount <= 1) {
        return nil;
    }
    
    return datas;
}



@end
