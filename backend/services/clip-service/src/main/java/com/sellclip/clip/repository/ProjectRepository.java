package com.sellclip.clip.repository;

import com.sellclip.clip.entity.Project;
import com.sellclip.clip.entity.ProjectStatus;
import java.util.Collection;
import java.util.List;
import org.springframework.data.jpa.repository.JpaRepository;

public interface ProjectRepository extends JpaRepository<Project, Long> {
    List<Project> findByOwnerIdAndStatusNotInOrderByCreatedAtDesc(
            Long ownerId,
            Collection<ProjectStatus> statuses
    );
}
