package com.sellclip.clip.entity;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.Table;
import java.time.Instant;

@Entity
@Table(name = "project_template_selections")
public class ProjectTemplateSelection {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(nullable = false, unique = true)
    private Long ownerId;

    private Long templateId;

    @Column(nullable = false)
    private Boolean noTemplate = false;

    @Column(nullable = false)
    private Instant updatedAt = Instant.now();

    protected ProjectTemplateSelection() {
    }

    public ProjectTemplateSelection(Long ownerId, Long templateId, Boolean noTemplate) {
        this.ownerId = ownerId;
        this.templateId = templateId;
        this.noTemplate = noTemplate;
    }

    public Long getOwnerId() {
        return ownerId;
    }

    public Long getTemplateId() {
        return templateId;
    }

    public Boolean getNoTemplate() {
        return noTemplate;
    }

    public Instant getUpdatedAt() {
        return updatedAt;
    }

    public void chooseTemplate(Long templateId) {
        this.templateId = templateId;
        this.noTemplate = false;
        this.updatedAt = Instant.now();
    }

    public void chooseBlank() {
        this.templateId = null;
        this.noTemplate = true;
        this.updatedAt = Instant.now();
    }
}
