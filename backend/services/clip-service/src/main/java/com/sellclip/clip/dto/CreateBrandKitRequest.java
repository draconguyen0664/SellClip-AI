package com.sellclip.clip.dto;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Size;
import java.util.List;

public record CreateBrandKitRequest(
        @NotNull Long ownerId,
        @NotBlank @Size(max = 120) String name,
        @Size(max = 40) String logoCode,
        @Size(min = 1, max = 8) List<String> palette,
        @Size(max = 80) String headingFont,
        @Size(max = 80) String bodyFont,
        Integer productAssetCount,
        Integer iconAssetCount
) {
}
