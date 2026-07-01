package com.sellclip.clip.dto;

public record BrandKitCreateResponse(
        Boolean ok,
        String status,
        String message,
        BrandKitResponse brandKit
) {
    public static BrandKitCreateResponse created(BrandKitResponse brandKit) {
        return new BrandKitCreateResponse(
                true,
                "created",
                "Brand Kit created",
                brandKit
        );
    }
}
