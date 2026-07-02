package com.sellclip.clip.repository;

import com.sellclip.clip.entity.ClipTemplate;
import com.sellclip.clip.entity.TemplateStatus;
import java.util.List;
import org.springframework.data.jpa.repository.JpaRepository;

public interface ClipTemplateRepository extends JpaRepository<ClipTemplate, Long> {
    long countByOwnerIdAndStatus(Long ownerId, TemplateStatus status);

    List<ClipTemplate> findByOwnerIdAndStatusOrderByUpdatedAtDesc(Long ownerId, TemplateStatus status);

    List<ClipTemplate> findByOwnerIdAndStatusAndNameContainingIgnoreCaseOrderByUpdatedAtDesc(
            Long ownerId,
            TemplateStatus status,
            String query
    );

    List<ClipTemplate> findByOwnerIdAndStatusAndCategoryIgnoreCaseOrderByUpdatedAtDesc(
            Long ownerId,
            TemplateStatus status,
            String category
    );

    List<ClipTemplate> findByOwnerIdAndStatusAndCategoryIgnoreCaseAndNameContainingIgnoreCaseOrderByUpdatedAtDesc(
            Long ownerId,
            TemplateStatus status,
            String category,
            String query
    );
}
