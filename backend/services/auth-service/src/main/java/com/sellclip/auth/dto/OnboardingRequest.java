package com.sellclip.auth.dto;

import java.util.List;

public record OnboardingRequest(
        Long userId,
        boolean skipped,
        String industry,
        List<String> platforms,
        List<String> contentGoals,
        String mediaType,
        List<String> contentStyles,
        String voiceType) {
}
