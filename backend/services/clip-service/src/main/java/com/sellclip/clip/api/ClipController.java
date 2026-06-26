package com.sellclip.clip.api;

import com.sellclip.clip.domain.ClipAsset;
import com.sellclip.clip.domain.ClipAssetRepository;
import jakarta.validation.Valid;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import java.util.List;
import org.hibernate.validator.constraints.URL;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/api/clips")
public class ClipController {
    private final ClipAssetRepository clips;

    public ClipController(ClipAssetRepository clips) {
        this.clips = clips;
    }

    @GetMapping("/health")
    public ServiceHealth health() {
        return new ServiceHealth("clip-service", "UP");
    }

    @GetMapping
    public List<ClipAsset> listByOwner(@RequestParam Long ownerId) {
        return clips.findByOwnerIdOrderByCreatedAtDesc(ownerId);
    }

    @PostMapping
    public ClipAsset create(@Valid @RequestBody CreateClipRequest request) {
        return clips.save(new ClipAsset(request.ownerId(), request.title(), request.sourceUrl()));
    }

    public record CreateClipRequest(@NotNull Long ownerId, @NotBlank String title, @URL @NotBlank String sourceUrl) {
    }

    public record ServiceHealth(String service, String status) {
    }
}

