package com.sellclip.clip.dto;

import com.sellclip.clip.entity.BrandKit;
import com.sellclip.clip.entity.BrandKitStatus;
import java.time.LocalDate;
import java.time.ZoneId;
import java.time.format.DateTimeFormatter;
import java.util.Arrays;
import java.util.List;

public record BrandKitResponse(
        Long id,
        String name,
        String logoCode,
        List<String> palette,
        Integer fontCount,
        Integer assetCount,
        BrandKitStatus status,
        String updatedDate,
        Boolean selected
) {
    private static final DateTimeFormatter DATE_FORMAT =
            DateTimeFormatter.ofPattern("dd/MM/yyyy");

    public static BrandKitResponse from(BrandKit brandKit, Long selectedBrandKitId) {
        LocalDate updatedDate = brandKit
                .getUpdatedAt()
                .atZone(ZoneId.systemDefault())
                .toLocalDate();

        return new BrandKitResponse(
                brandKit.getId(),
                brandKit.getName(),
                brandKit.getLogoCode(),
                Arrays.stream(brandKit.getPalette().split(",")).map(String::trim).toList(),
                brandKit.getFontCount(),
                brandKit.getAssetCount(),
                brandKit.getStatus(),
                updatedDate.format(DATE_FORMAT),
                brandKit.getId().equals(selectedBrandKitId)
        );
    }
}
