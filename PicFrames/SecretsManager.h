//
//  SecretsManager.h
//  VideoFrames
//
//  Created by Refactoring - Phase 1
//  Secure secrets management - replaces hardcoded Config.h values
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/**
 * SecretsManager provides secure access to API keys and secrets.
 * Secrets are loaded from Secrets.plist (which should be in .gitignore)
 * or from environment variables for CI/CD environments.
 */
@interface SecretsManager : NSObject

/// Shared instance (Thread-safe singleton)
+ (instancetype)shared;

// MARK: - API Keys

/// Flurry Analytics API Key
@property (nonatomic, readonly, nullable) NSString *flurryKey;

/// Tapjoy App ID
@property (nonatomic, readonly, nullable) NSString *tapjoyAppId;

/// Tapjoy Secret Key
@property (nonatomic, readonly, nullable) NSString *tapjoySecretKey;

/// Facebook App ID
@property (nonatomic, readonly, nullable) NSString *facebookAppId;

/// Facebook Client Token
@property (nonatomic, readonly, nullable) NSString *facebookClientToken;

/// Subscription Shared Secret (for receipt validation)
@property (nonatomic, readonly, nullable) NSString *subscriptionSharedSecret;

// MARK: - AdMob IDs

/// AdMob Banner Ad Unit ID
@property (nonatomic, readonly, nullable) NSString *adMobBannerUnitId;

/// AdMob Interstitial Ad Unit ID
@property (nonatomic, readonly, nullable) NSString *adMobInterstitialUnitId;

// MARK: - Helper Methods

/**
 * Checks if all required secrets are configured
 * @return YES if all critical secrets are available, NO otherwise
 */
- (BOOL)areSecretsConfigured;

/**
 * Returns a list of missing secret keys
 * @return Array of missing key names, or empty array if all configured
 */
- (NSArray<NSString *> *)missingSecrets;

@end

NS_ASSUME_NONNULL_END
