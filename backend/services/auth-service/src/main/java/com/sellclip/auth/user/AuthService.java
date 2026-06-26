package com.sellclip.auth.user;

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
public class AuthService {
    private static final SecureRandom RANDOM = new SecureRandom();

    private final UserAccountRepository users;
    private final PasswordEncoder passwordEncoder;

    public AuthService(UserAccountRepository users, PasswordEncoder passwordEncoder) {
        this.users = users;
        this.passwordEncoder = passwordEncoder;
    }

    @Transactional
    public AuthResponse register(AuthController.RegisterRequest request) {
        String email = normalizeEmail(request.email());
        if (!request.acceptedTerms()) {
            throw new AuthException(HttpStatus.BAD_REQUEST, "terms_not_accepted", "Chưa đồng ý điều khoản");
        }
        if (!request.password().equals(request.confirmPassword())) {
            throw new AuthException(HttpStatus.BAD_REQUEST, "password_mismatch", "Mật khẩu không trùng");
        }
        if (isWeakPassword(request.password())) {
            throw new AuthException(HttpStatus.BAD_REQUEST, "password_weak", "Mật khẩu yếu");
        }
        if (users.existsByEmail(email)) {
            throw new AuthException(HttpStatus.CONFLICT, "email_exists", "Email đã tồn tại");
        }

        UserAccount user = new UserAccount(
                email,
                request.displayName().trim(),
                passwordEncoder.encode(request.password()));
        String code = nextCode();
        user.setVerificationCode(code, Instant.now().plus(15, ChronoUnit.MINUTES));
        users.save(user);

        return AuthResponse.forUser("success", "Đăng ký thành công, vui lòng xác minh email", user, null)
                .withDevCode(code);
    }

    @Transactional(readOnly = true)
    public AuthResponse login(AuthController.LoginRequest request) {
        UserAccount user = findByEmail(normalizeEmail(request.email()));
        if (user.isLocked()) {
            throw new AuthException(HttpStatus.LOCKED, "account_locked", "Tài khoản bị khóa");
        }
        if (!passwordEncoder.matches(request.password(), user.getPasswordHash())) {
            throw new AuthException(HttpStatus.UNAUTHORIZED, "wrong_credentials", "Email hoặc mật khẩu không đúng");
        }
        if (!user.isEmailVerified()) {
            throw new AuthException(HttpStatus.FORBIDDEN, "email_not_verified", "Email chưa xác minh");
        }

        String token = UUID.randomUUID().toString();
        return AuthResponse.forUser("login_success", "Đăng nhập thành công", user, token);
    }

    @Transactional
    public AuthResponse googleLogin(AuthController.GoogleLoginRequest request) {
        String email = normalizeEmail(request.email());
        UserAccount user = users.findByEmail(email)
                .orElseGet(() -> new UserAccount(
                        email,
                        request.displayName().trim(),
                        passwordEncoder.encode(UUID.randomUUID().toString())));

        if (user.isLocked()) {
            throw new AuthException(HttpStatus.LOCKED, "account_locked", "Tài khoản bị khóa");
        }

        String subject = request.googleId();
        if (subject == null || subject.isBlank()) {
            subject = email;
        }
        user.markGoogleAccount(subject);
        users.save(user);

        return AuthResponse.forUser("login_success", "Đăng nhập Google thành công", user, UUID.randomUUID().toString());
    }

    @Transactional
    public AuthResponse verifyEmail(AuthController.VerifyEmailRequest request) {
        UserAccount user = findByEmail(normalizeEmail(request.email()));
        if (user.isEmailVerified()) {
            return AuthResponse.forUser("verified_successfully", "Email đã được xác minh", user, null);
        }
        if (user.getVerificationCode() == null || !user.getVerificationCode().equals(request.code().trim())) {
            throw new AuthException(HttpStatus.BAD_REQUEST, "code_invalid", "Mã xác minh không đúng");
        }
        if (user.getVerificationCodeExpiresAt().isBefore(Instant.now())) {
            throw new AuthException(HttpStatus.BAD_REQUEST, "code_expired", "Mã xác minh đã hết hạn");
        }

        user.markEmailVerified();
        return AuthResponse.forUser("verified_successfully", "Xác minh email thành công", user, UUID.randomUUID().toString());
    }

    @Transactional
    public AuthResponse resendVerification(String rawEmail) {
        UserAccount user = findByEmail(normalizeEmail(rawEmail));
        String code = nextCode();
        user.setVerificationCode(code, Instant.now().plus(15, ChronoUnit.MINUTES));
        return AuthResponse.forUser("resend_available", "Đã gửi lại mã xác minh", user, null)
                .withDevCode(code);
    }

    @Transactional
    public AuthResponse forgotPassword(AuthController.ForgotPasswordRequest request) {
        UserAccount user = findByEmail(normalizeEmail(request.email()));
        String resetToken = nextCode();
        user.setResetToken(resetToken, Instant.now().plus(20, ChronoUnit.MINUTES));
        return AuthResponse.forUser("reset_requested", "Đã tạo yêu cầu đặt lại mật khẩu", user, null)
                .withDevResetToken(resetToken);
    }

    @Transactional
    public AuthResponse resetPassword(AuthController.ResetPasswordRequest request) {
        UserAccount user = findByEmail(normalizeEmail(request.email()));
        if (user.getResetToken() == null || !user.getResetToken().equals(request.code().trim())) {
            throw new AuthException(HttpStatus.BAD_REQUEST, "token_invalid", "Mã đặt lại không hợp lệ");
        }
        if (user.getResetTokenExpiresAt().isBefore(Instant.now())) {
            throw new AuthException(HttpStatus.BAD_REQUEST, "token_expired", "Mã đặt lại đã hết hạn");
        }
        if (!request.newPassword().equals(request.confirmPassword())) {
            throw new AuthException(HttpStatus.BAD_REQUEST, "password_mismatch", "Mật khẩu không trùng");
        }
        if (isWeakPassword(request.newPassword())) {
            throw new AuthException(HttpStatus.BAD_REQUEST, "password_weak", "Mật khẩu yếu");
        }

        user.updatePassword(passwordEncoder.encode(request.newPassword()));
        return AuthResponse.forUser("password_updated", "Đã cập nhật mật khẩu", user, null);
    }

    @Transactional
    public AuthResponse saveOnboarding(AuthController.OnboardingRequest request) {
        if (request.userId() == null) {
            throw new AuthException(HttpStatus.BAD_REQUEST, "missing_user", "Thiếu userId");
        }
        UserAccount user = users.findById(request.userId())
                .orElseThrow(() -> new AuthException(HttpStatus.NOT_FOUND, "account_not_found", "Không tìm thấy tài khoản"));

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
                request.skipped() ? "Đã bỏ qua thiết lập ban đầu" : "Đã hoàn tất thiết lập ban đầu",
                user,
                UUID.randomUUID().toString());
    }

    private UserAccount findByEmail(String email) {
        return users.findByEmail(email)
                .orElseThrow(() -> new AuthException(HttpStatus.NOT_FOUND, "account_not_found", "Không tìm thấy tài khoản"));
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
