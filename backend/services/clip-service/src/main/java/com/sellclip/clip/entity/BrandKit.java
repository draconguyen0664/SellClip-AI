package com.sellclip.clip.entity;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.EnumType;
import jakarta.persistence.Enumerated;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.Table;
import java.time.Instant;

@Entity
@Table(name = "brand_kits")
public class BrandKit {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(nullable = false)
    private Long ownerId;

    @Column(nullable = false, length = 120)
    private String name;

    @Column(nullable = false, length = 40)
    private String logoCode;

    @Column(nullable = false, length = 180)
    private String palette;

    @Column(nullable = false)
    private Integer fontCount;

    @Column(nullable = false)
    private Integer assetCount;

    @Column(nullable = false, length = 80)
    private String headingFont = "Inter";

    @Column(nullable = false, length = 80)
    private String bodyFont = "Inter";

    @Enumerated(EnumType.STRING)
    @Column(nullable = false, length = 30)
    private BrandKitStatus status = BrandKitStatus.ACTIVE;

    @Column(nullable = false)
    private Instant updatedAt = Instant.now();

    @Column(nullable = false)
    private Instant createdAt = Instant.now();

    protected BrandKit() {
    }

    public BrandKit(
            Long ownerId,
            String name,
            String logoCode,
            String palette,
            Integer fontCount,
            Integer assetCount,
            Instant updatedAt
    ) {
        this.ownerId = ownerId;
        this.name = name;
        this.logoCode = logoCode;
        this.palette = palette;
        this.fontCount = fontCount;
        this.assetCount = assetCount;
        this.updatedAt = updatedAt;
    }

    public void applyTypography(String headingFont, String bodyFont) {
        if (headingFont != null && !headingFont.isBlank()) {
            this.headingFont = headingFont.trim();
        }
        if (bodyFont != null && !bodyFont.isBlank()) {
            this.bodyFont = bodyFont.trim();
        }
    }

    public Long getId() {
        return id;
    }

    public Long getOwnerId() {
        return ownerId;
    }

    public String getName() {
        return name;
    }

    public String getLogoCode() {
        return logoCode;
    }

    public String getPalette() {
        return palette;
    }

    public Integer getFontCount() {
        return fontCount;
    }

    public Integer getAssetCount() {
        return assetCount;
    }

    public String getHeadingFont() {
        return headingFont;
    }

    public String getBodyFont() {
        return bodyFont;
    }

    public BrandKitStatus getStatus() {
        return status;
    }

    public Instant getUpdatedAt() {
        return updatedAt;
    }

    public Instant getCreatedAt() {
        return createdAt;
    }
}
