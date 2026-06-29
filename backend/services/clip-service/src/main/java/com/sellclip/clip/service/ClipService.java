package com.sellclip.clip.service;

import com.sellclip.clip.dto.CreateClipRequest;
import com.sellclip.clip.entity.ClipAsset;
import java.util.List;

public interface ClipService {
    List<ClipAsset> listByOwner(Long ownerId);

    ClipAsset create(CreateClipRequest request);
}
