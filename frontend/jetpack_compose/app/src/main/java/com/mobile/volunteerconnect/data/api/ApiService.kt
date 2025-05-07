package com.mobile.volunteerconnect.data.api

import com.mobile.volunteerconnect.data.model.LoginRequest
import com.mobile.volunteerconnect.data.model.LoginResponse
import com.mobile.volunteerconnect.data.model.SignupRequest
import com.mobile.volunteerconnect.data.model.SignupResponse
import okhttp3.MultipartBody
import okhttp3.RequestBody
import retrofit2.Response
import retrofit2.http.*

interface ApiService {
    @POST("api/auth/login")
    suspend fun login(@Body loginRequest: LoginRequest): Response<LoginResponse>

    @POST("api/auth/register")
    suspend fun signup(@Body signupRequest: SignupRequest): Response<SignupResponse>

    @Multipart
    @POST("events/create")
    suspend fun createEvent(
        @Part("image") image: MultipartBody.Part,
        @Part("title") title: RequestBody,
        @Part("subtitle") subtitle: RequestBody,
        @Part("category") category: RequestBody,
        @Part("date") date: RequestBody,
        @Part("time") time: RequestBody,
        @Part("location") location: RequestBody,
        @Part("spotsLeft") spotsLeft: RequestBody,
        @Part("description") description: RequestBody,
        @Part("requirements") requirements: RequestBody,
        @Part("additionalInfo") additionalInfo: RequestBody,
        @Part("contactPhone") contactPhone: RequestBody,
        @Part("contactEmail") contactEmail: RequestBody,
        @Part("contactTelegram") contactTelegram: RequestBody
    ): Response<Unit>

    @GET("/api/checkUser")
    suspend fun checkUser(@Header("Authorization") token: String): Response<Unit>
}