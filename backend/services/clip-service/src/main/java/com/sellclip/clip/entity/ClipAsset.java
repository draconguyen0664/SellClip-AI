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
@Table(name = "clip_assets")
public class ClipAsset {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(nullable = false)
    private Long ownerId;

    @Column(nullable = false, length = 180)
    private String title;

    @Column(nullable = false, length = 600)
    private String sourceUrl;

    @Enumerated(EnumType.STRING)
    @Column(nullable = false, length = 40)
    private ClipStatus status = ClipStatus.UPLOADED;

    @Column(nullable = false)
    private Instant createdAt = Instant.now();

    protected ClipAsset() {
    }

    public ClipAsset(Long ownerId, String title, String sourceUrl) {
        this.ownerId = ownerId;
        this.title = title;
        this.sourceUrl = sourceUrl;
    }

    public Long getId() {
        return id;
    }

    public Long getOwnerId() {
        return ownerId;
    }

    public String getTitle() {
        return title;
    }

    public String getSourceUrl() {
        return sourceUrl;
    }

    public ClipStatus getStatus() {
        return status;
    }

    public Instant getCreatedAt() {
        return createdAt;
    }
}
