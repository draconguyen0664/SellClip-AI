package com.sellclip.clip.controller;

import com.sellclip.clip.dto.BrandKitCreateResponse;
import com.sellclip.clip.dto.BrandKitResponse;
import com.sellclip.clip.dto.BrandKitSelectionRequest;
import com.sellclip.clip.dto.BrandKitSelectionResponse;
import com.sellclip.clip.dto.CreateBrandKitRequest;
import com.sellclip.clip.service.BrandKitService;
import jakarta.validation.Valid;
import java.util.List;
import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

@CrossOrigin(origins = "*")
@RestController
@RequestMapping("/api/brand-kits")
public class BrandKitController {
    private final BrandKitService brandKitService;

    public BrandKitController(BrandKitService brandKitService) {
        this.brandKitService = brandKitService;
    }

    @GetMapping
    public List<BrandKitResponse> list(
            @RequestParam("ownerId") Long ownerId,
            @RequestParam(value = "query", required = false) String query
    ) {
        return brandKitService.list(ownerId, query);
    }

    @PostMapping
    public BrandKitCreateResponse create(@Valid @RequestBody CreateBrandKitRequest request) {
        return brandKitService.create(request);
    }

    @PostMapping("/selection")
    public BrandKitSelectionResponse select(@Valid @RequestBody BrandKitSelectionRequest request) {
        return brandKitService.select(request);
    }
}
