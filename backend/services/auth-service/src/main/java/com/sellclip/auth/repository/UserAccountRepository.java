package com.sellclip.auth.repository;

import com.sellclip.auth.entity.UserAccount;
import java.util.Optional;
import org.springframework.data.jpa.repository.JpaRepository;

public interface UserAccountRepository extends JpaRepository<UserAccount, Long> {
    boolean existsByEmail(String email);

    Optional<UserAccount> findByEmail(String email);
}
