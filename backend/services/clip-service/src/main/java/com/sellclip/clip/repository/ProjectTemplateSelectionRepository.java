package com.sellclip.clip.repository;

import com.sellclip.clip.entity.ProjectTemplateSelection;
import java.util.Optional;
import org.springframework.data.jpa.repository.JpaRepository;

public interface ProjectTemplateSelectionRepository extends JpaRepository<ProjectTemplateSelection, Long> {
    Optional<ProjectTemplateSelection> findByOwnerId(Long ownerId);
}
