package com.sellclip.clip.dto;

import com.sellclip.clip.entity.ClipTemplate;
import com.sellclip.clip.entity.TemplateStatus;

public record TemplateResponse(
        Long id,
        String name,
        String category,
        String aspectRatio,
        Integer durationSeconds,
        Boolean premium,
        String thumbnailCode,
        TemplateStatus status,
        Boolean selected
) {
    public static TemplateResponse from(ClipTemplate template, Long selectedTemplateId) {
        return new TemplateResponse(
                template.getId(),
                template.getName(),
                template.getCategory(),
                template.getAspectRatio(),
                template.getDurationSeconds(),
                template.getPremium(),
                template.getThumbnailCode(),
                template.getStatus(),
                template.getId().equals(selectedTemplateId)
        );
    }
}
