package com.sellclip.clip.serviceimpl;

import com.sellclip.clip.dto.CreateProjectRequest;
import com.sellclip.clip.dto.MoveProjectFolderRequest;
import com.sellclip.clip.dto.ProjectActionRequest;
import com.sellclip.clip.dto.ProjectFolderResponse;
import com.sellclip.clip.dto.ProjectResponse;
import com.sellclip.clip.dto.RenameProjectRequest;
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
    @Transactional(readOnly = true)
    public List<ProjectFolderResponse> listFolders(Long ownerId) {
        return projects.findFoldersByOwnerId(ownerId);
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

    @Override
    @Transactional(readOnly = true)
    public ProjectResponse open(Long projectId, Long ownerId) {
        return ProjectResponse.from(findProject(projectId, ownerId));
    }

    @Override
    @Transactional
    public ProjectResponse rename(Long projectId, RenameProjectRequest request) {
        Project project = findProject(projectId, request.ownerId());
        project.rename(request.name().trim());
        return ProjectResponse.from(project);
    }

    @Override
    @Transactional
    public ProjectResponse duplicate(Long projectId, ProjectActionRequest request) {
        Project project = findProject(projectId, request.ownerId());
        Project duplicated = project.duplicate(nextDuplicateName(project.getName()));
        return ProjectResponse.from(projects.save(duplicated));
    }

    @Override
    @Transactional
    public ProjectResponse moveToFolder(Long projectId, MoveProjectFolderRequest request) {
        Project project = findProject(projectId, request.ownerId());
        project.moveToFolder(request.folderName());
        return ProjectResponse.from(project);
    }

    @Override
    @Transactional
    public ProjectResponse archive(Long projectId, ProjectActionRequest request) {
        Project project = findProject(projectId, request.ownerId());
        project.archive();
        return ProjectResponse.from(project);
    }

    @Override
    @Transactional
    public void delete(Long projectId, Long ownerId) {
        Project project = findProject(projectId, ownerId);
        project.delete();
    }

    private Project findProject(Long projectId, Long ownerId) {
        return projects
                .findByIdAndOwnerIdAndStatusNot(projectId, ownerId, ProjectStatus.DELETED)
                .orElseThrow(() -> new IllegalArgumentException("Project not found"));
    }

    private String nextDuplicateName(String name) {
        String suffix = " copy";
        int maxLength = 180;
        if (name.length() + suffix.length() <= maxLength) {
            return name + suffix;
        }
        return name.substring(0, maxLength - suffix.length()) + suffix;
    }
}