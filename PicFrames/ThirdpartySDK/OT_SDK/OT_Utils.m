//
//  OT_Utils.m
//  Instacolor Splash
//
//  Created by Vijaya kumar reddy Doddavala on 7/26/12.
//  Copyright (c) 2012 motorola. All rights reserved.
//

#import "OT_Utils.h"

OT_Settings otNvm;
@implementation OT_Utils


+(NSString*)getOTSettingsFilePath
{
	NSArray  *paths        = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *docDirectory = [paths objectAtIndex:0];
	NSString *pFileName    = nil;
	
	/* file name */
	pFileName = @"OTsettings.txt";
	
	/* Return the path to the puzzle status information */
	return [docDirectory stringByAppendingPathComponent:pFileName];
}

+(NSString*)getCurrentOTApplistVersion
{
    NSData *data;
    NSFileHandle *fd;
    
    if(YES == [[NSFileManager defaultManager] fileExistsAtPath:[OT_Utils getOTSettingsFilePath]])
    {            
        /* File exist so read the saved status from the file  */
        fd = [NSFileHandle fileHandleForReadingAtPath:[OT_Utils getOTSettingsFilePath]];
        
        /* Read the data from the file */
        if([(data = [fd readDataOfLength:sizeof(OT_Settings)]) length]>0)
        {			
            memcpy(&otNvm, [data bytes], sizeof(OT_Settings));
        }
        
        [fd closeFile];
    }
    else
    {
        memset(&otNvm, 0, sizeof(OT_Settings));
        /* File doesn't exist so create one for future usage */
        if(NO == [[NSFileManager defaultManager] createFileAtPath:[OT_Utils getOTSettingsFilePath] contents:nil attributes:nil])
        {
            return nil;
        }
    }
    
    return [NSString stringWithFormat:@"%s",otNvm.applistVer];
}

+(void)setCurrentOTApplistVersion:(NSString*)ver
{
    NSData *data;
    NSFileHandle *fd;
    
    memcpy(&otNvm.applistVer[0], [ver UTF8String], strlen([ver UTF8String]));
    
    /* write the default status information to the file */
    data = [[NSData alloc] initWithBytes:&otNvm length:sizeof(OT_Settings)];
    
    if(YES == [[NSFileManager defaultManager] fileExistsAtPath:[OT_Utils getOTSettingsFilePath]])
    {            
        /* Open the File */
		fd = [NSFileHandle fileHandleForWritingAtPath:[OT_Utils getOTSettingsFilePath]];
		
		/* Write the data to the file */
		[fd writeData:data];
		
		/* Close the file */
		[fd closeFile];
    }
    else
    {
        /* File doesn't exist so create one for future usage */
        if(NO == [[NSFileManager defaultManager] createFileAtPath:[OT_Utils getOTSettingsFilePath] contents:data attributes:nil])
        {
            return;
        }
    }
    
    [data release];
    
    return;
}

+(BOOL)isOTApplistVersionIsSameAs:(NSString*)ver
{
    NSString *curVer = [OT_Utils getCurrentOTApplistVersion];
    
    return [ver isEqualToString:curVer];
}

+(NSString*)getOTiconDirectoryPath
{
    NSArray  *paths        = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *docDirectory = [paths objectAtIndex:0];
	NSString *pDirName    = @"Icons";
    
    
    return [docDirectory stringByAppendingPathComponent:pDirName];
}

+(NSString*)getOTiconPathForApp:(NSString*)appid
{
    NSArray  *paths        = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *docDirectory = [paths objectAtIndex:0];
	NSString *pDirName    = @"Icons";
    NSString *pDirPath    = [docDirectory stringByAppendingPathComponent:pDirName];
    NSString *iconName    = [NSString stringWithFormat:@"%@.png",appid];
    
    return [pDirPath stringByAppendingPathComponent:iconName];
}

+(void)saveIcon:(UIImage*)img ForApp:(NSString*)appid
{
    /* First Make sure that our directory exist */
    if(NO == [[NSFileManager defaultManager] fileExistsAtPath:[OT_Utils getOTiconDirectoryPath]])
    {
        /* If not create the directory */
        if(NO == [[NSFileManager defaultManager] createDirectoryAtPath:[OT_Utils getOTiconDirectoryPath] withIntermediateDirectories:NO attributes:nil error:nil])
        {
            NSLog(@"Failed to Create directory");
            return;
        }
    }
    
    /* Create the file inside the directory with appid as the file name */
    NSData *data = UIImagePNGRepresentation(img);
    NSFileManager *filemgr = [NSFileManager defaultManager];
    NSMutableDictionary *attributes = [NSMutableDictionary dictionaryWithCapacity:1];
    [attributes setObject:[NSNumber numberWithInt:511] forKey:NSFilePosixPermissions];
    
    NSLog(@"saveIcon: %@",[OT_Utils getOTiconPathForApp:appid]);
    /* Now create the file with image contents */    
    if(NO == [filemgr createFileAtPath:[OT_Utils getOTiconPathForApp:appid] contents:data attributes:attributes])
    {
        NSLog(@"Failed to create the file");
    }
    
    
}

+(UIImage *)getIconForApp:(NSString*)appId
{
    UIImage  *img          = nil;
    
    if(nil == appId)
    {
        NSLog(@"getIconForApp - Appid is nil");
        return nil;
    }
    
    /* now get the image from the current session */
    if([[NSFileManager defaultManager] fileExistsAtPath:[OT_Utils getOTiconPathForApp:appId]])
    {
        img = [UIImage imageWithContentsOfFile:[OT_Utils getOTiconPathForApp:appId]];
    }
    else 
    {
        NSLog(@"getIconForApp: icon not found at %@",[OT_Utils getOTiconPathForApp:appId]);
    }
    
    return img;
}

+(void)deleteAllIcons
{
    NSLog(@"deleteAllIcons------------------------------");
    if(YES == [[NSFileManager defaultManager] fileExistsAtPath:[OT_Utils getOTiconDirectoryPath]])
    {
        if(NO == [[NSFileManager defaultManager]removeItemAtPath:[OT_Utils getOTiconDirectoryPath] error:nil])
        {
            NSLog(@"Failed to delete the directory at %@",[OT_Utils getOTiconDirectoryPath]);
        }
    }
}

@end
