package com.sellclip.clip.domain;

import java.util.List;
import org.springframework.data.jpa.repository.JpaRepository;

public interface ClipAssetRepository extends JpaRepository<ClipAsset, Long> {
    List<ClipAsset> findByOwnerIdOrderByCreatedAtDesc(Long ownerId);
}

