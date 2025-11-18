//
//  ServiceContainer.m
//  PicFrames
//
//  Created by Claude on 2025-11-18.
//

#import "ServiceContainer.h"
#import "Settings.h"
#import "InAppPurchaseManager.h"
#import "SRSubscriptionModel.h"
#import "SecretsManager.h"
#import "SessionRepository.h"
#import "FrameRepository.h"

@interface ServiceContainer ()

// Custom injected services (for testing)
@property (nonatomic, strong, nullable) Settings *customSettings;
@property (nonatomic, strong, nullable) SessionStateService *customSessionState;
@property (nonatomic, strong, nullable) SessionRepository *customSessionRepository;
@property (nonatomic, strong, nullable) FrameRepository *customFrameRepository;

// Lazy-loaded service instances
@property (nonatomic, strong, nullable) Settings *cachedSettings;
@property (nonatomic, strong, nullable) InAppPurchaseManager *cachedPurchaseManager;
@property (nonatomic, strong, nullable) SRSubscriptionModel *cachedSubscriptionModel;
@property (nonatomic, strong, nullable) SecretsManager *cachedSecrets;
@property (nonatomic, strong, nullable) SessionRepository *cachedSessionRepository;
@property (nonatomic, strong, nullable) FrameRepository *cachedFrameRepository;

@end

@implementation ServiceContainer

#pragma mark - Singleton

+ (instancetype)shared {
    static ServiceContainer *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

#pragma mark - Core Services

- (Settings *)settings {
    // Return custom implementation if injected (for testing)
    if (self.customSettings) {
        return self.customSettings;
    }

    // Lazy load from singleton
    if (!self.cachedSettings) {
        self.cachedSettings = [Settings Instance];
    }

    return self.cachedSettings;
}

- (SessionStateService *)sessionState {
    // Return custom implementation if injected
    if (self.customSessionState) {
        return self.customSessionState;
    }

    // TODO: Create SessionStateService to extract session management from Settings
    // For now, return nil - services will continue using Settings directly
    return nil;
}

- (SecretsManager *)secrets {
    if (!self.cachedSecrets) {
        self.cachedSecrets = [SecretsManager shared];
    }
    return self.cachedSecrets;
}

#pragma mark - Data Access (Repositories)

- (SessionRepository *)sessionRepository {
    // Return custom implementation if injected
    if (self.customSessionRepository) {
        return self.customSessionRepository;
    }

    // Lazy load
    if (!self.cachedSessionRepository) {
        self.cachedSessionRepository = [[SessionRepository alloc] init];
    }
    return self.cachedSessionRepository;
}

- (FrameRepository *)frameRepository {
    // Return custom implementation if injected
    if (self.customFrameRepository) {
        return self.customFrameRepository;
    }

    // Lazy load
    if (!self.cachedFrameRepository) {
        self.cachedFrameRepository = [[FrameRepository alloc] init];
    }
    return self.cachedFrameRepository;
}

#pragma mark - Store Services

- (InAppPurchaseManager *)purchaseManager {
    if (!self.cachedPurchaseManager) {
        self.cachedPurchaseManager = [InAppPurchaseManager Instance];
    }
    return self.cachedPurchaseManager;
}

- (SRSubscriptionModel *)subscriptionModel {
    if (!self.cachedSubscriptionModel) {
        self.cachedSubscriptionModel = [SRSubscriptionModel shareKit];
    }
    return self.cachedSubscriptionModel;
}

#pragma mark - Dependency Injection

- (void)setCustomSettings:(Settings *)settings {
    self.customSettings = settings;
}

- (void)setCustomSessionState:(SessionStateService *)sessionState {
    self.customSessionState = sessionState;
}

- (void)setCustomSessionRepository:(SessionRepository *)sessionRepository {
    self.customSessionRepository = sessionRepository;
}

- (void)setCustomFrameRepository:(FrameRepository *)frameRepository {
    self.customFrameRepository = frameRepository;
}

- (void)reset {
    self.customSettings = nil;
    self.customSessionState = nil;
    self.customSessionRepository = nil;
    self.customFrameRepository = nil;
    self.cachedSettings = nil;
    self.cachedPurchaseManager = nil;
    self.cachedSubscriptionModel = nil;
    self.cachedSecrets = nil;
    self.cachedSessionRepository = nil;
    self.cachedFrameRepository = nil;
}

@end
