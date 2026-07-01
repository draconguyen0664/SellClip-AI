package com.sellclip.clip.repository;

import com.sellclip.clip.entity.ProjectBrandKitSelection;
import java.util.Optional;
import org.springframework.data.jpa.repository.JpaRepository;

public interface ProjectBrandKitSelectionRepository
        extends JpaRepository<ProjectBrandKitSelection, Long> {
    Optional<ProjectBrandKitSelection> findByOwnerId(Long ownerId);
}
