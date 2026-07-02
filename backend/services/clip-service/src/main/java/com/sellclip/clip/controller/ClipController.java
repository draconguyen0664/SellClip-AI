package com.sellclip.clip.controller;

import com.sellclip.clip.dto.CreateClipRequest;
import com.sellclip.clip.dto.ServiceHealth;
import com.sellclip.clip.entity.ClipAsset;
import com.sellclip.clip.service.ClipService;
import jakarta.validation.Valid;
import java.util.List;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/api/clips")
public class ClipController {
    private final ClipService clipService;

    public ClipController(ClipService clipService) {
        this.clipService = clipService;
    }

    @GetMapping("/health")
    public ServiceHealth health() {
        return new ServiceHealth("clip-service", "UP");
    }

    @GetMapping
    public List<ClipAsset> listByOwner(@RequestParam("ownerId") Long ownerId) {
        return clipService.listByOwner(ownerId);
    }

    @PostMapping
    public ClipAsset create(@Valid @RequestBody CreateClipRequest request) {
        return clipService.create(request);
    }
}

