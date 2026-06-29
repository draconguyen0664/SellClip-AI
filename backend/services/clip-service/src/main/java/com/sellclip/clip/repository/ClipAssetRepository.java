package com.sellclip.clip.repository;

import com.sellclip.clip.entity.ClipAsset;
import java.util.List;
import org.springframework.data.jpa.repository.JpaRepository;

public interface ClipAssetRepository extends JpaRepository<ClipAsset, Long> {
    List<ClipAsset> findByOwnerIdOrderByCreatedAtDesc(Long ownerId);
}
