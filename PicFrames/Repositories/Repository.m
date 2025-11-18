//
//  Repository.m
//  PicFrames
//
//  Created by Claude on 2025-11-18.
//

#import "Repository.h"
#import "FMDatabase.h"
#import "DBUtilities.h"

// Error domain
static NSString * const kRepositoryErrorDomain = @"com.picframes.repository";

@interface BaseRepository ()
@property (nonatomic, strong, readwrite) NSString *databasePath;
@end

@implementation BaseRepository

#pragma mark - Initialization

- (instancetype)initWithDatabasePath:(NSString *)databasePath {
    self = [super init];
    if (self) {
        _databasePath = databasePath;
    }
    return self;
}

- (instancetype)init {
    // Get default database path
    NSString *databaseName = @"picframes.sqlite"; // Default from Config.h PICFARME_DATABASE
    NSArray *documentPaths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *documentsDir = [documentPaths objectAtIndex:0];
    NSString *dbPath = [documentsDir stringByAppendingPathComponent:databaseName];

    return [self initWithDatabasePath:dbPath];
}

#pragma mark - Repository Protocol

- (BOOL)isDatabaseAvailable {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    return [fileManager fileExistsAtPath:self.databasePath];
}

- (BOOL)performDatabaseOperation:(BOOL (^)(NSError **))block error:(NSError **)error {
    if (!block) {
        if (error) {
            *error = [NSError errorWithDomain:kRepositoryErrorDomain
                                         code:-1
                                     userInfo:@{NSLocalizedDescriptionKey: @"Block cannot be nil"}];
        }
        return NO;
    }

    return block(error);
}

#pragma mark - Database Access

- (nullable FMDatabase *)openDatabaseWithError:(NSError **)error {
    // Ensure database exists
    [DBUtilities checkAndCreateDatabase];

    FMDatabase *db = [FMDatabase databaseWithPath:self.databasePath];

    if (![db open]) {
        if (error) {
            *error = [NSError errorWithDomain:kRepositoryErrorDomain
                                         code:-100
                                     userInfo:@{NSLocalizedDescriptionKey: @"Could not open database",
                                               NSFilePathErrorKey: self.databasePath}];
        }
        return nil;
    }

    return db;
}

- (nullable NSArray<NSDictionary *> *)executeQuery:(NSString *)query
                                         arguments:(nullable NSArray *)arguments
                                             error:(NSError **)error {
    if (!query) {
        if (error) {
            *error = [NSError errorWithDomain:kRepositoryErrorDomain
                                         code:-200
                                     userInfo:@{NSLocalizedDescriptionKey: @"Query cannot be nil"}];
        }
        return nil;
    }

    FMDatabase *db = [self openDatabaseWithError:error];
    if (!db) return nil;

    FMResultSet *results = [db executeQuery:query withArgumentsInArray:arguments];

    if (!results) {
        if (error) {
            *error = [NSError errorWithDomain:kRepositoryErrorDomain
                                         code:-201
                                     userInfo:@{NSLocalizedDescriptionKey: [db lastErrorMessage],
                                               @"query": query}];
        }
        [db close];
        return nil;
    }

    NSMutableArray *rows = [NSMutableArray array];
    while ([results next]) {
        [rows addObject:[results resultDict]];
    }

    [results close];
    [db close];

    return [rows copy];
}

- (BOOL)executeUpdate:(NSString *)query
            arguments:(nullable NSArray *)arguments
                error:(NSError **)error {
    if (!query) {
        if (error) {
            *error = [NSError errorWithDomain:kRepositoryErrorDomain
                                         code:-300
                                     userInfo:@{NSLocalizedDescriptionKey: @"Query cannot be nil"}];
        }
        return NO;
    }

    FMDatabase *db = [self openDatabaseWithError:error];
    if (!db) return NO;

    BOOL success = [db executeUpdate:query withArgumentsInArray:arguments];

    if (!success) {
        if (error) {
            *error = [NSError errorWithDomain:kRepositoryErrorDomain
                                         code:-301
                                     userInfo:@{NSLocalizedDescriptionKey: [db lastErrorMessage],
                                               @"query": query}];
        }
    }

    [db close];
    return success;
}

@end
