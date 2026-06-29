package com.sellclip.ai.dto;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;

public record CreateAiJobRequest(@NotNull Long clipId, @NotBlank String jobType) {
}
