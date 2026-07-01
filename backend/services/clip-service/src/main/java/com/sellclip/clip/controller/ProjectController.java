package com.sellclip.clip.controller;

import com.sellclip.clip.dto.CreateProjectRequest;
import com.sellclip.clip.dto.ProjectResponse;
import com.sellclip.clip.entity.AspectRatio;
import com.sellclip.clip.entity.ProjectStatus;
import com.sellclip.clip.entity.ProjectType;
import com.sellclip.clip.service.ProjectService;
import jakarta.validation.Valid;
import java.util.List;
import java.util.Map;
import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.GetMapping;
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

    @PostMapping
    public ProjectResponse create(@Valid @RequestBody CreateProjectRequest request) {
        return projectService.create(request);
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
