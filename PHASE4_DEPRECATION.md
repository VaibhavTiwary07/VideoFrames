# Phase 4: Legacy Database Class Deprecation

## Overview

Phase 4 formally deprecates the legacy `SessionDB` and `FrameDB` classes now that all code has been successfully migrated to use the modern Repository Pattern introduced in Phase 3.

## What Was Deprecated

### 1. SessionDB.h/m
**Status:** ⚠️ DEPRECATED
**Replaced By:** `SessionRepository` (PicFrames/Repositories/SessionRepository.h/m)

The `SessionDB` class contained direct SQL queries scattered throughout static methods. This approach had several issues:
- No error handling (silent failures)
- Manual memory management with malloc/free
- No type safety (void** pointers)
- Difficult to test
- SQL mixed with data access logic

**All functionality has been replaced** by SessionRepository with:
- ✅ Proper NSError handling
- ✅ Modern Objective-C types (NSArray<PhotoInfo *>)
- ✅ ARC memory management
- ✅ Testable via dependency injection
- ✅ Clean separation of concerns

### 2. FrameDB.h/m
**Status:** ⚠️ DEPRECATED
**Replaced By:** `FrameRepository` (PicFrames/Repositories/FrameRepository.h/m)

The `FrameDB` class managed frame template data with similar issues to SessionDB. All functionality has been migrated to FrameRepository with the same improvements.

## Migration Complete

**As of Phase 3B, all code has been migrated:**
- ✅ Session.m (10 SessionDB calls) → SessionRepository
- ✅ Frame.m (2 FrameDB calls) → FrameRepository
- ✅ No remaining direct SessionDB/FrameDB usage in codebase

## Deprecation Strategy

### Phase 4A: Soft Deprecation (DONE ✅)
1. Add deprecation macros to header files
2. Add warnings to implementation files
3. Document migration path in comments
4. Keep implementations functional for backward compatibility

### Phase 4B: Hard Deprecation (Future)
1. Remove deprecated classes from Xcode project
2. Delete SessionDB.h/m and FrameDB.h/m files
3. Update all documentation references
4. Remove from build targets

## Migration Guide

### If You Have Code Using SessionDB:

**BEFORE:**
```objc
#import "SessionDB.h"

// Old way - direct SQL, no error handling
stPhotoInfo *photos = NULL;
int count = [SessionDB getThePhotoInfoForSessionId:sessionId to:&photos];
for(int i = 0; i < count; i++) {
    // Use photos[i].dimension
}
free(photos); // Manual memory management
```

**AFTER:**
```objc
#import "ServiceContainer.h"
#import "SessionRepository.h"

// Modern way - repository pattern
SessionRepository *repo = [[ServiceContainer shared] sessionRepository];
NSError *error = nil;
NSArray<PhotoInfo *> *photos = [repo getPhotoInfoForSession:sessionId error:&error];

if (error) {
    NSLog(@"Error: %@", error.localizedDescription);
    return;
}

for (PhotoInfo *photo in photos) {
    // Use photo.dimension (type-safe)
}
// No free() needed - ARC handles it
```

### If You Have Code Using FrameDB:

**BEFORE:**
```objc
#import "FrameDB.h"

// Old way
stPhotoInfo *photos = NULL;
int count = [FrameDB getThePhotoInfoForFrameNumber:frameNumber to:&photos];
free(photos);
```

**AFTER:**
```objc
#import "ServiceContainer.h"
#import "FrameRepository.h"

// Modern way
FrameRepository *repo = [[ServiceContainer shared] frameRepository];
NSError *error = nil;
NSArray<PhotoInfo *> *photos = [repo getPhotoInfoForFrame:frameNumber error:&error];
if (error) {
    NSLog(@"Error: %@", error.localizedDescription);
}
```

## SessionDB → SessionRepository Method Mapping

| SessionDB Method | SessionRepository Method |
|-----------------|-------------------------|
| `getThePhotoInfoForSessionId:to:` | `getPhotoInfoForSession:error:` |
| `getTheImageInfoForSessionId:to:` | `getImageInfoForSession:error:` |
| `getTheAdjustorInfoForSessionId:to:` | `getAdjustorInfoForSession:adjustorInfo:error:` |
| `updateImageSizeInDBWith:forSession:atIndex:` | `updateImageSize:atPhotoIndex:forSession:error:` |
| `updateImageScaleInDBWith:offset:forSession:atIndex:` | `updateImageScale:offset:atPhotoIndex:forSession:error:` |
| `deleteSessionOfId:` | `deleteSession:error:` |
| `deleteSessionDimensionsOfId:` | `deleteSessionDimensions:error:` |

