# Changelog

## 1.1.1 (2024-01-21)

### Fix

- Revert erroneous dependency bumps.

## 1.1.0 (2024-01-21)

### Feat

- Implement available genre seeds endpoint
- **#32**: Implement track recommendation endpoint

### Fix

- Introduce SimplifiedTrack for Track.linkedFrom

### Perf

- Optimize literal list JSON deserialization

## 1.0.0 (2024-01-13)

### BREAKING CHANGES

- **artist**: Change type of popularity to double?
- **deps**: Updated dependency logger to `^2.0.0`

## 0.5.1-alpha

- Added artist lookup and artist's top tracks lookup
- Generic `SpotifyApiException` may contain statusCode now
- Require Dart 3
- Require `http ^1.0.0`

## 0.4.0-alpha

- Improve error handling
  - RateLimitingException now contains the duration after which a retry should be done
  - Not attempt is made to decode rate limiting error responses (they're not JSON)

### Breaking Changes

- Remove `clientId` field from abstract `AccessTokenRefresher`

## 0.3.1-alpha

- Add `rawAccessToken` getter
- Export RequestsClient in `extension.dart` module

## 0.3.0-alpha

### Breaking Changes

- Remove `FileRefreshTokenStorage`

## 0.2.1-alpha

- Now compatible with the Web platform
- Previously deprecated `AuthorizationCodeResponse` removed
- Fixed signature of `UserAuthorizationFlow` to not require a RequestsClient instance

## 0.2.0-alpha

### Breaking Changes

- (#15) Split up `AuthenticationFlow` into `AccessTokenRefresher` and `UserAuthorizationFlow`

## 0.1.0-alpha.3

Further package quality improvements.

## 0.1.0-alpha.2

Several package quality improvements.

## 0.1.0-alpha.1

Initial alpha release.
