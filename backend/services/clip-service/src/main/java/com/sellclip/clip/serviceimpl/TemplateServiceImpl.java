package com.sellclip.clip.serviceimpl;

import com.sellclip.clip.dto.TemplateResponse;
import com.sellclip.clip.dto.TemplateSelectionRequest;
import com.sellclip.clip.dto.TemplateSelectionResponse;
import com.sellclip.clip.entity.ClipTemplate;
import com.sellclip.clip.entity.ProjectTemplateSelection;
import com.sellclip.clip.entity.TemplateStatus;
import com.sellclip.clip.repository.ClipTemplateRepository;
import com.sellclip.clip.repository.ProjectTemplateSelectionRepository;
import com.sellclip.clip.service.TemplateService;
import java.time.Instant;
import java.util.List;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
public class TemplateServiceImpl implements TemplateService {
    private final ClipTemplateRepository templates;
    private final ProjectTemplateSelectionRepository selections;

    public TemplateServiceImpl(
            ClipTemplateRepository templates,
            ProjectTemplateSelectionRepository selections
    ) {
        this.templates = templates;
        this.selections = selections;
    }

    @Override
    @Transactional
    public List<TemplateResponse> list(Long ownerId, String query, String category) {
        seedDefaults(ownerId);
        Long selectedId = selectedTemplateId(ownerId);
        String normalizedQuery = query == null ? "" : query.trim();
        String normalizedCategory = category == null ? "" : category.trim();

        List<ClipTemplate> items;
        if (normalizedQuery.isEmpty() && normalizedCategory.isEmpty()) {
            items = templates.findByOwnerIdAndStatusOrderByUpdatedAtDesc(ownerId, TemplateStatus.ACTIVE);
        } else if (normalizedQuery.isEmpty()) {
            items = templates.findByOwnerIdAndStatusAndCategoryIgnoreCaseOrderByUpdatedAtDesc(
                    ownerId, TemplateStatus.ACTIVE, normalizedCategory);
        } else if (normalizedCategory.isEmpty()) {
            items = templates.findByOwnerIdAndStatusAndNameContainingIgnoreCaseOrderByUpdatedAtDesc(
                    ownerId, TemplateStatus.ACTIVE, normalizedQuery);
        } else {
            items = templates.findByOwnerIdAndStatusAndCategoryIgnoreCaseAndNameContainingIgnoreCaseOrderByUpdatedAtDesc(
                    ownerId, TemplateStatus.ACTIVE, normalizedCategory, normalizedQuery);
        }
        return items.stream().map(item -> TemplateResponse.from(item, selectedId)).toList();
    }

    @Override
    @Transactional
    public TemplateSelectionResponse select(TemplateSelectionRequest request) {
        seedDefaults(request.ownerId());
        ProjectTemplateSelection selection = selections
                .findByOwnerId(request.ownerId())
                .orElseGet(() -> new ProjectTemplateSelection(request.ownerId(), null, true));

        if (Boolean.TRUE.equals(request.noTemplate()) || request.templateId() == null) {
            selection.chooseBlank();
            selections.save(selection);
            return TemplateSelectionResponse.blank();
        }

        ClipTemplate template = templates
                .findById(request.templateId())
                .filter(item -> item.getOwnerId().equals(request.ownerId()))
                .filter(item -> item.getStatus() == TemplateStatus.ACTIVE)
                .orElseThrow(() -> new IllegalArgumentException("Template not found"));

        selection.chooseTemplate(template.getId());
        selections.save(selection);
        return TemplateSelectionResponse.saved(TemplateResponse.from(template, template.getId()));
    }

    private Long selectedTemplateId(Long ownerId) {
        return selections
                .findByOwnerId(ownerId)
                .filter(selection -> !Boolean.TRUE.equals(selection.getNoTemplate()))
                .map(ProjectTemplateSelection::getTemplateId)
                .orElse(null);
    }

    private void seedDefaults(Long ownerId) {
        if (templates.countByOwnerIdAndStatus(ownerId, TemplateStatus.ACTIVE) > 0) {
            return;
        }
        templates.saveAll(List.of(
                new ClipTemplate(ownerId, "Glow Serum Ad", "Mỹ phẩm", "9:16", 15, false, "glow", Instant.now()),
                new ClipTemplate(ownerId, "Fashion Sale", "Thời trang", "9:16", 15, true, "fashion", Instant.now()),
                new ClipTemplate(ownerId, "Flash Sale 6.6", "Flash sale", "9:16", 15, true, "flash", Instant.now()),
                new ClipTemplate(ownerId, "Review Son Môi", "Review", "9:16", 15, false, "review", Instant.now())
        ));
        if (selections.findByOwnerId(ownerId).isEmpty()) {
            selections.save(new ProjectTemplateSelection(ownerId, null, true));
        }
    }
}