## FrameDB → FrameRepository Method Mapping

| FrameDB Method | FrameRepository Method |
|---------------|------------------------|
| `getThePhotoInfoForFrameNumber:to:` | `getPhotoInfoForFrame:error:` |
| `getTheAdjustorInfoForFrameNumber:to:` | `getAdjustorInfoForFrame:adjustorInfo:error:` |
| `getPhotoCountForFrameNumber:` | `getPhotoCountForFrame:error:` |

## Benefits of Migration

### 1. Error Handling
**Before:** Silent failures, no error information
```objc
int count = [SessionDB getThePhotoInfoForSessionId:sessionId to:&photos];
if (count == 0) {
    // Why did it fail? Database error? No data? Unknown!
}
```

**After:** Proper NSError with details
```objc
NSError *error = nil;
NSArray *photos = [repo getPhotoInfoForSession:sessionId error:&error];
if (error) {
    NSLog(@"Failed: %@ (code: %ld)", error.localizedDescription, error.code);
    // Can check error domain, code, and associated data
}
```

### 2. Type Safety
**Before:** void** pointers, manual casting
```objc
stPhotoInfo *photos = NULL; // Void** internally
// Manual memory management, easy to leak
```

**After:** Strong typing with generics
```objc
NSArray<PhotoInfo *> *photos = ...;
// Compile-time type checking
// Automatic memory management
```

### 3. Testability
**Before:** Cannot test without real database
```objc
// SessionDB uses static methods - cannot mock
[SessionDB getThePhotoInfoForSessionId:123 to:&photos];
```

**After:** Easy to mock for unit tests
```objc
// Create mock repository for testing
MockSessionRepository *mockRepo = [[MockSessionRepository alloc] init];
mockRepo.photoInfoToReturn = @[testPhoto1, testPhoto2];
[[ServiceContainer shared] setCustomSessionRepository:mockRepo];
// Now test without database!
```

### 4. Separation of Concerns
**Before:** SQL scattered throughout code
```objc
// Business logic mixed with SQL
FMDatabase *db = [FMDatabase databaseWithPath:path];
FMResultSet *rs = [db executeQuery:@"SELECT * FROM ..."];
// Direct database manipulation in every file
```

**After:** Clean abstraction layers
```objc
// Business logic only deals with repositories
SessionRepository *repo = [[ServiceContainer shared] sessionRepository];
NSArray *data = [repo getPhotoInfoForSession:sessionId error:&error];
// SQL is hidden in repository - single responsibility
```

## Deprecation Warnings

When compiling code that uses deprecated classes, you'll see:

```
warning: 'SessionDB' is deprecated: Use SessionRepository instead.
         See PHASE4_DEPRECATION.md for migration guide.
```

## Removal Timeline

### Phase 4A (Current)
- ⚠️ Classes marked as deprecated
- ✅ All migration completed
- ✅ Implementations still functional

### Phase 4B (Future - After Full Testing)
- 🗑️ Remove deprecated classes from Xcode project
- 🗑️ Delete SessionDB.h/m and FrameDB.h/m files
- 📝 Update build scripts if needed

## Files Modified in Phase 4

```
PicFrames/
├── SessionDB.h (added deprecation warnings)
├── FrameDB.h (added deprecation warnings)
└── SessionDB.m (added migration comments)
└── FrameDB.m (added migration comments)

Documentation/
└── PHASE4_DEPRECATION.md (this file)
```

## Backward Compatibility Notes

**SessionDB and FrameDB are still functional** - they still contain their original implementations. This ensures:
1. No breaking changes for any unmigrated code
2. Gradual migration possible
3. Easy rollback if issues discovered
4. Time to update any external dependencies

## Future Enhancements

After Phase 4B (removal of deprecated classes):
1. **Caching Layer** - Add CachedSessionRepository for performance
2. **Async/Await** - Convert repository methods to async with completion handlers
3. **Batch Operations** - Add methods like `getPhotoInfoForSessions:error:`
4. **Read-Only Variants** - Separate read and write repositories
5. **Database Migrations** - Add schema versioning to repositories

## Questions?

See:
- `PHASE3_REPOSITORY_PATTERN.md` for Repository Pattern details
- `PHASE2_DEPENDENCY_INJECTION.md` for ServiceContainer usage
- Repository source code for implementation details

## Summary

Phase 4 formally marks the legacy database classes as deprecated, guiding all future development toward the modern Repository Pattern. This completes the data access layer modernization started in Phase 3.

**Migration Status: 100% Complete** ✅

All code now uses the modern, testable, type-safe Repository Pattern!

---

**Phase 4 deprecates the old and cements the new architecture! 🚀**
