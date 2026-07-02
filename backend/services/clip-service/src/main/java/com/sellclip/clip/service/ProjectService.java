package com.sellclip.clip.service;

import com.sellclip.clip.dto.CreateProjectRequest;
import com.sellclip.clip.dto.MoveProjectFolderRequest;
import com.sellclip.clip.dto.ProjectActionRequest;
import com.sellclip.clip.dto.ProjectFolderResponse;
import com.sellclip.clip.dto.ProjectResponse;
import com.sellclip.clip.dto.RenameProjectRequest;
import java.util.List;

public interface ProjectService {
    List<ProjectResponse> listByOwner(Long ownerId);

    List<ProjectFolderResponse> listFolders(Long ownerId);

    ProjectResponse create(CreateProjectRequest request);

    ProjectResponse open(Long projectId, Long ownerId);

    ProjectResponse rename(Long projectId, RenameProjectRequest request);

    ProjectResponse duplicate(Long projectId, ProjectActionRequest request);

    ProjectResponse moveToFolder(Long projectId, MoveProjectFolderRequest request);

    ProjectResponse archive(Long projectId, ProjectActionRequest request);

    void delete(Long projectId, Long ownerId);
}
