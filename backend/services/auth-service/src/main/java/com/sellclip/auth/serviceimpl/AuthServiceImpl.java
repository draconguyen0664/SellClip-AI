package com.sellclip.auth.serviceimpl;

import com.sellclip.auth.dto.AuthResponse;
import com.sellclip.auth.dto.ForgotPasswordRequest;
import com.sellclip.auth.dto.GoogleLoginRequest;
import com.sellclip.auth.dto.LoginRequest;
import com.sellclip.auth.dto.OnboardingRequest;
import com.sellclip.auth.dto.RegisterRequest;
import com.sellclip.auth.dto.ResetPasswordRequest;
import com.sellclip.auth.dto.VerifyEmailRequest;
import com.sellclip.auth.entity.UserAccount;
import com.sellclip.auth.exception.AuthException;
import com.sellclip.auth.repository.UserAccountRepository;
import com.sellclip.auth.service.AuthService;
import java.security.SecureRandom;
import java.time.Instant;
import java.time.temporal.ChronoUnit;
import java.util.Locale;
import java.util.UUID;
import java.util.stream.Collectors;
import org.springframework.http.HttpStatus;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
public class AuthServiceImpl implements AuthService {
    private static final SecureRandom RANDOM = new SecureRandom();

    private final UserAccountRepository users;
    private final PasswordEncoder passwordEncoder;

    public AuthServiceImpl(UserAccountRepository users, PasswordEncoder passwordEncoder) {
        this.users = users;
        this.passwordEncoder = passwordEncoder;
    }

    @Override
    @Transactional
    public AuthResponse register(RegisterRequest request) {
        String email = normalizeEmail(request.email());
        if (!request.acceptedTerms()) {
            throw new AuthException(HttpStatus.BAD_REQUEST, "terms_not_accepted", "Chua dong y dieu khoan");
        }
        if (!request.password().equals(request.confirmPassword())) {
            throw new AuthException(HttpStatus.BAD_REQUEST, "password_mismatch", "Mat khau khong trung");
        }
        if (isWeakPassword(request.password())) {
            throw new AuthException(HttpStatus.BAD_REQUEST, "password_weak", "Mat khau yeu");
        }
        if (users.existsByEmail(email)) {
            throw new AuthException(HttpStatus.CONFLICT, "email_exists", "Email da ton tai");
        }

        UserAccount user = new UserAccount(
                email,
                request.displayName().trim(),
                passwordEncoder.encode(request.password()));
        String code = nextCode();
        user.setVerificationCode(code, Instant.now().plus(15, ChronoUnit.MINUTES));
        users.save(user);

        return AuthResponse.forUser("success", "Dang ky thanh cong, vui long xac minh email", user, null)
                .withDevCode(code);
    }

    @Override
    @Transactional(readOnly = true)
    public AuthResponse login(LoginRequest request) {
        UserAccount user = findByEmail(normalizeEmail(request.email()));
        if (user.isLocked()) {
            throw new AuthException(HttpStatus.LOCKED, "account_locked", "Tai khoan bi khoa");
        }
        if (!passwordEncoder.matches(request.password(), user.getPasswordHash())) {
            throw new AuthException(HttpStatus.UNAUTHORIZED, "wrong_credentials", "Email hoac mat khau khong dung");
        }
        if (!user.isEmailVerified()) {
            throw new AuthException(HttpStatus.FORBIDDEN, "email_not_verified", "Email chua xac minh");
        }

        String token = UUID.randomUUID().toString();
        return AuthResponse.forUser("login_success", "Dang nhap thanh cong", user, token);
    }

    @Override
    @Transactional
    public AuthResponse googleLogin(GoogleLoginRequest request) {
        String email = normalizeEmail(request.email());
        UserAccount user = users.findByEmail(email)
                .orElseGet(() -> new UserAccount(
                        email,
                        request.displayName().trim(),
                        passwordEncoder.encode(UUID.randomUUID().toString())));

        if (user.isLocked()) {
            throw new AuthException(HttpStatus.LOCKED, "account_locked", "Tai khoan bi khoa");
        }

        String subject = request.googleId();
        if (subject == null || subject.isBlank()) {
            subject = email;
        }
        user.markGoogleAccount(subject);
        users.save(user);

        return AuthResponse.forUser("login_success", "Dang nhap Google thanh cong", user, UUID.randomUUID().toString());
    }

