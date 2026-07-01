package com.sellclip.clip.repository;

import com.sellclip.clip.entity.BrandKit;
import com.sellclip.clip.entity.BrandKitStatus;
import java.util.List;
import org.springframework.data.jpa.repository.JpaRepository;

public interface BrandKitRepository extends JpaRepository<BrandKit, Long> {
    long countByOwnerIdAndStatus(Long ownerId, BrandKitStatus status);

    List<BrandKit> findByOwnerIdAndStatusOrderByUpdatedAtDesc(Long ownerId, BrandKitStatus status);

    List<BrandKit> findByOwnerIdAndStatusAndNameContainingIgnoreCaseOrderByUpdatedAtDesc(
            Long ownerId,
            BrandKitStatus status,
            String name
    );
}
