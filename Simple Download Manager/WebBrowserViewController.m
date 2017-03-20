//
//  WebBrowserViewController.m
//  Simple Download Manager
//
//  Created by Tom Metzger on 12/27/16.
//  Copyright © 2016 Tom Metzger. All rights reserved.
//

#import "WebBrowserViewController.h"



@interface WebBrowserViewController ()

@end



@implementation WebBrowserViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	
	_webView.delegate = self;
	[_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"https://www.google.com/"]]];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
	if ([self requestIsDownloadable:request])
	{
		[self initializeDownload:request];
		
		
		return NO;
	}
	
	
	return YES;
}


- (BOOL)requestIsDownloadable: (NSURLRequest *)request
{
	NSString *requestString = [[request URL] absoluteString];
	NSString *fileType = [requestString pathExtension];
	NSLog(@"FileType: %@", fileType);
	BOOL *isDownloadable = (
		([fileType caseInsensitiveCompare:@"zip"] == NSOrderedSame) ||
		([fileType caseInsensitiveCompare:@"rar"] == NSOrderedSame)
	);
	
	
	return isDownloadable;
}


- (void)initializeDownload: (NSURLRequest *)download
{
	UIAlertController *downloadAlertController = [UIAlertController
												  alertControllerWithTitle:@"Download Detected!"
												  message:@"Would you like to download this file?"
												  preferredStyle:UIAlertControllerStyleAlert];
	UIAlertAction *cancelAction = [UIAlertAction
								   actionWithTitle:NSLocalizedString(@"Nope", @"Cancel action")
								   style:UIAlertActionStyleCancel
								   handler:^(UIAlertAction *action)
								   {
									   NSLog(@"Download Cancelled.");
								   }];
	UIAlertAction *okAction = [UIAlertAction
							   actionWithTitle:NSLocalizedString(@"Download", @"OK action")
							   style:UIAlertActionStyleDefault
							   handler:^(UIAlertAction *action)
							   {
								   UIAlertController *downloadingAlertController = [UIAlertController
																					alertControllerWithTitle:[NSString stringWithFormat:@"Downloading..."]
																					message:@"Please wait while your file downloads.\nThis alert will disappear when it's done."
																					preferredStyle:UIAlertControllerStyleAlert];
								   
								   [self presentViewController:downloadingAlertController animated:YES completion:nil];
								   
								   dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),^{
									   NSString *urlToDownload = [[download URL] absoluteString];
									   NSURL  *url = [NSURL URLWithString:urlToDownload];
									   NSData *urlData = [NSData dataWithContentsOfURL:url];
									   
									   
									   if (urlData)
									   {
										   NSLog(@"Download Starting...");
										   NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
										   NSString *documentsDirectory = [paths objectAtIndex:0];
										   NSString *filePath = [NSString stringWithFormat:@"%@/%@", documentsDirectory, [urlToDownload lastPathComponent]];
										   dispatch_async(dispatch_get_main_queue(), ^{
											   [urlData writeToFile:filePath atomically:YES];
											   NSLog(@"Done.");
											   [downloadingAlertController dismissViewControllerAnimated:YES completion:nil];
										   });
									   }
									});
							   }];
	[downloadAlertController addAction:cancelAction];
	[downloadAlertController addAction:okAction];
	[self presentViewController:downloadAlertController animated:YES completion:nil];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