    @Override
    @Transactional
    public AuthResponse verifyEmail(VerifyEmailRequest request) {
        UserAccount user = findByEmail(normalizeEmail(request.email()));
        if (user.isEmailVerified()) {
            return AuthResponse.forUser("verified_successfully", "Email da duoc xac minh", user, null);
        }
        if (user.getVerificationCode() == null || !user.getVerificationCode().equals(request.code().trim())) {
            throw new AuthException(HttpStatus.BAD_REQUEST, "code_invalid", "Ma xac minh khong dung");
        }
        if (user.getVerificationCodeExpiresAt().isBefore(Instant.now())) {
            throw new AuthException(HttpStatus.BAD_REQUEST, "code_expired", "Ma xac minh da het han");
        }

        user.markEmailVerified();
        return AuthResponse.forUser("verified_successfully", "Xac minh email thanh cong", user, UUID.randomUUID().toString());
    }

    @Override
    @Transactional
    public AuthResponse resendVerification(String rawEmail) {
        UserAccount user = findByEmail(normalizeEmail(rawEmail));
        String code = nextCode();
        user.setVerificationCode(code, Instant.now().plus(15, ChronoUnit.MINUTES));
        return AuthResponse.forUser("resend_available", "Da gui lai ma xac minh", user, null)
                .withDevCode(code);
    }

    @Override
    @Transactional
    public AuthResponse forgotPassword(ForgotPasswordRequest request) {
        UserAccount user = findByEmail(normalizeEmail(request.email()));
        String resetToken = nextCode();
        user.setResetToken(resetToken, Instant.now().plus(20, ChronoUnit.MINUTES));
        return AuthResponse.forUser("reset_requested", "Da tao yeu cau dat lai mat khau", user, null)
                .withDevResetToken(resetToken);
    }

    @Override
    @Transactional
    public AuthResponse resetPassword(ResetPasswordRequest request) {
        UserAccount user = findByEmail(normalizeEmail(request.email()));
        if (user.getResetToken() == null || !user.getResetToken().equals(request.code().trim())) {
            throw new AuthException(HttpStatus.BAD_REQUEST, "token_invalid", "Ma dat lai khong hop le");
        }
        if (user.getResetTokenExpiresAt().isBefore(Instant.now())) {
            throw new AuthException(HttpStatus.BAD_REQUEST, "token_expired", "Ma dat lai da het han");
        }
        if (!request.newPassword().equals(request.confirmPassword())) {
            throw new AuthException(HttpStatus.BAD_REQUEST, "password_mismatch", "Mat khau khong trung");
        }
        if (isWeakPassword(request.newPassword())) {
            throw new AuthException(HttpStatus.BAD_REQUEST, "password_weak", "Mat khau yeu");
        }

        user.updatePassword(passwordEncoder.encode(request.newPassword()));
        return AuthResponse.forUser("password_updated", "Da cap nhat mat khau", user, null);
    }

    @Override
    @Transactional
    public AuthResponse saveOnboarding(OnboardingRequest request) {
        if (request.userId() == null) {
            throw new AuthException(HttpStatus.BAD_REQUEST, "missing_user", "Thieu userId");
        }
        UserAccount user = users.findById(request.userId())
                .orElseThrow(() -> new AuthException(HttpStatus.NOT_FOUND, "account_not_found", "Khong tim thay tai khoan"));

        user.completeOnboarding(
                request.skipped(),
                valueOrEmpty(request.industry()),
                joinValues(request.platforms()),
                joinValues(request.contentGoals()),
                valueOrEmpty(request.mediaType()),
                joinValues(request.contentStyles()),
                valueOrEmpty(request.voiceType()));

        return AuthResponse.forUser(
                request.skipped() ? "skipped" : "completed",
                request.skipped() ? "Da bo qua thiet lap ban dau" : "Da hoan tat thiet lap ban dau",
                user,
                UUID.randomUUID().toString());
    }

    private UserAccount findByEmail(String email) {
        return users.findByEmail(email)
                .orElseThrow(() -> new AuthException(HttpStatus.NOT_FOUND, "account_not_found", "Khong tim thay tai khoan"));
    }

    private String normalizeEmail(String email) {
        return email.trim().toLowerCase(Locale.ROOT);
    }

    private boolean isWeakPassword(String password) {
        return password.length() < 8
                || password.chars().noneMatch(Character::isDigit)
                || password.chars().noneMatch(Character::isLetter);
    }

    private String valueOrEmpty(String value) {
        return value == null ? "" : value.trim();
    }

    private String joinValues(java.util.List<String> values) {
        if (values == null) {
            return "";
        }
        return values.stream()
                .filter(value -> value != null && !value.isBlank())
                .map(String::trim)
                .collect(Collectors.joining(","));
    }

    private String nextCode() {
        return String.format("%06d", RANDOM.nextInt(1_000_000));
    }
}
