package com.sellclip.ai.domain;

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
@Table(name = "ai_jobs")
public class AiJob {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(nullable = false)
    private Long clipId;

    @Column(nullable = false, length = 80)
    private String jobType;

    @Enumerated(EnumType.STRING)
    @Column(nullable = false, length = 40)
    private AiJobStatus status = AiJobStatus.QUEUED;

    @Column(nullable = false)
    private Instant createdAt = Instant.now();

    protected AiJob() {
    }

    public AiJob(Long clipId, String jobType) {
        this.clipId = clipId;
        this.jobType = jobType;
    }

    public Long getId() {
        return id;
    }

    public Long getClipId() {
        return clipId;
    }

    public String getJobType() {
        return jobType;
    }

    public AiJobStatus getStatus() {
        return status;
    }

    public Instant getCreatedAt() {
        return createdAt;
    }
}

