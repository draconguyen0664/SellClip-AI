package com.sellclip.clip.controller;

import com.sellclip.clip.dto.TemplateResponse;
import com.sellclip.clip.dto.TemplateSelectionRequest;
import com.sellclip.clip.dto.TemplateSelectionResponse;
import com.sellclip.clip.service.TemplateService;
import jakarta.validation.Valid;
import java.util.List;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/api/templates")
public class TemplateController {
    private final TemplateService templateService;

    public TemplateController(TemplateService templateService) {
        this.templateService = templateService;
    }

    @GetMapping
    public List<TemplateResponse> list(
            @RequestParam("ownerId") Long ownerId,
            @RequestParam(value = "query", required = false) String query,
            @RequestParam(value = "category", required = false) String category
    ) {
        return templateService.list(ownerId, query, category);
    }

    @PostMapping("/selection")
    public TemplateSelectionResponse select(@Valid @RequestBody TemplateSelectionRequest request) {
        return templateService.select(request);
    }
}
