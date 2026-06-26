package com.sellclip.auth.user;

import jakarta.validation.Valid;
import jakarta.validation.constraints.Email;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Size;
import java.util.List;
import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@CrossOrigin
@RestController
@RequestMapping("/api/auth")
public class AuthController {
    private final AuthService authService;

    public AuthController(AuthService authService) {
        this.authService = authService;
    }

    @GetMapping("/health")
    public ServiceHealth health() {
        return new ServiceHealth("auth-service", "UP");
    }

    @PostMapping("/register")
    public AuthResponse register(@Valid @RequestBody RegisterRequest request) {
        return authService.register(request);
    }

    @PostMapping("/login")
    public AuthResponse login(@Valid @RequestBody LoginRequest request) {
        return authService.login(request);
    }

    @PostMapping("/google")
    public AuthResponse googleLogin(@Valid @RequestBody GoogleLoginRequest request) {
        return authService.googleLogin(request);
    }

    @PostMapping("/verify-email")
    public AuthResponse verifyEmail(@Valid @RequestBody VerifyEmailRequest request) {
        return authService.verifyEmail(request);
    }

    @PostMapping("/resend-verification")
    public AuthResponse resendVerification(@Valid @RequestBody EmailRequest request) {
        return authService.resendVerification(request.email());
    }

    @PostMapping("/forgot-password")
    public AuthResponse forgotPassword(@Valid @RequestBody ForgotPasswordRequest request) {
        return authService.forgotPassword(request);
    }

    @PostMapping("/reset-password")
    public AuthResponse resetPassword(@Valid @RequestBody ResetPasswordRequest request) {
        return authService.resetPassword(request);
    }

    @PostMapping("/onboarding")
    public AuthResponse saveOnboarding(@Valid @RequestBody OnboardingRequest request) {
        return authService.saveOnboarding(request);
    }

    public record RegisterRequest(
            @NotBlank String displayName,
            @Email @NotBlank String email,
            @Size(min = 8) String password,
            @Size(min = 8) String confirmPassword,
            boolean acceptedTerms) {
    }

    public record LoginRequest(@Email @NotBlank String email, @NotBlank String password, boolean rememberMe) {
    }

    public record GoogleLoginRequest(
            @Email @NotBlank String email,
            @NotBlank String displayName,
            String googleId,
            String idToken,
            String accessToken) {
    }

    public record VerifyEmailRequest(@Email @NotBlank String email, @NotBlank String code) {
    }

    public record ForgotPasswordRequest(@Email @NotBlank String email, @NotBlank String deliveryMethod) {
    }

    public record ResetPasswordRequest(
            @Email @NotBlank String email,
            @NotBlank String code,
            @Size(min = 8) String newPassword,
            @Size(min = 8) String confirmPassword) {
    }

    public record EmailRequest(@Email @NotBlank String email) {
    }

    public record OnboardingRequest(
            Long userId,
            boolean skipped,
            String industry,
            List<String> platforms,
            List<String> contentGoals,
            String mediaType,
            List<String> contentStyles,
            String voiceType) {
    }

    public record ServiceHealth(String service, String status) {
    }
}
