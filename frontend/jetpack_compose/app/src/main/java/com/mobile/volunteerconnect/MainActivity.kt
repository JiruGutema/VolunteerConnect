package com.mobile.volunteerconnect

import android.os.Bundle
import androidx.activity.ComponentActivity
import androidx.activity.compose.setContent
import androidx.compose.foundation.layout.*
import androidx.compose.material3.*
import androidx.compose.runtime.Composable
import androidx.compose.runtime.rememberCoroutineScope
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.unit.dp
import androidx.hilt.navigation.compose.hiltViewModel
import androidx.navigation.NavController
import androidx.navigation.compose.NavHost
import androidx.navigation.compose.composable
import androidx.navigation.compose.rememberNavController
import com.mobile.volunteerconnect.data.preferences.UserPreferences
import com.mobile.volunteerconnect.ui.theme.VolunteerConnectTheme
import com.mobile.volunteerconnect.view.pages.login.LoginScreen
import com.mobile.volunteerconnect.view.pages.signup.SignupScreen
import com.mobile.volunteerconnect.viewModel.AuthViewModel
import dagger.hilt.android.AndroidEntryPoint
import kotlinx.coroutines.launch
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

@Composable
fun AppNavigation(userPreferences: UserPreferences) {
    val navController = rememberNavController()
    val viewModel: AuthViewModel = hiltViewModel()
    val isTokenValid = viewModel.isTokenValid

    if (isTokenValid == null) {
        SplashScreen()
    } else {
        NavHost(
            navController = navController,
            startDestination = if (isTokenValid) "home" else "login"
        ) {
            composable("login") {
                LoginScreen(
                    onLoginSuccess = {
                        navController.navigate("home") {
                            popUpTo("login") { inclusive = true }
                        }
                    },
                    onSignUpClick = {
                        navController.navigate("signup")
                    }
                )
            }

            composable("signup"){
                SignupScreen(  onSignupSuccess = {
                    navController.navigate("home") {
                        popUpTo("login") { inclusive = true }
                    }
                },
                    onLoginClick = {
                        navController.navigate("login")
                    })

            }

            composable("home") {
                HomeScreen(userPreferences, navController)
            }
        }
    }
}

@Composable
fun SplashScreen() {
    Box(
        contentAlignment = Alignment.Center,
        modifier = Modifier.fillMaxSize()
    ) {
        CircularProgressIndicator()
    }
}

@Composable
fun HomeScreen(userPreferences: UserPreferences, navController: NavController) {
    val coroutineScope = rememberCoroutineScope()

    Box(
        contentAlignment = Alignment.Center,
        modifier = Modifier.fillMaxSize()
    ) {
        Column(horizontalAlignment = Alignment.CenterHorizontally) {
            Text(text = "Welcome Home!")
            Spacer(modifier = Modifier.height(16.dp))
            Button(onClick = {
                coroutineScope.launch {
                    userPreferences.clearUserData()
                    navController.navigate("login") {
                        popUpTo("home") { inclusive = true }
                    }
                }
            }) {
                Text(text = "Logout")
            }
        }
    }
}