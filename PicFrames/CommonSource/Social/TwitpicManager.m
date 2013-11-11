//
//  TwitpicManager.m
//  GlowLabels
//
//  Created by Vijaya kumar reddy Doddavala on 8/3/11.
//  Copyright 2011 motorola. All rights reserved.
//

#import "TwitpicManager.h"


@implementation TwitpicManager

@synthesize delegate;
//@synthesize pUser;
//@synthesize pPassword;

-(void)initDefaults
{
    //self.pUser = nil;
    //self.pPassword = nil;
}

-(void)dealloc
{
    //self.pUser = nil;
    //self.pPassword = nil;
    self.delegate = nil;
    
    [super dealloc];
}
- (void)parserDidStartDocument:(NSXMLParser *)parser 
{
}

- (void)parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError 
{
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName 
  namespaceURI:(NSString *)namespaceURI 
 qualifiedName:(NSString *)qName 
    attributes:(NSDictionary *)attributeDict
{
    if([elementName isEqualToString:@"rsp"])
    {
        NSString *p = [attributeDict objectForKey:@"stat"];
        if(p)
        {
            if([p isEqualToString:@"fail"])
            {
                NSLog(@"Twitter Failed %@",attributeDict);
            }
        }
        
        p = [attributeDict objectForKey:@"status"];
        if(p)
        {
            if([p isEqualToString:@"ok"])
            {
                [delegate updateCommand:UPLOAD_TWITTER status:YES msg:nil];
                [self release];
                return;
            }
        }
    }
    
    if([elementName isEqualToString:@"err"])
    {
        NSString *p = [attributeDict objectForKey:@"msg"];
        [delegate updateCommand:UPLOAD_TWITTER status:NO msg:p];
        [self release];
        return;
    }
    
	return;
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName 
  namespaceURI:(NSString *)namespaceURI 
 qualifiedName:(NSString *)qName
{
}        

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
}

- (void)parserDidEndDocument:(NSXMLParser *)parser 
{
    [parser release];
}

-(void)sendPhotoToTwitpic:(id)sender
{
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    
    NSMutableURLRequest*postRequest = sender;
    
    // pointers to some necessary objects
    NSURLResponse* response;
    NSError* error = nil;
    
    // synchronous filling of data from HTTP POST response
    NSData *responseData = [NSURLConnection sendSynchronousRequest:postRequest returningResponse:&response error:&error];
    
    if (error)
    {
        [delegate updateCommand:UPLOAD_TWITTER status:NO msg:[error localizedDescription]];
        [pool release];
        [self release];
        return;
    }
    
    /* allocate the parser */
	NSXMLParser *xmlParser = [[NSXMLParser alloc] initWithData:responseData];
	//xmlParser    = pTmp;
	
	/* set the delegate and configure the parser */
    [xmlParser setDelegate:self];
    [xmlParser setShouldProcessNamespaces:NO];
    [xmlParser setShouldReportNamespacePrefixes:NO];
    [xmlParser setShouldResolveExternalEntities:NO];
    [xmlParser parse];
	
	/* release the resources */
	//[pData release];
	//[pTmp  release];
    
    [pool release];
}

//+(void)upload:(UIImage*)pImg withStatus:(NSString*)pstr
-(void)upload:(UIImage*)pImg withStatus:(NSString*)pstr user:(NSString*)usr password:(NSString*)pass
{
    // create the URL
    //NSURL *postURL = [NSURL URLWithString:@"http://twitpic.com/api/upload"];
    NSURL *postURL = [NSURL URLWithString:@"http://twitpic.com/api/uploadAndPost"];
    
    // create the connection
    NSMutableURLRequest *postRequest = [NSMutableURLRequest requestWithURL:postURL
                                                               cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                           timeoutInterval:30.0];
    
    // change type to POST (default is GET)
    [postRequest setHTTPMethod:@"POST"];
    
    // just some random text that will never occur in the body
    NSString *stringBoundary = @"0xKhTmLbOuNdArY---This_Is_ThE_BoUnDaRyy---pqo";
    
    // header value
    NSString *headerBoundary = [NSString stringWithFormat:@"multipart/form-data; boundary=%@",
                                stringBoundary];
    
    // set header
    [postRequest addValue:headerBoundary forHTTPHeaderField:@"Content-Type"];
    
    // create data
    NSMutableData *postBody = [NSMutableData data];
    
    //NSString *username = @"vijaydoddavala";
    //NSString *password = @"vj1234";
    //NSString *message = @"From Glow Mail Free Iphone App";
    NSString *message = @"Uploaded new photo from http://tinyurl.com/PhotoSplash Photo Splash Free Iphone App ";
    
    // username part
    [postBody appendData:[[NSString stringWithFormat:@"--%@\r\n", stringBoundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [postBody appendData:[@"Content-Disposition: form-data; name=\"username\"\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    [postBody appendData:[usr dataUsingEncoding:NSUTF8StringEncoding]];
    [postBody appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    
    // password part
    [postBody appendData:[[NSString stringWithFormat:@"--%@\r\n", stringBoundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [postBody appendData:[@"Content-Disposition: form-data; name=\"password\"\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    [postBody appendData:[pass dataUsingEncoding:NSUTF8StringEncoding]];
    [postBody appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    
    // message part
    [postBody appendData:[[NSString stringWithFormat:@"--%@\r\n", stringBoundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [postBody appendData:[@"Content-Disposition: form-data; name=\"message\"\r\n\r\n"dataUsingEncoding:NSUTF8StringEncoding]];
    [postBody appendData:[message dataUsingEncoding:NSUTF8StringEncoding]];
    [postBody appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    
    // media part
    [postBody appendData:[[NSString stringWithFormat:@"--%@\r\n", stringBoundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [postBody appendData:[@"Content-Disposition: form-data; name=\"media\"; filename=\"ColorSplurge.jpg\"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    [postBody appendData:[@"Content-Type: image/jpeg\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    [postBody appendData:[@"Content-Transfer-Encoding: binary\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    
    NSData *imageData = UIImageJPEGRepresentation(pImg, 1.0);
    
    
    // get the image data from main bundle directly into NSData object
    //NSString *imagePath = [[NSBundle mainBundle] pathForResource:@"ashrith" ofType:@"JPG"];
    //NSData *imageData = [NSData dataWithContentsOfFile:imagePath];
    
    // add it to body
    [postBody appendData:imageData];
    [postBody appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    
    // final boundary
    [postBody appendData:[[NSString stringWithFormat:@"--%@--\r\n", stringBoundary] dataUsingEncoding:NSUTF8StringEncoding]];
    
    // add body to post
    [postRequest setHTTPBody:postBody];
    
    /* Start a thread to send the request */
    [NSThread detachNewThreadSelector:@selector(sendPhotoToTwitpic:) 
                             toTarget:self 
                           withObject:postRequest];
    

    return;
}

@end
