package com.sellclip.clip.dto;

public record BrandKitSelectionResponse(
        Boolean ok,
        String status,
        String message,
        BrandKitResponse brandKit
) {
    public static BrandKitSelectionResponse saved(BrandKitResponse brandKit) {
        return new BrandKitSelectionResponse(
                true,
                "saved",
                "Brand Kit saved",
                brandKit
        );
    }
}
