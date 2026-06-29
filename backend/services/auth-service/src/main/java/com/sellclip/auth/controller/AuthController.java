package com.sellclip.auth.controller;

import com.sellclip.auth.dto.AuthResponse;
import com.sellclip.auth.dto.EmailRequest;
import com.sellclip.auth.dto.ForgotPasswordRequest;
import com.sellclip.auth.dto.GoogleLoginRequest;
import com.sellclip.auth.dto.LoginRequest;
import com.sellclip.auth.dto.OnboardingRequest;
import com.sellclip.auth.dto.RegisterRequest;
import com.sellclip.auth.dto.ResetPasswordRequest;
import com.sellclip.auth.dto.ServiceHealth;
import com.sellclip.auth.dto.VerifyEmailRequest;
import com.sellclip.auth.service.AuthService;
import jakarta.validation.Valid;
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
}
