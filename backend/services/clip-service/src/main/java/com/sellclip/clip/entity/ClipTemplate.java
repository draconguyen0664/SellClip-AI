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
@Table(name = "clip_templates")
public class ClipTemplate {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(nullable = false)
    private Long ownerId;

    @Column(nullable = false, length = 140)
    private String name;

    @Column(nullable = false, length = 80)
    private String category;

    @Column(nullable = false, length = 20)
    private String aspectRatio;

    @Column(nullable = false)
    private Integer durationSeconds;

    @Column(nullable = false)
    private Boolean premium;

    @Column(nullable = false, length = 40)
    private String thumbnailCode;

    @Enumerated(EnumType.STRING)
    @Column(nullable = false, length = 30)
    private TemplateStatus status = TemplateStatus.ACTIVE;

    @Column(nullable = false)
    private Instant updatedAt = Instant.now();

    @Column(nullable = false)
    private Instant createdAt = Instant.now();

    protected ClipTemplate() {
    }

    public ClipTemplate(
            Long ownerId,
            String name,
            String category,
            String aspectRatio,
            Integer durationSeconds,
            Boolean premium,
            String thumbnailCode,
            Instant updatedAt
    ) {
        this.ownerId = ownerId;
        this.name = name;
        this.category = category;
        this.aspectRatio = aspectRatio;
        this.durationSeconds = durationSeconds;
        this.premium = premium;
        this.thumbnailCode = thumbnailCode;
        this.updatedAt = updatedAt;
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

    public String getCategory() {
        return category;
    }

    public String getAspectRatio() {
        return aspectRatio;
    }

    public Integer getDurationSeconds() {
        return durationSeconds;
    }

    public Boolean getPremium() {
        return premium;
    }

    public String getThumbnailCode() {
        return thumbnailCode;
    }

    public TemplateStatus getStatus() {
        return status;
    }

    public Instant getUpdatedAt() {
        return updatedAt;
    }

    public Instant getCreatedAt() {
        return createdAt;
    }
}
