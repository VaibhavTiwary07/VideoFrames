//
//  YouTubeView.m
//  ShareView
//
//  Created by Outthinking Mac 1 on 07/09/13.
//  Copyright (c) 2013 OutThinking India Pvt Ltd. All rights reserved.
//

#import "YouTubeView.h"
#import "GDataServiceGoogleYouTube.h"
#import "GDataEntryYouTubeUpload.h"
#import <QuartzCore/QuartzCore.h>
#import "Config.h"
#define fullscreen ([[UIScreen mainScreen]bounds])

//#define DEVELOPER_KEY @"AIzaSyB6NlVCEcvrC65kvu7sKxB4QUL0pHasygk"
//#define CLIENT_ID @"931848011819.apps.googleusercontent.com" // ID of your registered app at Google
//#define DEVELOPER_KEY @"AIzaSyDcB-D77dsVexdumJPhRh_jL8YWue5dztM"
//#define CLIENT_ID @"819081514969.apps.googleusercontent.com"
@interface YouTubeView (PrivateMethods)

- (GDataServiceTicket *)uploadTicket;
- (void)setUploadTicket:(GDataServiceTicket *)ticket;
- (GDataServiceGoogleYouTube *)youTubeService;

@end


@implementation YouTubeView

@synthesize mUsernameField;
@synthesize mPasswordField;
@synthesize mProgressView;
@synthesize filePath;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initialization];
    }
    return self;
}

- (void)initialization
{
    [self setBackgroundColor:[UIColor colorWithRed:0.1 green:0.1 blue:0.1 alpha:0.8]];
    baseView = [[UIView alloc] init];
    baseView . frame = CGRectMake(0, 0, 340, 340);
    baseView . center = CGPointMake(full_screen.size.width/2, full_screen.size.height/2);
    baseView . userInteractionEnabled = YES;
    baseView . backgroundColor = [UIColor clearColor];
    [self addSubview:baseView];
    
    backgroundImage = [[UIImageView alloc] initWithFrame:CGRectMake(20, 20, 300, 300)];
    //backgroundImage.center = CGPointMake(fullscreen.size.width/2, fullscreen.size.height/2);
    backgroundImage . image = [UIImage imageNamed:@"youtube_background.png"];
   // backgroundImage . layer. borderColor = [[UIColor grayColor] CGColor];
    //backgroundImage . layer .borderWidth = 5.0;
    backgroundImage . userInteractionEnabled = YES;
    [baseView addSubview:backgroundImage];

    // Too lazy to create different IBOutlets, they are UITextFields for the future...
    mDeveloperKeyField = [[UITextField alloc] init];
    mDescriptionField.frame = CGRectMake(100, 10, 100, 50);
    //[self.view addSubview:mDescriptionField];

    mClientIDField = [[UITextField alloc] init];
    mClientIDField.frame = CGRectMake(100, 70, 100, 50);
    //[self.view addSubview:mClientIDField];

    mTitleField = [[UITextField alloc] init];
    mDescriptionField = [[UITextField alloc] init];

    mUsernameField = [[UITextField alloc] initWithFrame:CGRectMake(110, 75, 138, 35)];
    mUsernameField . backgroundColor = [UIColor clearColor];
    mUsernameField.textColor = [UIColor whiteColor];
    mUsernameField . textAlignment = NSTextAlignmentLeft;
    mUsernameField . contentVerticalAlignment = UIControlContentHorizontalAlignmentCenter;
    [backgroundImage addSubview:mUsernameField];

    mPasswordField = [[UITextField alloc] initWithFrame:CGRectMake(110, 130, 138,35)];
    mPasswordField . backgroundColor = [UIColor clearColor];
    mPasswordField . secureTextEntry = YES;
    mPasswordField . textColor = [UIColor whiteColor];
    mPasswordField.textAlignment = NSTextAlignmentLeft;
    mPasswordField . contentVerticalAlignment = UIControlContentHorizontalAlignmentCenter;
    [mPasswordField resignFirstResponder];
    [backgroundImage addSubview:mPasswordField];

    UIButton *but = [UIButton buttonWithType:UIButtonTypeCustom];
    but . tag = 10;
    but.frame = CGRectMake(180, 200, 100, 40);
    but . center = CGPointMake(150, 220);
    [but setImage:[UIImage imageNamed:@"upload.png"] forState:UIControlStateNormal];
    [but addTarget:self action:@selector(uploadPressed:) forControlEvents:UIControlEventTouchUpInside];
    [backgroundImage addSubview:but];

    UIButton *cancle = [UIButton buttonWithType:UIButtonTypeCustom];
    cancle . tag = 20;
    cancle.frame = CGRectMake(baseView.frame.size.width-40 , 0 , 40, 40);
    //cancle . center = CGPointMake(backgroundImage.frame.size.width-10, 0);
    [cancle setImage:[UIImage imageNamed:@"cross.png"] forState:UIControlStateNormal];
    [cancle addTarget:self action:@selector(canclePressed) forControlEvents:UIControlEventTouchUpInside];
    [baseView addSubview:cancle];
    [baseView bringSubviewToFront:cancle];

    mKeywordsField = [[UITextField alloc] init];
    mKeywordsField . frame = CGRectMake(100, 250, 100, 50);
    // [self.view addSubview:mKeywordsField];

    mCategoryField = [[UITextField alloc] init];

    [mDeveloperKeyField setText: youtube_developerKey];
    [mClientIDField setText: youtube_clienID];
    [mTitleField setText: [NSString stringWithFormat:@"%@'s Video",appname]];
    [mDescriptionField setText: [NSString stringWithFormat:@"This Video is created by %@",appname]];
    [mKeywordsField setText: @""];
    [mCategoryField setText: @"Entertainment"];
    mIsPrivate = NO;

}

