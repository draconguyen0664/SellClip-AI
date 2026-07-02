package com.sellclip.clip.service;

import com.sellclip.clip.dto.TemplateResponse;
import com.sellclip.clip.dto.TemplateSelectionRequest;
import com.sellclip.clip.dto.TemplateSelectionResponse;
import java.util.List;

public interface TemplateService {
    List<TemplateResponse> list(Long ownerId, String query, String category);

    TemplateSelectionResponse select(TemplateSelectionRequest request);
}
