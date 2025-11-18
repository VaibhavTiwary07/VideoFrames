# Phase 3: Repository Pattern & Database Abstraction

## Overview

Phase 3 introduces the **Repository Pattern** to abstract all database access behind clean, testable interfaces. This eliminates direct SQL scattered throughout the code and establishes a modern data access layer following SOLID principles.

## What Was Created

### 1. Modern Model Classes

Replaced C structs with proper Objective-C classes:

#### **PhotoInfo** (`PicFrames/Models/PhotoInfo.h/m`)
- Replaces `stPhotoInfo` C struct
- Immutable value object with `NSCopying`
- Photo placement and shape information
- Easy conversion to/from legacy structs
- Database row deserialization

```objc
// OLD WAY (C struct - problematic)
stPhotoInfo *photos = malloc(sizeof(stPhotoInfo) * count);
// Manual memory management, no type safety

// NEW WAY (Modern Objective-C)
NSArray<PhotoInfo *> *photos = [sessionRepo getPhotoInfoForSession:sessionId error:&error];
// Automatic memory management, type safe, easy to test
```

#### **ImageInfo** (`PicFrames/Models/ImageInfo.h/m`)
- Replaces `stImageInfo` C struct
- Image transformation data (scale, offset, rotation)
- Provides `CGAffineTransform` conversion
- Equality and hashing for collections

### 2. Repository Infrastructure

#### **Repository Protocol** (`PicFrames/Repositories/Repository.h/m`)
Base protocol and implementation providing:
- Common database operations
- Consistent error handling with `NSError`
- Database connection management
- Query execution and result mapping

**BaseRepository** provides:
- Database path management
- Connection pooling (via FMDB)
- Query/update execution with error handling
- Foundation for all concrete repositories

### 3. Concrete Repositories

#### **SessionRepository** (`PicFrames/Repositories/SessionRepository.h/m`)
Handles all session database operations:
- `getPhotoInfoForSession:error:` - Retrieve photo layout
- `getImageInfoForSession:error:` - Retrieve image transformations
- `updateImageSize:atPhotoIndex:forSession:error:` - Update image dimensions
- `updateImageScale:offset:atPhotoIndex:forSession:error:` - Update transformations
- `deleteSession:error:` - Remove session and data
- `printSessionTable:` - Debug output

**Replaces**: Direct SQL in `SessionDB.m`

#### **FrameRepository** (`PicFrames/Repositories/FrameRepository.h/m`)
Handles frame template operations:
- `getPhotoInfoForFrame:error:` - Get frame photo layout
- `getAdjustorInfoForFrame:adjustorInfo:error:` - Get adjustor positions
- `getPhotoCountForFrame:error:` - Count photos in frame

**Replaces**: Direct SQL in `FrameDB.m`

### 4. ServiceContainer Integration

Updated `ServiceContainer` to provide repositories:
```objc
ServiceContainer *services = [ServiceContainer shared];
SessionRepository *sessionRepo = services.sessionRepository;
FrameRepository *frameRepo = services.frameRepository;
```

## Before & After Examples

### Example 1: Getting Photo Info

**BEFORE (Direct SQL - 80+ lines):**
```objc
// SessionDB.m - Scattered SQL, manual memory management
+(int)getThePhotoInfoForSessionId:(int)sessId to:(stPhotoInfo**)photoInfo
{
    FMDatabase* db = [FMDatabase databaseWithPath:dbPath];
    if (![db open]) {
        return 0; // Lost error information!
    }

    FMResultSet *photos = [db executeQuery:@"select * from sessiondimensions..."];
    // 30+ lines of manual struct population
    stPhotoInfo *PInfo = (stPhotoInfo*)malloc(sizeof(stPhotoInfo) * iPhotoCount);
    // Manual memory management - error prone!

    while([photos next]) {
        PInfo[count].dimension = CGRectMake(...);
        // Repetitive code...
        count++;
    }

    [photos close];
    [db close];
    *photoInfo = PInfo;
    return count;
}
```