-(void)canclePressed
{
    [self removeFromSuperview];
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self endEditing:YES];
}

- (void)dealloc {
    [mUsernameField release];
    [mPasswordField release];
    [mDeveloperKeyField release];
    [mClientIDField release];
    [mTitleField release];
    [mDescriptionField release];
    [mKeywordsField release];
    [mCategoryField release];
    [mProgressView release];

    [mUploadTicket release];
    [baseView release];

    [super dealloc];
}

#pragma mark -
#pragma mark IBAction

- (IBAction)uploadPressed:(UIButton *)aButton {

    aButton.hidden = YES;
    UIButton *cancleBtton = (UIButton *)[backgroundImage viewWithTag:20];
    cancleBtton . enabled = NO;

    mProgressView = [[UIProgressView alloc] initWithFrame:CGRectMake(100, 250, 120, 20)];
    mProgressView . hidden = NO;
    mProgressView  . center = CGPointMake(150, 220);
    [backgroundImage addSubview:mProgressView];

    NSString *devKey = [mDeveloperKeyField text];

    GDataServiceGoogleYouTube *service = [self youTubeService];
    [service setYouTubeDeveloperKey:devKey];

    //   NSString *username = [mUsernameField text];
    NSString *clientID = [mClientIDField text];

    NSURL *url = [GDataServiceGoogleYouTube youTubeUploadURLForUserID:@"default"
                                                             clientID:clientID];

    // load the file data
    NSString *path = filePath;
    NSData *data = [NSData dataWithContentsOfFile:path];
    NSString *filename = [path lastPathComponent];

    // gather all the metadata needed for the mediaGroup
    NSString *titleStr = [mTitleField text];
    GDataMediaTitle *title = [GDataMediaTitle textConstructWithString:titleStr];

    NSString *categoryStr = [mCategoryField text];
    GDataMediaCategory *category = [GDataMediaCategory mediaCategoryWithString:categoryStr];
    [category setScheme:kGDataSchemeYouTubeCategory];

    NSString *descStr = [mDescriptionField text];
    GDataMediaDescription *desc = [GDataMediaDescription textConstructWithString:descStr];

    NSString *keywordsStr = [mKeywordsField text];
    GDataMediaKeywords *keywords = [GDataMediaKeywords keywordsWithString:keywordsStr];

    BOOL isPrivate = mIsPrivate;

    GDataYouTubeMediaGroup *mediaGroup = [GDataYouTubeMediaGroup mediaGroup];
    [mediaGroup setMediaTitle:title];
    [mediaGroup setMediaDescription:desc];
    [mediaGroup addMediaCategory:category];
    [mediaGroup setMediaKeywords:keywords];
    [mediaGroup setIsPrivate:isPrivate];

    NSString *mimeType = [GDataUtilities MIMETypeForFileAtPath:path
                                               defaultMIMEType:@"video/mp4"];

    // create the upload entry with the mediaGroup and the file data
    GDataEntryYouTubeUpload *entry;
    entry = [GDataEntryYouTubeUpload uploadEntryWithMediaGroup:mediaGroup
                                                          data:data
                                                      MIMEType:mimeType
                                                          slug:filename];

    SEL progressSel = @selector(ticket:hasDeliveredByteCount:ofTotalByteCount:);
    [service setServiceUploadProgressSelector:progressSel];

    GDataServiceTicket *ticket;
    ticket = [service fetchEntryByInsertingEntry:entry
                                      forFeedURL:url
                                        delegate:self
                               didFinishSelector:@selector(uploadTicket:finishedWithEntry:error:)];

    [self setUploadTicket:ticket];


}

