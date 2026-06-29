package com.sellclip.ai.service;

import com.sellclip.ai.dto.CreateAiJobRequest;
import com.sellclip.ai.entity.AiJob;
import java.util.List;

public interface AiJobService {
    List<AiJob> listByClip(Long clipId);

    AiJob createJob(CreateAiJobRequest request);
}