**AFTER (Repository Pattern - Clean & Testable):**
```objc
// Using SessionRepository
NSError *error = nil;
NSArray<PhotoInfo *> *photos = [sessionRepo getPhotoInfoForSession:sessionId
                                                               error:&error];
if (!photos) {
    NSLog(@"Error: %@", error.localizedDescription);
    return;
}

// Type-safe, automatic memory management, proper error handling
for (PhotoInfo *photo in photos) {
    NSLog(@"Photo %ld: %@", photo.photoIndex, NSStringFromCGRect(photo.dimension));
}
```

### Example 2: Updating Image Scale

**BEFORE (Scattered in Session.m):**
```objc
// Direct SQL embedded in business logic
FMDatabase *db = [DBUtilities openDataBase];
[db executeUpdate:@"UPDATE sessiondimensions SET img_scale = ?, img_offset_x = ?, img_offset_y = ? WHERE sessionId = ? AND photoIndex = ?",
    @(scale), @(offset.x), @(offset.y), @(sessionId), @(photoIndex)];
[db close];
// No error handling, SQL mixed with logic
```

**AFTER (Clean Separation):**
```objc
// Business logic clearly separated from data access
ServiceContainer *services = [ServiceContainer shared];
NSError *error = nil;

BOOL success = [services.sessionRepository updateImageScale:scale
                                                      offset:offset
                                                atPhotoIndex:photoIndex
                                                  forSession:sessionId
                                                       error:&error];
if (!success) {
    // Proper error handling
    [self showError:error];
}
```

## Architecture Benefits

### 1. Single Responsibility Principle ✅
- **SessionRepository**: Only handles session data access
- **FrameRepository**: Only handles frame template access
- **Models (PhotoInfo, ImageInfo)**: Only represent data

Each class has ONE reason to change.

### 2. Dependency Inversion Principle ✅
- Business logic depends on `Repository` protocol (abstraction)
- Not on concrete SQL implementation (details)
- Can swap database implementations without changing business logic

### 3. Open/Closed Principle ✅
- Extend by creating new repositories
- Don't modify existing repositories
- Easy to add caching, logging, etc. via decoration

### 4. Testability 🚀
**Mock repositories for unit tests:**
```objc
// Test without database!
MockSessionRepository *mockRepo = [[MockSessionRepository alloc] init];
mockRepo.photoInfoToReturn = @[testPhotoInfo];

[services setCustomSessionRepository:mockRepo];

// Now test your view controller with mock data
MyViewController *vc = [[MyViewController alloc] initWithServices:services];
// ...assertions
```

### 5. DRY (Don't Repeat Yourself) ✅
- Database opening/closing logic: **1 place** (BaseRepository)
- Error handling: **1 pattern** (NSError**)
- Query execution: **1 method** (executeQuery:arguments:error:)

Before: Repeated 12+ times across files

### 6. Error Handling
**Before:** Silent failures, no error information
**After:** Proper `NSError` objects with:
- Error domain
- Error code
- Localized description
- Associated data (query, file path, etc.)

### 7. Type Safety
**Before:** `void**` pointers, manual casting, C structs
**After:** Strongly-typed Objective-C collections (`NSArray<PhotoInfo *>`)

## Migration Strategy

### Phase 3A: Infrastructure (DONE ✅)
- Created model classes
- Created repository protocol and base implementation
- Created SessionRepository and FrameRepository
- Integrated with ServiceContainer

### Phase 3B: Gradual Migration (Next)
1. **Update Session.m** to use SessionRepository
2. **Update Frame.m** to use FrameRepository
3. **Deprecate SessionDB.m and FrameDB.m**
4. **Add caching layer** to repositories (optional performance enhancement)

### Migration Pattern

**For each file using direct SQL:**

1. Identify the database operation
2. Find/create equivalent repository method
3. Replace direct SQL with repository call
4. Handle errors properly
5. Test
6. Remove old code

**Example:**
```objc
// FIND: Direct SQL
FMDatabase *db = [DBUtilities openDataBase];
FMResultSet *results = [db executeQuery:@"SELECT..."];

// REPLACE WITH: Repository
NSError *error = nil;
NSArray<PhotoInfo *> *photos = [services.sessionRepository
    getPhotoInfoForSession:sessionId error:&error];
```

