package com.sellclip.auth.dto;

import com.sellclip.auth.entity.UserAccount;

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
    public static AuthResponse basic(String status, String message) {
        return new AuthResponse(status, message, null, null, null, null, false, null, null);
    }

    public static AuthResponse forUser(String status, String message, UserAccount user, String token) {
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

    public AuthResponse withDevCode(String code) {
        return new AuthResponse(status, message, userId, email, displayName, accessToken, onboardingCompleted, code, devResetToken);
    }

    public AuthResponse withDevResetToken(String token) {
        return new AuthResponse(status, message, userId, email, displayName, accessToken, onboardingCompleted, devCode, token);
    }
}
