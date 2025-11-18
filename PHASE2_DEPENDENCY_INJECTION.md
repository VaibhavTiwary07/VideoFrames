# Phase 2: Dependency Injection Infrastructure

## Overview

Phase 2 introduces a **ServiceContainer** to manage app services and enable **Dependency Injection**, replacing direct singleton access throughout the app.

## What Was Created

### 1. ServiceContainer (`PicFrames/ServiceContainer.h/m`)

Centralized service locator that provides:
- Single point of access to all app services
- Dependency injection capabilities for testing
- Lazy initialization of services
- Clear service dependencies

### 2. SessionStateService (`PicFrames/Services/SessionStateService.h/m`)

Extracted from `Settings` singleton to manage session-related state:
- Current session index
- Current frame number
- Next free session allocation
- Persistent state storage

This demonstrates **Single Responsibility Principle** by separating concerns.

## Before (Singleton Pattern - Problematic)

```objc
// Tight coupling to Settings singleton
- (void)viewDidLoad {
    [super viewDidLoad];

    // Direct access to global state - hard to test
    Settings *settings = [Settings Instance];
    self.currentFrame = settings.currentFrameNumber;

    // Another singleton - tightly coupled
    if ([[SRSubscriptionModel shareKit] IsAppSubscribed]) {
        // ...
    }
}
```

**Problems:**
- Tight coupling to global state
- Hard to test (can't mock dependencies)
- Hidden dependencies (not clear what the controller needs)
- Violates Dependency Inversion Principle

## After (Dependency Injection - Clean)

```objc
// PicFrames/FrameSelectionController.h
@interface FrameSelectionController : UIViewController

// Injected dependencies - clear and testable
@property (nonatomic, strong) ServiceContainer *services;

- (instancetype)initWithServices:(ServiceContainer *)services;

@end
```

```objc
// PicFrames/FrameSelectionController.m
- (instancetype)initWithServices:(ServiceContainer *)services {
    self = [super init];
    if (self) {
        _services = services ?: [ServiceContainer shared];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    // Access services through container - testable!
    self.currentFrame = self.services.settings.currentFrameNumber;

    if ([self.services.subscriptionModel IsAppSubscribed]) {
        // ...
    }
}
```

**Benefits:**
- Dependencies are explicit and visible
- Easy to test with mock services
- Follows Dependency Inversion Principle
- Can swap implementations without changing code

## Migration Strategy

### Step 1: Add Files to Xcode Project (REQUIRED)

You must add the following files to your Xcode project:

1. `PicFrames/ServiceContainer.h`
2. `PicFrames/ServiceContainer.m`
3. `PicFrames/Services/SessionStateService.h`
4. `PicFrames/Services/SessionStateService.m`

**How to add:**
1. Open `VideoFrames.xcodeproj` in Xcode
2. Right-click on `PicFrames` group → "Add Files to VideoFrames"
3. Select `ServiceContainer.h` and `ServiceContainer.m`
4. Create a new group called "Services"
5. Add `SessionStateService.h` and `SessionStateService.m` to that group
6. Ensure "Copy items if needed" is UNchecked (files are already in place)
7. Ensure target "VideoFrames" is checked

### Step 2: Gradual Migration Pattern

**For new code:**
Always use ServiceContainer from the start.

**For existing code:**
Migrate one controller at a time:

```objc
// OLD WAY (leave as-is for now)
Settings *nvm = [Settings Instance];
int frame = nvm.currentFrameNumber;

// NEW WAY (migrate gradually)
ServiceContainer *services = [ServiceContainer shared];
int frame = services.settings.currentFrameNumber;
```

### Step 3: Testing with Dependency Injection

```objc
// In your tests
- (void)testFrameSelection {
    // Create mock services
    ServiceContainer *mockServices = [[ServiceContainer alloc] init];
    Settings *mockSettings = [[Settings alloc] init];
    mockSettings.currentFrameNumber = 5;
    [mockServices setCustomSettings:mockSettings];

    // Inject into controller
    FrameSelectionController *controller =
        [[FrameSelectionController alloc] initWithServices:mockServices];

    // Now you can test in isolation!
    XCTAssertEqual(controller.currentFrame, 5);
}
```

## Future Phases

### Phase 3: Extract More Services from Settings

Settings is currently a **God Object** managing:
- Session state ✅ (extracted to SessionStateService)
- Aspect ratio calculations (TODO: AspectRatioService)
- Upload settings (TODO: UploadSettingsService)
- Network connectivity (TODO: NetworkService)

### Phase 4: Apply Throughout Codebase

Once pattern is established:
- Update all view controllers to use ServiceContainer
- Remove direct singleton access
- Update tests to use dependency injection

## Benefits Achieved

1. **Testability**: Can inject mock services
2. **Clarity**: Dependencies are explicit
3. **Flexibility**: Easy to swap implementations
4. **SOLID Principles**:
   - ✅ Single Responsibility (SessionStateService)
   - ✅ Dependency Inversion (depend on abstractions)
   - ✅ Open/Closed (extend via new services)

## Related Files

- `PicFrames/ServiceContainer.h/m` - Main container
- `PicFrames/Services/SessionStateService.h/m` - Session state service
- `PicFrames/Settings.h/m` - Original God object (to be gradually decomposed)
- `PicFrames/FrameSelectionController.m` - Example of migration (TODO)

## Questions?

See SOLID principles documentation for more context on why this improves code quality.
