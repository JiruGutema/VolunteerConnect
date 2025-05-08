package com.mobile.volunteerconnect

import android.os.Bundle
import androidx.activity.ComponentActivity
import androidx.activity.compose.setContent
import com.mobile.volunteerconnect.data.preferences.UserPreferences
import com.mobile.volunteerconnect.ui.theme.VolunteerConnectTheme
import com.mobile.volunteerconnect.view.navigator.AppNavigation
import dagger.hilt.android.AndroidEntryPoint
import javax.inject.Inject

@AndroidEntryPoint
class MainActivity : ComponentActivity() {
    @Inject
    lateinit var userPreferences: UserPreferences

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContent {
            VolunteerConnectTheme {
                AppNavigation(userPreferences)
            }
        }
    }
}

