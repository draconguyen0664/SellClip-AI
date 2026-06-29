package com.sellclip.clip.serviceimpl;

import com.sellclip.clip.dto.CreateClipRequest;
import com.sellclip.clip.entity.ClipAsset;
import com.sellclip.clip.repository.ClipAssetRepository;
import com.sellclip.clip.service.ClipService;
import java.util.List;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
public class ClipServiceImpl implements ClipService {
    private final ClipAssetRepository clips;

    public ClipServiceImpl(ClipAssetRepository clips) {
        this.clips = clips;
    }

    @Override
    @Transactional(readOnly = true)
    public List<ClipAsset> listByOwner(Long ownerId) {
        return clips.findByOwnerIdOrderByCreatedAtDesc(ownerId);
    }

    @Override
    @Transactional
    public ClipAsset create(CreateClipRequest request) {
        return clips.save(new ClipAsset(request.ownerId(), request.title(), request.sourceUrl()));
    }
}
