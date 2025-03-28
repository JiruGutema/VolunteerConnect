package com.example.anative

import android.os.Bundle
import androidx.activity.ComponentActivity
import androidx.activity.compose.setContent
import androidx.compose.material3.*
import androidx.compose.runtime.Composable
import androidx.navigation.compose.*
import com.example.anative.ui.theme.NativeTheme

class MainActivity : ComponentActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContent {
            NativeTheme {
                VolunteerApp()
            }
        }
    }
}

@Composable
fun VolunteerApp() {
    val navController = rememberNavController()
    NavHost(navController, startDestination = "login") {
        composable("login") {
            LoginScreen { email, password ->
                // Handle login logic
                navController.navigate("signup")
            }
        }
        composable("signup") {
            SignupScreen { username, email, password ->
                // Handle signup logic
                navController.navigate("post")
            }
        }
        composable("post") {
            PostScreen { title, description, location ->
                // Handle post logic
                navController.navigate("postList")
            }
        }
        composable("postList") {
            PostListScreen(posts = mockPosts)
        }
    }
}