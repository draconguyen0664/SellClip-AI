package com.sellclip.ai.repository;

import com.sellclip.ai.entity.AiJob;
import java.util.List;
import org.springframework.data.jpa.repository.JpaRepository;

public interface AiJobRepository extends JpaRepository<AiJob, Long> {
    List<AiJob> findByClipIdOrderByCreatedAtDesc(Long clipId);
}
