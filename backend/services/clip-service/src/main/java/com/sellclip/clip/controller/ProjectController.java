package com.sellclip.clip.controller;

import com.sellclip.clip.dto.CreateProjectRequest;
import com.sellclip.clip.dto.MoveProjectFolderRequest;
import com.sellclip.clip.dto.ProjectActionRequest;
import com.sellclip.clip.dto.ProjectFolderResponse;
import com.sellclip.clip.dto.ProjectResponse;
import com.sellclip.clip.dto.RenameProjectRequest;
import com.sellclip.clip.entity.AspectRatio;
import com.sellclip.clip.entity.ProjectStatus;
import com.sellclip.clip.entity.ProjectType;
import com.sellclip.clip.service.ProjectService;
import jakarta.validation.Valid;
import java.util.List;
import java.util.Map;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PatchMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

@CrossOrigin(origins = "*")
@RestController
@RequestMapping("/api/projects")
public class ProjectController {
    private final ProjectService projectService;

    public ProjectController(ProjectService projectService) {
        this.projectService = projectService;
    }

    @GetMapping
    public List<ProjectResponse> list(@RequestParam("ownerId") Long ownerId) {
        return projectService.listByOwner(ownerId);
    }

    @GetMapping("/folders")
    public List<ProjectFolderResponse> folders(@RequestParam("ownerId") Long ownerId) {
        return projectService.listFolders(ownerId);
    }
    @PostMapping
    public ProjectResponse create(@Valid @RequestBody CreateProjectRequest request) {
        return projectService.create(request);
    }

    @GetMapping("/{projectId}")
    public ProjectResponse open(
            @PathVariable("projectId") Long projectId,
            @RequestParam("ownerId") Long ownerId
    ) {
        return projectService.open(projectId, ownerId);
    }

    @PatchMapping("/{projectId}/rename")
    public ProjectResponse rename(
            @PathVariable("projectId") Long projectId,
            @Valid @RequestBody RenameProjectRequest request
    ) {
        return projectService.rename(projectId, request);
    }

    @PostMapping("/{projectId}/duplicate")
    public ProjectResponse duplicate(
            @PathVariable("projectId") Long projectId,
            @Valid @RequestBody ProjectActionRequest request
    ) {
        return projectService.duplicate(projectId, request);
    }

    @PatchMapping("/{projectId}/folder")
    public ProjectResponse moveToFolder(
            @PathVariable("projectId") Long projectId,
            @Valid @RequestBody MoveProjectFolderRequest request
    ) {
        return projectService.moveToFolder(projectId, request);
    }

    @PatchMapping("/{projectId}/archive")
    public ProjectResponse archive(
            @PathVariable("projectId") Long projectId,
            @Valid @RequestBody ProjectActionRequest request
    ) {
        return projectService.archive(projectId, request);
    }

    @DeleteMapping("/{projectId}")
    public ResponseEntity<Void> delete(
            @PathVariable("projectId") Long projectId,
            @RequestParam("ownerId") Long ownerId
    ) {
        projectService.delete(projectId, ownerId);
        return ResponseEntity.noContent().build();
    }

    @GetMapping("/metadata")
    public Map<String, Object> metadata() {
        return Map.of(
                "types", ProjectType.values(),
                "ratios", AspectRatio.values(),
                "statuses", ProjectStatus.values()
        );
    }
}
