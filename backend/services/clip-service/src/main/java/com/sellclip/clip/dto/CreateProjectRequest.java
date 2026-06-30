package com.sellclip.clip.dto;

import com.sellclip.clip.entity.AspectRatio;
import com.sellclip.clip.entity.ProjectType;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;

public record CreateProjectRequest(
        @NotNull Long ownerId,
        @NotBlank String name,
        @NotNull ProjectType type,
        @NotNull AspectRatio aspectRatio,
        @NotBlank String brandKit,
        @NotBlank String templateName
) {
}
