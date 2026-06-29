package com.sellclip.auth.entity;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.Table;
import java.time.Instant;

@Entity
@Table(name = "user_accounts")
public class UserAccount {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(nullable = false, unique = true, length = 120)
    private String email;

    @Column(nullable = false, length = 120)
    private String displayName;

    @Column(nullable = false, length = 120)
    private String passwordHash;

    @Column(nullable = false, length = 32)
    private String authProvider = "local";

    @Column(length = 160)
    private String providerSubject;

    @Column(nullable = false)
    private boolean onboardingCompleted = false;

    @Column(nullable = false)
    private boolean onboardingSkipped = false;

    @Column(length = 80)
    private String industry;

    @Column(length = 500)
    private String platforms;

    @Column(length = 500)
    private String contentGoals;

    @Column(length = 80)
    private String mediaType;

    @Column(length = 500)
    private String contentStyles;

    @Column(length = 80)
    private String voiceType;

    @Column(nullable = false)
    private boolean emailVerified = false;

    @Column(nullable = false)
    private boolean locked = false;

    @Column(length = 12)
    private String verificationCode;

    private Instant verificationCodeExpiresAt;

    @Column(length = 120)
    private String resetToken;

    private Instant resetTokenExpiresAt;

    @Column(nullable = false)
    private Instant createdAt = Instant.now();

    private Instant updatedAt = Instant.now();

    protected UserAccount() {
    }

    public UserAccount(String email, String displayName, String passwordHash) {
        this.email = email;
        this.displayName = displayName;
        this.passwordHash = passwordHash;
    }

    public Long getId() {
        return id;
    }

    public String getEmail() {
        return email;
    }

    public String getDisplayName() {
        return displayName;
    }

    public String getPasswordHash() {
        return passwordHash;
    }

    public String getAuthProvider() {
        return authProvider;
    }

    public String getProviderSubject() {
        return providerSubject;
    }

    public boolean isOnboardingCompleted() {
        return onboardingCompleted;
    }

    public boolean isOnboardingSkipped() {
        return onboardingSkipped;
    }

    public boolean isEmailVerified() {
        return emailVerified;
    }

    public boolean isLocked() {
        return locked;
    }

    public String getVerificationCode() {
        return verificationCode;
    }

    public Instant getVerificationCodeExpiresAt() {
        return verificationCodeExpiresAt;
    }

    public String getResetToken() {
        return resetToken;
    }

    public Instant getResetTokenExpiresAt() {
        return resetTokenExpiresAt;
    }

    public Instant getCreatedAt() {
        return createdAt;
    }

    public Instant getUpdatedAt() {
        return updatedAt;
    }

    public void setVerificationCode(String verificationCode, Instant expiresAt) {
        this.verificationCode = verificationCode;
        this.verificationCodeExpiresAt = expiresAt;
        touch();
    }

    public void markEmailVerified() {
        this.emailVerified = true;
        this.verificationCode = null;
        this.verificationCodeExpiresAt = null;
        touch();
    }

    public void setResetToken(String resetToken, Instant expiresAt) {
        this.resetToken = resetToken;
        this.resetTokenExpiresAt = expiresAt;
        touch();
    }

    public void updatePassword(String passwordHash) {
        this.passwordHash = passwordHash;
        this.authProvider = "local";
        this.resetToken = null;
        this.resetTokenExpiresAt = null;
        touch();
    }

    public void markGoogleAccount(String googleId) {
        this.authProvider = "google";
        this.providerSubject = googleId;
        this.emailVerified = true;
        touch();
    }

    public void completeOnboarding(
            boolean skipped,
            String industry,
            String platforms,
            String contentGoals,
            String mediaType,
            String contentStyles,
            String voiceType) {
        this.onboardingCompleted = true;
        this.onboardingSkipped = skipped;
        this.industry = industry;
        this.platforms = platforms;
        this.contentGoals = contentGoals;
        this.mediaType = mediaType;
        this.contentStyles = contentStyles;
        this.voiceType = voiceType;
        touch();
    }

    private void touch() {
        this.updatedAt = Instant.now();
    }
}
