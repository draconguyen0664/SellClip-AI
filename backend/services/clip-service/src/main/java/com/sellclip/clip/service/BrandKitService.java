package com.sellclip.clip.service;

import com.sellclip.clip.dto.BrandKitResponse;
import com.sellclip.clip.dto.BrandKitSelectionRequest;
import com.sellclip.clip.dto.BrandKitSelectionResponse;
import com.sellclip.clip.dto.BrandKitCreateResponse;
import com.sellclip.clip.dto.CreateBrandKitRequest;
import java.util.List;

public interface BrandKitService {
    List<BrandKitResponse> list(Long ownerId, String query);

    BrandKitCreateResponse create(CreateBrandKitRequest request);

    BrandKitSelectionResponse select(BrandKitSelectionRequest request);
}
