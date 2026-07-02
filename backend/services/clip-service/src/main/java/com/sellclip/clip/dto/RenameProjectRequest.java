package com.sellclip.clip.dto;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;

public record RenameProjectRequest(
        @NotNull Long ownerId,
        @NotBlank String name
) {
}