#pragma mark -


// get a YouTube service object with the current username/password
//
// A "service" object handles networking tasks.  Service objects
// contain user authentication information as well as networking
// state information (such as cookies and the "last modified" date for
// fetched data.)

- (GDataServiceGoogleYouTube *)youTubeService {

    static GDataServiceGoogleYouTube* service = nil;

    if (!service) {
        service = [[GDataServiceGoogleYouTube alloc] init];

        [service setShouldCacheDatedData:YES];
        [service setServiceShouldFollowNextLinks:YES];
        [service setIsServiceRetryEnabled:YES];
    }

    // update the username/password each time the service is requested
    NSString *username = [mUsernameField text];
    NSString *password = [mPasswordField text];

    if ([username length] > 0 && [password length] > 0) {
        [service setUserCredentialsWithUsername:username
                                       password:password];
    } else {
        // fetch unauthenticated
        [service setUserCredentialsWithUsername:nil
                                       password:nil];
    }

    NSString *devKey = [mDeveloperKeyField text];
    [service setYouTubeDeveloperKey:devKey];

    return service;
}

// progress callback
- (void)ticket:(GDataServiceTicket *)ticket
hasDeliveredByteCount:(unsigned long long)numberOfBytesRead
ofTotalByteCount:(unsigned long long)dataLength {

    [mProgressView setProgress:(double)numberOfBytesRead / (double)dataLength];
}

// upload callback
- (void)uploadTicket:(GDataServiceTicket *)ticket
   finishedWithEntry:(GDataEntryYouTubeVideo *)videoEntry
               error:(NSError *)error {

    UIButton *uploadButton = (UIButton *)[backgroundImage viewWithTag:10];
    UIButton   *cancleButton = (UIButton *)[backgroundImage viewWithTag:20];
    if (error == nil) {
        // tell the user that the add worked

        [WCAlertView showAlertWithTitle:@"Video Uplaoed to Youtube"
                                message:[NSString stringWithFormat:@"%@ succesfully uploaded to Youtube",
                                         [[videoEntry title] stringValue]]
                     customizationBlock:nil
                        completionBlock:^(NSUInteger buttonIndex, WCAlertView *alertView){
                            [self removeFromSuperview];
                        }cancelButtonTitle:NSLocalizedString(@"OK", @"")
                      otherButtonTitles:nil];



    } else {

        [WCAlertView showAlertWithTitle:@"Failed"
                                message:@"Failed to upload Video in youtube"
                     customizationBlock:nil
                        completionBlock:^(NSUInteger buttonIndex, WCAlertView *alertView){
                            [self removeFromSuperview];
                        }cancelButtonTitle:NSLocalizedString(@"OK", @"")
                      otherButtonTitles:nil];


    }

    mProgressView . hidden = YES;
    uploadButton . hidden = NO;
    cancleButton . enabled = YES;

    [mProgressView setProgress: 0.0];

    [self setUploadTicket:nil];
}

#pragma mark -
#pragma mark Setters

- (GDataServiceTicket *)uploadTicket {
    return mUploadTicket;
}

- (void)setUploadTicket:(GDataServiceTicket *)ticket {
    [mUploadTicket release];
    mUploadTicket = [ticket retain];
}

@end
