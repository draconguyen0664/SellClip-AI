package com.sellclip.clip.dto;

import jakarta.validation.constraints.NotNull;

public record BrandKitSelectionRequest(
        @NotNull Long ownerId,
        @NotNull Long brandKitId
) {
}
