package com.sellclip.auth.service;

import com.sellclip.auth.dto.AuthResponse;
import com.sellclip.auth.dto.ForgotPasswordRequest;
import com.sellclip.auth.dto.GoogleLoginRequest;
import com.sellclip.auth.dto.LoginRequest;
import com.sellclip.auth.dto.OnboardingRequest;
import com.sellclip.auth.dto.RegisterRequest;
import com.sellclip.auth.dto.ResetPasswordRequest;
import com.sellclip.auth.dto.VerifyEmailRequest;

public interface AuthService {
    AuthResponse register(RegisterRequest request);

    AuthResponse login(LoginRequest request);

    AuthResponse googleLogin(GoogleLoginRequest request);

    AuthResponse verifyEmail(VerifyEmailRequest request);

    AuthResponse resendVerification(String rawEmail);

    AuthResponse forgotPassword(ForgotPasswordRequest request);

    AuthResponse resetPassword(ResetPasswordRequest request);

    AuthResponse saveOnboarding(OnboardingRequest request);
}
