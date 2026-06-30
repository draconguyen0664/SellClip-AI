package com.sellclip.clip.service;

import com.sellclip.clip.dto.CreateProjectRequest;
import com.sellclip.clip.dto.ProjectResponse;
import java.util.List;

public interface ProjectService {
    List<ProjectResponse> listByOwner(Long ownerId);

    ProjectResponse create(CreateProjectRequest request);
}
