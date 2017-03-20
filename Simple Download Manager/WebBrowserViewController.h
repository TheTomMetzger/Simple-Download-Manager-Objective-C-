//
//  WebBrowserViewController.h
//  Simple Download Manager
//
//  Created by Tom Metzger on 12/27/16.
//  Copyright © 2016 Tom Metzger. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WebBrowserViewController : UIViewController <UIWebViewDelegate>
@property (weak, nonatomic) IBOutlet UIWebView *webView;

@end
