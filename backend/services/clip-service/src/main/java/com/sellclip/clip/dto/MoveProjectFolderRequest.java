package com.sellclip.clip.dto;

import jakarta.validation.constraints.NotNull;

public record MoveProjectFolderRequest(
        @NotNull Long ownerId,
        String folderName
) {
}