package com.sellclip.clip.dto;

import jakarta.validation.constraints.NotNull;

public record TemplateSelectionRequest(
        @NotNull Long ownerId,
        Long templateId,
        Boolean noTemplate
) {
}
