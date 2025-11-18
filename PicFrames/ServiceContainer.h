//
//  ServiceContainer.h
//  PicFrames
//
//  Created by Claude on 2025-11-18.
//  Dependency Injection Container for managing app services
//

#import <Foundation/Foundation.h>

@class Settings;
@class InAppPurchaseManager;
@class SRSubscriptionModel;
@class SecretsManager;
@class SessionStateService;
@class SessionRepository;
@class FrameRepository;

NS_ASSUME_NONNULL_BEGIN

/**
 * ServiceContainer provides centralized dependency management following
 * the Service Locator pattern with Dependency Injection capabilities.
 *
 * Benefits:
 * - Single point of service access
 * - Easier testing (can inject mock services)
 * - Clearer dependencies in view controllers
 * - Gradual migration from singletons
 *
 * Usage:
 *   ServiceContainer *services = [ServiceContainer shared];
 *   Settings *settings = services.settings;
 */
@interface ServiceContainer : NSObject

/// Shared instance - thread-safe singleton
+ (instancetype)shared;

// MARK: - Core Services

/// App-wide settings (migrating from singleton)
@property (nonatomic, strong, readonly) Settings *settings;

/// Session state management service
@property (nonatomic, strong, readonly, nullable) SessionStateService *sessionState;

/// Secrets management (API keys, etc.)
@property (nonatomic, strong, readonly) SecretsManager *secrets;

// MARK: - Data Access (Repositories)

/// Session data repository
@property (nonatomic, strong, readonly) SessionRepository *sessionRepository;

/// Frame template repository
@property (nonatomic, strong, readonly) FrameRepository *frameRepository;

// MARK: - Store Services (Reasonable Singletons)

/// In-app purchase manager (StoreKit wrapper)
@property (nonatomic, strong, readonly) InAppPurchaseManager *purchaseManager;

/// Subscription model manager
@property (nonatomic, strong, readonly) SRSubscriptionModel *subscriptionModel;

// MARK: - Dependency Injection

/**
 * Allows injecting custom service implementations for testing.
 * Must be called before first access to the service.
 */
- (void)setCustomSettings:(Settings *)settings;
- (void)setCustomSessionState:(SessionStateService * _Nullable)sessionState;
- (void)setCustomSessionRepository:(SessionRepository *)sessionRepository;
- (void)setCustomFrameRepository:(FrameRepository *)frameRepository;

/**
 * Reset all services (useful for testing)
 */
- (void)reset;

@end

NS_ASSUME_NONNULL_END
