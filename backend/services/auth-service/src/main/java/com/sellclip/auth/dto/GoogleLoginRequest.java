package com.sellclip.auth.dto;

import jakarta.validation.constraints.Email;
import jakarta.validation.constraints.NotBlank;

public record GoogleLoginRequest(
        @Email @NotBlank String email,
        @NotBlank String displayName,
        String googleId,
        String idToken,
        String accessToken) {
}
