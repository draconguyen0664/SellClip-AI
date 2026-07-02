package com.sellclip.clip.repository;

import com.sellclip.clip.dto.ProjectFolderResponse;
import com.sellclip.clip.entity.Project;
import com.sellclip.clip.entity.ProjectStatus;
import java.util.Collection;
import java.util.List;
import java.util.Optional;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

public interface ProjectRepository extends JpaRepository<Project, Long> {
    List<Project> findByOwnerIdAndStatusNotInOrderByCreatedAtDesc(
            Long ownerId,
            Collection<ProjectStatus> statuses
    );

    Optional<Project> findByIdAndOwnerIdAndStatusNot(Long id, Long ownerId, ProjectStatus status);

    @Query("""
            select new com.sellclip.clip.dto.ProjectFolderResponse(p.folderName, count(p))
            from Project p
            where p.ownerId = :ownerId
              and p.status <> com.sellclip.clip.entity.ProjectStatus.DELETED
              and p.folderName is not null
              and p.folderName <> ''
            group by p.folderName
            order by max(p.updatedAt) desc
            """)
    List<ProjectFolderResponse> findFoldersByOwnerId(@Param("ownerId") Long ownerId);
}
