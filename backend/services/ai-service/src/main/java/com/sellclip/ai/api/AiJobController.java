package com.sellclip.ai.api;

import com.sellclip.ai.domain.AiJob;
import com.sellclip.ai.domain.AiJobRepository;
import jakarta.validation.Valid;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
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
    private final AiJobRepository jobs;

    public AiJobController(AiJobRepository jobs) {
        this.jobs = jobs;
    }

    @GetMapping("/health")
    public ServiceHealth health() {
        return new ServiceHealth("ai-service", "UP");
    }

    @GetMapping("/jobs")
    public List<AiJob> listByClip(@RequestParam Long clipId) {
        return jobs.findByClipIdOrderByCreatedAtDesc(clipId);
    }

    @PostMapping("/jobs")
    public AiJob createJob(@Valid @RequestBody CreateAiJobRequest request) {
        return jobs.save(new AiJob(request.clipId(), request.jobType()));
    }

    public record CreateAiJobRequest(@NotNull Long clipId, @NotBlank String jobType) {
    }

    public record ServiceHealth(String service, String status) {
    }
}

