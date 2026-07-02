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
@Table(name = "projects")
public class Project {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(nullable = false)
    private Long ownerId;

    @Column(nullable = false, length = 180)
    private String name;

    @Enumerated(EnumType.STRING)
    @Column(nullable = false, length = 40)
    private ProjectType type;

    @Enumerated(EnumType.STRING)
    @Column(nullable = false, length = 40)
    private AspectRatio aspectRatio;

    @Column(nullable = false, length = 120)
    private String brandKit;

    @Column(nullable = false, length = 120)
    private String templateName;

    @Column(length = 120)
    private String folderName;

    @Enumerated(EnumType.STRING)
    @Column(nullable = false, length = 40)
    private ProjectStatus status = ProjectStatus.DRAFT;

    @Column(nullable = false)
    private Instant createdAt = Instant.now();

    @Column(nullable = false)
    private Instant updatedAt = Instant.now();

    protected Project() {
    }

    public Project(
            Long ownerId,
            String name,
            ProjectType type,
            AspectRatio aspectRatio,
            String brandKit,
            String templateName
    ) {
        this.ownerId = ownerId;
        this.name = name;
        this.type = type;
        this.aspectRatio = aspectRatio;
        this.brandKit = brandKit;
        this.templateName = templateName;
    }

    public Project duplicate(String duplicatedName) {
        Project copy = new Project(ownerId, duplicatedName, type, aspectRatio, brandKit, templateName);
        copy.folderName = folderName;
        return copy;
    }

    public void rename(String newName) {
        name = newName;
        touch();
    }

    public void moveToFolder(String folder) {
        folderName = folder == null || folder.isBlank() ? null : folder.trim();
        touch();
    }

    public void archive() {
        status = ProjectStatus.ARCHIVED;
        touch();
    }

    public void delete() {
        status = ProjectStatus.DELETED;
        touch();
    }

    private void touch() {
        updatedAt = Instant.now();
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

    public ProjectType getType() {
        return type;
    }

    public AspectRatio getAspectRatio() {
        return aspectRatio;
    }

    public String getBrandKit() {
        return brandKit;
    }

    public String getTemplateName() {
        return templateName;
    }

    public String getFolderName() {
        return folderName;
    }

    public ProjectStatus getStatus() {
        return status;
    }

    public Instant getCreatedAt() {
        return createdAt;
    }

    public Instant getUpdatedAt() {
        return updatedAt;
    }
}