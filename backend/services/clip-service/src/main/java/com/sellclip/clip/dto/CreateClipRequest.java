package com.sellclip.clip.dto;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import org.hibernate.validator.constraints.URL;

public record CreateClipRequest(@NotNull Long ownerId, @NotBlank String title, @URL @NotBlank String sourceUrl) {
}
