package com.sellclip.clip.dto;

import jakarta.validation.constraints.NotNull;

public record ProjectActionRequest(
        @NotNull Long ownerId
) {
}