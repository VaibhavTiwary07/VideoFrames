//
//  Repository.h
//  PicFrames
//
//  Created by Claude on 2025-11-18.
//  Base protocol for all repository implementations
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/**
 * Repository pattern protocol defining common database operations.
 *
 * Benefits:
 * - Abstraction: Business logic doesn't know about SQL
 * - Testability: Can mock repositories easily
 * - Single Responsibility: Database access separated from business logic
 * - DRY: Common patterns defined once
 *
 * All repositories should conform to this protocol and provide
 * consistent error handling and async patterns.
 */
@protocol Repository <NSObject>

@required

/**
 * Get database connection status
 * @return YES if database is accessible
 */
- (BOOL)isDatabaseAvailable;

@optional

/**
 * Perform database operation with error handling
 * @param block Block containing database operations
 * @param error Error pointer for error reporting
 * @return YES if operation succeeded
 */
- (BOOL)performDatabaseOperation:(BOOL (^)(NSError **error))block
                           error:(NSError **)error;

@end

/**
 * Base class providing common repository functionality.
 *
 * Subclass this for concrete repository implementations:
 * - SessionRepository
 * - FrameRepository
 * - PhotoRepository
 *
 * Provides:
 * - Database path management
 * - Common error handling
 * - Connection pooling (via FMDB)
 */
@interface BaseRepository : NSObject <Repository>

/// Database file path
@property (nonatomic, strong, readonly) NSString *databasePath;

// MARK: - Initialization

/**
 * Initialize with custom database path (for testing)
 */
- (instancetype)initWithDatabasePath:(NSString *)databasePath NS_DESIGNATED_INITIALIZER;

/**
 * Initialize with default database path
 */
- (instancetype)init;

// MARK: - Database Access

/**
 * Open database connection
 * @param error Error pointer
 * @return FMDatabase instance or nil on error
 */
- (nullable id)openDatabaseWithError:(NSError **)error;

/**
 * Execute query and return results
 * @param query SQL query string
 * @param arguments Query arguments
 * @param error Error pointer
 * @return Array of result dictionaries or nil on error
 */
- (nullable NSArray<NSDictionary *> *)executeQuery:(NSString *)query
                                         arguments:(nullable NSArray *)arguments
                                             error:(NSError **)error;

/**
 * Execute update (INSERT, UPDATE, DELETE)
 * @param query SQL query string
 * @param arguments Query arguments
 * @param error Error pointer
 * @return YES if successful
 */
- (BOOL)executeUpdate:(NSString *)query
            arguments:(nullable NSArray *)arguments
                error:(NSError **)error;

@end

NS_ASSUME_NONNULL_END
