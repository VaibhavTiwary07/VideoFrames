//
//  SecretsManager.m
//  VideoFrames
//
//  Created by Refactoring - Phase 1
//  Secure secrets management - replaces hardcoded Config.h values
//

#import "SecretsManager.h"

// Secret keys in plist
static NSString * const kFlurryKey = @"FlurryKey";
static NSString * const kTapjoyAppId = @"TapjoyAppId";
static NSString * const kTapjoySecretKey = @"TapjoySecretKey";
static NSString * const kFacebookAppId = @"FacebookAppId";
static NSString * const kFacebookClientToken = @"FacebookClientToken";
static NSString * const kSubscriptionSharedSecret = @"SubscriptionSharedSecret";
static NSString * const kAdMobBannerUnitId = @"AdMobBannerUnitId";
static NSString * const kAdMobInterstitialUnitId = @"AdMobInterstitialUnitId";

@interface SecretsManager ()
@property (nonatomic, strong) NSDictionary<NSString *, NSString *> *secrets;
@end

@implementation SecretsManager

#pragma mark - Singleton

+ (instancetype)shared {
    static SecretsManager *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

#pragma mark - Initialization

- (instancetype)init {
    self = [super init];
    if (self) {
        [self loadSecrets];
    }
    return self;
}

- (void)loadSecrets {
    NSMutableDictionary *loadedSecrets = [NSMutableDictionary dictionary];

    // Try to load from Secrets.plist in bundle
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"Secrets" ofType:@"plist"];
    if (plistPath) {
        NSDictionary *plistSecrets = [NSDictionary dictionaryWithContentsOfFile:plistPath];
        if (plistSecrets) {
            [loadedSecrets addEntriesFromDictionary:plistSecrets];
            NSLog(@"[SecretsManager] Loaded %lu secrets from Secrets.plist", (unsigned long)plistSecrets.count);
        }
    } else {
        NSLog(@"[SecretsManager] ⚠️ Secrets.plist not found. Using fallback values.");
    }

    // Override with environment variables if available (for CI/CD)
    [self loadEnvironmentVariableIfExists:kFlurryKey into:loadedSecrets];
    [self loadEnvironmentVariableIfExists:kTapjoyAppId into:loadedSecrets];
    [self loadEnvironmentVariableIfExists:kTapjoySecretKey into:loadedSecrets];
    [self loadEnvironmentVariableIfExists:kFacebookAppId into:loadedSecrets];
    [self loadEnvironmentVariableIfExists:kFacebookClientToken into:loadedSecrets];
    [self loadEnvironmentVariableIfExists:kSubscriptionSharedSecret into:loadedSecrets];
    [self loadEnvironmentVariableIfExists:kAdMobBannerUnitId into:loadedSecrets];
    [self loadEnvironmentVariableIfExists:kAdMobInterstitialUnitId into:loadedSecrets];

    self.secrets = [loadedSecrets copy];

    // Warn about missing secrets
    if (![self areSecretsConfigured]) {
        NSArray *missing = [self missingSecrets];
        NSLog(@"[SecretsManager] ⚠️ Missing secrets: %@", [missing componentsJoinedByString:@", "]);
    }
}

- (void)loadEnvironmentVariableIfExists:(NSString *)key into:(NSMutableDictionary *)dict {
    NSString *envValue = [NSProcessInfo processInfo].environment[key];
    if (envValue && envValue.length > 0) {
        dict[key] = envValue;
        NSLog(@"[SecretsManager] Loaded %@ from environment variable", key);
    }
}

#pragma mark - Public Properties

- (NSString *)flurryKey {
    return self.secrets[kFlurryKey];
}

- (NSString *)tapjoyAppId {
    return self.secrets[kTapjoyAppId];
}

- (NSString *)tapjoySecretKey {
    return self.secrets[kTapjoySecretKey];
}

- (NSString *)facebookAppId {
    return self.secrets[kFacebookAppId];
}

- (NSString *)facebookClientToken {
    return self.secrets[kFacebookClientToken];
}

- (NSString *)subscriptionSharedSecret {
    return self.secrets[kSubscriptionSharedSecret];
}

- (NSString *)adMobBannerUnitId {
    return self.secrets[kAdMobBannerUnitId];
}

- (NSString *)adMobInterstitialUnitId {
    return self.secrets[kAdMobInterstitialUnitId];
}

#pragma mark - Validation

- (BOOL)areSecretsConfigured {
    return [self missingSecrets].count == 0;
}

- (NSArray<NSString *> *)missingSecrets {
    NSMutableArray *missing = [NSMutableArray array];

    // Check critical secrets
    NSArray *criticalKeys = @[
        kFlurryKey,
        kTapjoyAppId,
        kFacebookAppId,
        kSubscriptionSharedSecret
    ];

    for (NSString *key in criticalKeys) {
        NSString *value = self.secrets[key];
        if (!value || value.length == 0) {
            [missing addObject:key];
        }
    }

    return [missing copy];
}

@end
