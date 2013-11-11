//
//  DBUtilities.m
//  PicFrame
//
//  Created by Vijaya kumar reddy Doddavala on 2/28/12.
//  Copyright (c) 2012 motorola. All rights reserved.
//

#import "DBUtilities.h"

@implementation DBUtilities

+(BOOL)checkIfTableExistsWithName:(NSString*)name
{
    // SELECT name FROM sqlite_master WHERE type='table' AND name='table_name'
    
    /* Open Database */
    NSString *databaseName = PICFARME_DATABASE;
    NSArray *documentPaths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *documentsDir = [documentPaths objectAtIndex:0];
    NSString *dbPath       = [documentsDir stringByAppendingPathComponent:databaseName];
    NSString *nme = nil;
    
    /* First make sure that database is copied to filesystem */
    //[DBUtilities checkAndCreateDatabase];
    
    /* open the database */
    FMDatabase* db = [FMDatabase databaseWithPath:dbPath];
    if (![db open])
    {
        [db release];
        NSLog(@"openDataBase:Could not open db.");
        return NO;
    }
    
    FMResultSet *result  = nil;
    
    /* First get the count of photos */
    result = [db executeQuery:@"select name from sqlite_master where type = ? and name = ?",[NSString stringWithFormat:@"table"],name];
    if(nil == result)
    {
        NSLog(@"getThePhotoInfoForFrameNumber:Could not get photo count");
        [db close];
        return NO;
    }
    
    while([result next])
    {
        nme = [result stringForColumn:@"name"];
    }
    
    [result close];
    [db close];
    
    if(nil == nme)
    {
        NSLog(@"checkIfTableExistsWithName: table(%@) doesn't exist",name);
        return NO;
    }
    
    //NSLog(@"checkIfTableExistsWithName: table(%@) exist",nme);
    
    return YES;
}

+(BOOL)checkAndCreateTheTableWithName:(NSString*)tableName
{
    if([[NSUserDefaults standardUserDefaults]boolForKey:tableName] == YES)
    {
        //NSLog(@"checkAndCreateTheTableWithName: table(%@) already exists",tableName);
        return YES;
    }
    
    /* First check if the table exist */
    if(YES == [self checkIfTableExistsWithName:tableName])
    {
        //NSLog(@"checkAndCreateTheShapesTables: table(%@) exists",tableName);
        return YES;
    }
    
    NSString *databaseName = PICFARME_DATABASE;
    NSArray *documentPaths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *documentsDir = [documentPaths objectAtIndex:0];
    NSString *dbPath       = [documentsDir stringByAppendingPathComponent:databaseName];
    
    /* First make sure that database is copied to filesystem */
    //[DBUtilities checkAndCreateDatabase];
    
    /* open the database */
    FMDatabase* db = [FMDatabase databaseWithPath:dbPath];
    if (![db open])
    {
        [db release];
        NSLog(@"openDataBase:Could not open db.");
        return NO;
    }
    
    [db beginTransaction];
    
    NSString *query = [NSString stringWithFormat:@"create table %@(id int primary key, sessionId int, photoIndex int, shape int)",tableName];
    /* create the table */
    [db executeUpdate:query];
    
    [[NSUserDefaults standardUserDefaults]setBool:YES forKey:tableName];
    
    [db commit];
    
    [db close];
    
    return YES;
}

+(void)checkAndCreateDatabase
{
    static int count = 0;
    
    count++;
    
	// Check if the SQL database has already been saved to the users phone, if not then copy it over
	NSString *databasePath     = nil;
	NSString *databaseName     = PICFARME_DATABASE;
	NSArray *documentPaths     = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
	NSString *documentsDir     = [documentPaths objectAtIndex:0];
	NSFileManager *fileManager = [NSFileManager defaultManager];
	
	// Get the path to the documents directory and append the databaseName
	databasePath = [documentsDir stringByAppendingPathComponent:databaseName];
	
	// Check if the database has already been created in the users filesystem
	if(YES == [fileManager fileExistsAtPath:databasePath])
	{
        [DBUtilities checkAndCreateTheTableWithName:@"shapes"];
        if(count == 1)
        {
            [fileManager removeItemAtPath:databasePath error:nil];
        }
        else
        {
            return;
        }
        /* Now check if  */
		//return;
	}
	
	// Get the path to the database in the application package
	NSString *databasePathFromApp = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:databaseName];
	
	// Copy the database from the package to the users filesystem
	[fileManager copyItemAtPath:databasePathFromApp toPath:databasePath error:nil];
    
    [DBUtilities checkAndCreateTheTableWithName:@"shapes"];
	
    //NSLog(@"checkAndCreateDatabase: Copied the database to file system");
    
	return;
}

+(FMDatabase*)openDataBase
{
    NSString *databaseName = PICFARME_DATABASE;
    NSArray *documentPaths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *documentsDir = [documentPaths objectAtIndex:0];
    NSString *dbPath       = [documentsDir stringByAppendingPathComponent:databaseName];
    
    /* First make sure that database is copied to filesystem */
    [DBUtilities checkAndCreateDatabase];
    
    /* open the database */
    FMDatabase* db = [FMDatabase databaseWithPath:dbPath];
    if (![db open]) 
    {
        [db release];
        NSLog(@"openDataBase:Could not open db.");
        return nil;
    }
    
    return db;
}

@end
