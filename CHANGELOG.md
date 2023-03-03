# Changelog

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
