package com.sellclip.clip.entity;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.Table;
import java.time.Instant;

@Entity
@Table(name = "project_brand_kit_selections")
public class ProjectBrandKitSelection {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(nullable = false, unique = true)
    private Long ownerId;

    @Column(nullable = false)
    private Long brandKitId;

    @Column(nullable = false)
    private Instant updatedAt = Instant.now();

    protected ProjectBrandKitSelection() {
    }

    public ProjectBrandKitSelection(Long ownerId, Long brandKitId) {
        this.ownerId = ownerId;
        this.brandKitId = brandKitId;
    }

    public Long getId() {
        return id;
    }

    public Long getOwnerId() {
        return ownerId;
    }

    public Long getBrandKitId() {
        return brandKitId;
    }

    public Instant getUpdatedAt() {
        return updatedAt;
    }

    public void changeBrandKit(Long brandKitId) {
        this.brandKitId = brandKitId;
        this.updatedAt = Instant.now();
    }
}
