package com.sellclip.clip.serviceimpl;

import com.sellclip.clip.dto.CreateProjectRequest;
import com.sellclip.clip.dto.ProjectResponse;
import com.sellclip.clip.entity.Project;
import com.sellclip.clip.entity.ProjectStatus;
import com.sellclip.clip.repository.ProjectRepository;
import com.sellclip.clip.service.ProjectService;
import java.util.List;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
public class ProjectServiceImpl implements ProjectService {
    private final ProjectRepository projects;

    public ProjectServiceImpl(ProjectRepository projects) {
        this.projects = projects;
    }

    @Override
    @Transactional(readOnly = true)
    public List<ProjectResponse> listByOwner(Long ownerId) {
        return projects
                .findByOwnerIdAndStatusNotInOrderByCreatedAtDesc(
                        ownerId,
                        List.of(ProjectStatus.DELETED)
                )
                .stream()
                .map(ProjectResponse::from)
                .toList();
    }

    @Override
    @Transactional
    public ProjectResponse create(CreateProjectRequest request) {
        var project = new Project(
                request.ownerId(),
                request.name().trim(),
                request.type(),
                request.aspectRatio(),
                request.brandKit().trim(),
                request.templateName().trim()
        );
        return ProjectResponse.from(projects.save(project));
    }
}
