package com.sellclip.clip.serviceimpl;

import com.sellclip.clip.dto.BrandKitCreateResponse;
import com.sellclip.clip.dto.BrandKitResponse;
import com.sellclip.clip.dto.BrandKitSelectionRequest;
import com.sellclip.clip.dto.BrandKitSelectionResponse;
import com.sellclip.clip.dto.CreateBrandKitRequest;
import com.sellclip.clip.entity.BrandKit;
import com.sellclip.clip.entity.BrandKitStatus;
import com.sellclip.clip.entity.ProjectBrandKitSelection;
import com.sellclip.clip.repository.BrandKitRepository;
import com.sellclip.clip.repository.ProjectBrandKitSelectionRepository;
import com.sellclip.clip.service.BrandKitService;
import java.time.Instant;
import java.time.LocalDate;
import java.time.ZoneId;
import java.util.List;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
public class BrandKitServiceImpl implements BrandKitService {
    private final BrandKitRepository brandKits;
    private final ProjectBrandKitSelectionRepository selections;

    public BrandKitServiceImpl(
            BrandKitRepository brandKits,
            ProjectBrandKitSelectionRepository selections
    ) {
        this.brandKits = brandKits;
        this.selections = selections;
    }

    @Override
    @Transactional
    public List<BrandKitResponse> list(Long ownerId, String query) {
        seedDefaultBrandKits(ownerId);
        Long selectedId = selectedBrandKitId(ownerId);
        String normalizedQuery = query == null ? "" : query.trim();
        List<BrandKit> items = normalizedQuery.isEmpty()
                ? brandKits.findByOwnerIdAndStatusOrderByUpdatedAtDesc(ownerId, BrandKitStatus.ACTIVE)
                : brandKits.findByOwnerIdAndStatusAndNameContainingIgnoreCaseOrderByUpdatedAtDesc(
                        ownerId,
                        BrandKitStatus.ACTIVE,
                        normalizedQuery
                );
        return items.stream().map(item -> BrandKitResponse.from(item, selectedId)).toList();
    }

    @Override
    @Transactional
    public BrandKitCreateResponse create(CreateBrandKitRequest request) {
        String palette = normalizePalette(request.palette());
        int fontCount = countFonts(request.headingFont(), request.bodyFont());
        int assetCount = Math.max(0, safeCount(request.productAssetCount()))
                + Math.max(0, safeCount(request.iconAssetCount()));
        String logoCode = normalizeLogoCode(request.logoCode(), request.name());

        BrandKit brandKit = new BrandKit(
                request.ownerId(),
                request.name().trim(),
                logoCode,
                palette,
                fontCount,
                assetCount,
                Instant.now()
        );
        brandKit.applyTypography(request.headingFont(), request.bodyFont());
        BrandKit saved = brandKits.save(brandKit);
        ProjectBrandKitSelection selection = selections
                .findByOwnerId(request.ownerId())
                .orElseGet(() -> new ProjectBrandKitSelection(request.ownerId(), saved.getId()));
        selection.changeBrandKit(saved.getId());
        selections.save(selection);

        return BrandKitCreateResponse.created(BrandKitResponse.from(saved, saved.getId()));
    }

    @Override
    @Transactional
    public BrandKitSelectionResponse select(BrandKitSelectionRequest request) {
        seedDefaultBrandKits(request.ownerId());
        BrandKit brandKit = brandKits
                .findById(request.brandKitId())
                .filter(item -> item.getOwnerId().equals(request.ownerId()))
                .filter(item -> item.getStatus() == BrandKitStatus.ACTIVE)
                .orElseThrow(() -> new IllegalArgumentException("Brand Kit not found"));

        ProjectBrandKitSelection selection = selections
                .findByOwnerId(request.ownerId())
                .orElseGet(() -> new ProjectBrandKitSelection(request.ownerId(), brandKit.getId()));
        selection.changeBrandKit(brandKit.getId());
        selections.save(selection);

        return BrandKitSelectionResponse.saved(BrandKitResponse.from(brandKit, brandKit.getId()));
    }

    private Long selectedBrandKitId(Long ownerId) {
        return selections
                .findByOwnerId(ownerId)
                .map(ProjectBrandKitSelection::getBrandKitId)
                .orElseGet(() -> brandKits
                        .findByOwnerIdAndStatusOrderByUpdatedAtDesc(ownerId, BrandKitStatus.ACTIVE)
                        .stream()
                        .findFirst()
                        .map(BrandKit::getId)
                        .orElse(null));
    }

    private void seedDefaultBrandKits(Long ownerId) {
        if (brandKits.countByOwnerIdAndStatus(ownerId, BrandKitStatus.ACTIVE) > 0) {
            return;
        }

        List<BrandKit> defaults = List.of(
                new BrandKit(ownerId, "SellClip Default", "SELLCLIP",
                        "#7B2DFF,#275CFF,#CC36C9,#1E1E1E,#F4F7FF", 2, 18, date("2025-05-28")),
                new BrandKit(ownerId, "Glow Beauty", "GLOW",
                        "#F7C9C7,#C79AAD,#EAD7C8,#C7B9A6,#F5F7FA", 3, 22, date("2025-05-20")),
                new BrandKit(ownerId, "Fashion House", "FASHION",
                        "#D7B85F,#1A1A1A,#373737,#7A7A7A,#F5F7FA", 2, 20, date("2025-05-18")),
                new BrandKit(ownerId, "Tech Shop", "TECH",
                        "#425CFF,#5BDEEA,#41B7DA,#3D3D3D,#F5F7FA", 3, 16, date("2025-05-15")),
                new BrandKit(ownerId, "Organic Home", "ORGANIC",
                        "#63B03C,#A0C46B,#DBE6B3,#EFE8DA,#F5F7FA", 2, 14, date("2025-05-10"))
        );
        List<BrandKit> saved = brandKits.saveAll(defaults);
        if (!saved.isEmpty() && selections.findByOwnerId(ownerId).isEmpty()) {
            selections.save(new ProjectBrandKitSelection(ownerId, saved.get(0).getId()));
        }
    }

    private Instant date(String value) {
        return LocalDate.parse(value).atStartOfDay(ZoneId.systemDefault()).toInstant();
    }

    private String normalizePalette(List<String> palette) {
        if (palette == null || palette.isEmpty()) {
            return "#7B2DFF,#275CFF,#CC36C9,#1E1E1E,#F4F7FF";
        }
        return palette.stream()
                .map(String::trim)
                .filter(value -> !value.isBlank())
                .limit(8)
                .reduce((left, right) -> left + "," + right)
                .orElse("#7B2DFF,#275CFF,#CC36C9,#1E1E1E,#F4F7FF");
    }

    private int countFonts(String headingFont, String bodyFont) {
        int count = 0;
        if (headingFont != null && !headingFont.isBlank()) {
            count++;
        }
        if (bodyFont != null && !bodyFont.isBlank()
                && (headingFont == null || !bodyFont.equalsIgnoreCase(headingFont))) {
            count++;
        }
        return Math.max(1, count);
    }

    private int safeCount(Integer count) {
        return count == null ? 0 : count;
    }

    private String normalizeLogoCode(String logoCode, String name) {
        String source = logoCode == null || logoCode.isBlank() ? name : logoCode;
        String clean = source.replaceAll("[^A-Za-z0-9]", "").toUpperCase();
        if (clean.isBlank()) {
            return "BRAND";
        }
        return clean.length() > 40 ? clean.substring(0, 40) : clean;
    }
}
