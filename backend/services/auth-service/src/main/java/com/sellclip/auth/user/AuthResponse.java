package com.sellclip.auth.user;

public record AuthResponse(
        String status,
        String message,
        Long userId,
        String email,
        String displayName,
        String accessToken,
        boolean onboardingCompleted,
        String devCode,
        String devResetToken) {
    static AuthResponse basic(String status, String message) {
        return new AuthResponse(status, message, null, null, null, null, false, null, null);
    }

    static AuthResponse forUser(String status, String message, UserAccount user, String token) {
        return new AuthResponse(
                status,
                message,
                user.getId(),
                user.getEmail(),
                user.getDisplayName(),
                token,
                user.isOnboardingCompleted(),
                null,
                null);
    }

    AuthResponse withDevCode(String code) {
        return new AuthResponse(status, message, userId, email, displayName, accessToken, onboardingCompleted, code, devResetToken);
    }

    AuthResponse withDevResetToken(String token) {
        return new AuthResponse(status, message, userId, email, displayName, accessToken, onboardingCompleted, devCode, token);
    }
}
