package com.sellclip.ai.serviceimpl;

import com.sellclip.ai.dto.CreateAiJobRequest;
import com.sellclip.ai.entity.AiJob;
import com.sellclip.ai.repository.AiJobRepository;
import com.sellclip.ai.service.AiJobService;
import java.util.List;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
public class AiJobServiceImpl implements AiJobService {
    private final AiJobRepository jobs;

    public AiJobServiceImpl(AiJobRepository jobs) {
        this.jobs = jobs;
    }

    @Override
    @Transactional(readOnly = true)
    public List<AiJob> listByClip(Long clipId) {
        return jobs.findByClipIdOrderByCreatedAtDesc(clipId);
    }

    @Override
    @Transactional
    public AiJob createJob(CreateAiJobRequest request) {
        return jobs.save(new AiJob(request.clipId(), request.jobType()));
    }
}
