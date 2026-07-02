package com.sellclip.clip.dto;

import com.sellclip.clip.entity.AspectRatio;
import com.sellclip.clip.entity.Project;
import com.sellclip.clip.entity.ProjectStatus;
import com.sellclip.clip.entity.ProjectType;
import java.time.Instant;

public record ProjectResponse(
        Long id,
        Long ownerId,
        String name,
        ProjectType type,
        AspectRatio aspectRatio,
        String aspectRatioLabel,
        String brandKit,
        String templateName,
        String folderName,
        ProjectStatus status,
        Instant createdAt,
        Instant updatedAt
) {
    public static ProjectResponse from(Project project) {
        return new ProjectResponse(
                project.getId(),
                project.getOwnerId(),
                project.getName(),
                project.getType(),
                project.getAspectRatio(),
                project.getAspectRatio().getLabel(),
                project.getBrandKit(),
                project.getTemplateName(),
                project.getFolderName(),
                project.getStatus(),
                project.getCreatedAt(),
                project.getUpdatedAt()
        );
    }
}