package com.sellclip.ai.controller;

import com.sellclip.ai.dto.CreateAiJobRequest;
import com.sellclip.ai.dto.ServiceHealth;
import com.sellclip.ai.entity.AiJob;
import com.sellclip.ai.service.AiJobService;
import jakarta.validation.Valid;
import java.util.List;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/api/ai")
public class AiJobController {
    private final AiJobService aiJobService;

    public AiJobController(AiJobService aiJobService) {
        this.aiJobService = aiJobService;
    }

    @GetMapping("/health")
    public ServiceHealth health() {
        return new ServiceHealth("ai-service", "UP");
    }

    @GetMapping("/jobs")
    public List<AiJob> listByClip(@RequestParam Long clipId) {
        return aiJobService.listByClip(clipId);
    }

    @PostMapping("/jobs")
    public AiJob createJob(@Valid @RequestBody CreateAiJobRequest request) {
        return aiJobService.createJob(request);
    }
}