## Integration with Xcode

**IMPORTANT:** Add these files to your Xcode project:

1. **Models/**
   - `PhotoInfo.h/m`
   - `ImageInfo.h/m`

2. **Repositories/**
   - `Repository.h/m` (base)
   - `SessionRepository.h/m`
   - `FrameRepository.h/m`

3. **Updated:**
   - `ServiceContainer.h/m`

**Steps:**
1. Open `VideoFrames.xcodeproj` in Xcode
2. Create "Models" group under PicFrames
3. Create "Repositories" group under PicFrames
4. Add files to respective groups
5. Ensure target "VideoFrames" is checked
6. Build to verify

## Testing Examples

### Unit Test with Mock Repository

```objc
@interface MockSessionRepository : SessionRepository
@property (nonatomic, strong) NSArray<PhotoInfo *> *mockPhotos;
@property (nonatomic, assign) BOOL shouldFail;
@end

@implementation MockSessionRepository

- (NSArray<PhotoInfo *> *)getPhotoInfoForSession:(NSInteger)sessionId
                                           error:(NSError **)error {
    if (self.shouldFail) {
        *error = [NSError errorWithDomain:@"test" code:-1 userInfo:nil];
        return nil;
    }
    return self.mockPhotos;
}

@end

// In your test
- (void)testSessionViewController {
    // Setup mock
    MockSessionRepository *mockRepo = [[MockSessionRepository alloc] init];
    mockRepo.mockPhotos = @[testPhoto1, testPhoto2];

    ServiceContainer *testServices = [[ServiceContainer alloc] init];
    [testServices setCustomSessionRepository:mockRepo];

    // Test with mocked data - no database needed!
    SessionViewController *vc = [[SessionViewController alloc] initWithServices:testServices];
    [vc loadPhotos];

    XCTAssertEqual(vc.photos.count, 2);
}
```

## Performance Considerations

### Current Implementation
- Each repository call opens/closes database
- Good for simplicity and thread safety
- Acceptable for current usage patterns

### Future Optimizations (if needed)
1. **Connection Pooling**: Reuse database connections
2. **Caching Layer**: Add `CachedSessionRepository` wrapper
3. **Batch Operations**: Add methods like `getPhotoInfoForSessions:error:`
4. **Async/Await**: Convert to async methods with completion blocks

## Files Summary

### Created (11 files):
```
PicFrames/Models/
├── PhotoInfo.h
├── PhotoInfo.m
├── ImageInfo.h
└── ImageInfo.m

PicFrames/Repositories/
├── Repository.h (protocol + base)
├── Repository.m
├── SessionRepository.h
├── SessionRepository.m
├── FrameRepository.h
└── FrameRepository.m
```

### Modified (2 files):
```
PicFrames/
├── ServiceContainer.h (added repository properties)
└── ServiceContainer.m (added repository lazy loading)
```

### To Be Deprecated (future):
```
PicFrames/
├── SessionDB.h/m (replaced by SessionRepository)
└── FrameDB.h/m (replaced by FrameRepository)
```

## Next Steps

1. **Add files to Xcode** (required before building)
2. **Migrate Session.m** to use SessionRepository
3. **Migrate Frame.m** to use FrameRepository
4. **Write unit tests** for repositories
5. **Add integration tests** for database operations
6. **Consider async patterns** for heavy operations

## SOLID Principles Applied

✅ **Single Responsibility**: Each repository handles ONE entity type
✅ **Open/Closed**: Extend via new repositories, don't modify existing
✅ **Liskov Substitution**: MockRepository can replace real repository
✅ **Interface Segregation**: Focused protocols (Repository)
✅ **Dependency Inversion**: Depend on Repository protocol, not SQL

## Questions?

See:
- `PHASE2_DEPENDENCY_INJECTION.md` for ServiceContainer usage
- Repository source code for detailed documentation
- FMDB documentation for database details

---

**Phase 3 establishes clean data access layer ready for the rest of the app to migrate to! 🚀**
