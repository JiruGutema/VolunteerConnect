package com.mobile.volunteerconnect.view.pages.createpost

import android.annotation.SuppressLint
import androidx.compose.foundation.layout.*
import androidx.compose.foundation.rememberScrollState
import androidx.compose.foundation.text.KeyboardOptions
import androidx.compose.foundation.verticalScroll
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.filled.ArrowBack
import androidx.compose.material3.*
import androidx.compose.runtime.*
import androidx.compose.ui.Modifier
import androidx.compose.ui.text.input.KeyboardType
import androidx.compose.ui.unit.dp
import androidx.hilt.navigation.compose.hiltViewModel
import androidx.navigation.NavController

@SuppressLint("StateFlowValueCalledInComposition")
@OptIn(ExperimentalMaterial3Api::class)
@Composable
fun CreatePostScreen(
    navController: NavController,
    viewModel: CreatePostViewModel = hiltViewModel()
) {
    val uiState by viewModel.uiState.collectAsState()
    val scrollState = rememberScrollState()
    val shape = MaterialTheme.shapes.medium
    val colors = MaterialTheme.colorScheme

    LaunchedEffect(uiState.isSuccess) {
        if (uiState.isSuccess) {
            navController.popBackStack()
        }
    }

    Scaffold(
        topBar = {
            CenterAlignedTopAppBar(
                title = {
                    Text(
                        "Create New Event",
                        style = MaterialTheme.typography.headlineSmall
                    )
                },
                navigationIcon = {
                    IconButton(onClick = { navController.popBackStack() }) {
                        Icon(
                            Icons.Default.ArrowBack,
                            contentDescription = "Back",
                            tint = colors.onSurface
                        )
                    }
                },
                colors = TopAppBarDefaults.centerAlignedTopAppBarColors(
                    containerColor = colors.surfaceColorAtElevation(3.dp)
                )
            )
        }
    ) { padding ->
        Column(
            modifier = Modifier
                .padding(padding)
                .fillMaxSize()
                .verticalScroll(scrollState)
        ) {
            Column(
                modifier = Modifier
                    .padding(horizontal = 16.dp, vertical = 8.dp)
            ) {
                // Event Details Section
                Text(
                    text = "Event Details",
                    style = MaterialTheme.typography.titleMedium,
                    color = colors.primary,
                    modifier = Modifier.padding(bottom = 8.dp)
                )

                OutlinedTextField(
                    value = uiState.title,
                    onValueChange = viewModel::updateTitle,
                    label = { Text("Title*") },
                    modifier = Modifier.fillMaxWidth(),
                    singleLine = true,
                    shape = shape,
                    colors = OutlinedTextFieldDefaults.colors(
                        focusedBorderColor = colors.primary,
                        unfocusedBorderColor = colors.outline
                    )
                )

                Spacer(modifier = Modifier.height(12.dp))

                OutlinedTextField(
                    value = uiState.subtitle,
                    onValueChange = viewModel::updateSubtitle,
                    label = { Text("Subtitle*") },
                    modifier = Modifier.fillMaxWidth(),
                    singleLine = true,
                    shape = shape
                )

                Spacer(modifier = Modifier.height(12.dp))

                OutlinedTextField(
                    value = uiState.category,
                    onValueChange = viewModel::updateCategory,
                    label = { Text("Category*") },
                    modifier = Modifier.fillMaxWidth(),
                    singleLine = true,
                    shape = shape
                )

                Spacer(modifier = Modifier.height(12.dp))

                Row(horizontalArrangement = Arrangement.spacedBy(12.dp)) {
                    OutlinedTextField(
                        value = uiState.date,
                        onValueChange = viewModel::updateDate,
                        label = { Text("Date*") },
                        modifier = Modifier.weight(1f),
                        placeholder = { Text("YYYY-MM-DD") },
                        singleLine = true,
                        keyboardOptions = KeyboardOptions(keyboardType = KeyboardType.Number),
                        shape = shape
                    )

                    OutlinedTextField(
                        value = uiState.time,
                        onValueChange = viewModel::updateTime,
                        label = { Text("Time*") },
                        modifier = Modifier.weight(1f),
                        placeholder = { Text("HH:MM") },
                        singleLine = true,
                        keyboardOptions = KeyboardOptions(keyboardType = KeyboardType.Number),
                        shape = shape
                    )
                }

                Spacer(modifier = Modifier.height(12.dp))

                OutlinedTextField(
                    value = uiState.location,
                    onValueChange = viewModel::updateLocation,
                    label = { Text("Location*") },
                    modifier = Modifier.fillMaxWidth(),
                    singleLine = true,
                    shape = shape
                )

                Spacer(modifier = Modifier.height(12.dp))

                OutlinedTextField(
                    value = uiState.spotsLeft,
                    onValueChange = viewModel::updateSpotsLeft,
                    label = { Text("Available Spots*") },
                    modifier = Modifier.fillMaxWidth(),
                    singleLine = true,
                    keyboardOptions = KeyboardOptions(keyboardType = KeyboardType.Number),
                    shape = shape
                )

                Spacer(modifier = Modifier.height(12.dp))

                OutlinedTextField(
                    value = uiState.image,
                    onValueChange = viewModel::updateImage,
                    label = { Text("Image URL") },
                    modifier = Modifier.fillMaxWidth(),
                    singleLine = true,
                    shape = shape
                )

                Spacer(modifier = Modifier.height(12.dp))

                OutlinedTextField(
                    value = uiState.description,
                    onValueChange = viewModel::updateDescription,
                    label = { Text("Description*") },
                    modifier = Modifier.fillMaxWidth(),
                    minLines = 4,
                    shape = shape
                )

                Spacer(modifier = Modifier.height(12.dp))

                OutlinedTextField(
                    value = uiState.requirements.joinToString(","),
                    onValueChange = { viewModel.updateRequirements(it.split(",")) },
                    label = { Text("Requirements (comma separated)") },
                    modifier = Modifier.fillMaxWidth(),
                    shape = shape
                )

                Spacer(modifier = Modifier.height(24.dp))

                // Contact Information Section
                Text(
                    text = "Contact Information",
                    style = MaterialTheme.typography.titleMedium,
                    color = colors.primary,
                    modifier = Modifier.padding(bottom = 8.dp)
                )

                OutlinedTextField(
                    value = uiState.contactPhone,
                    onValueChange = viewModel::updateContactPhone,
                    label = { Text("Contact Phone*") },
                    modifier = Modifier.fillMaxWidth(),
                    singleLine = true,
                    keyboardOptions = KeyboardOptions(keyboardType = KeyboardType.Phone),
                    shape = shape
                )

                Spacer(modifier = Modifier.height(12.dp))

                OutlinedTextField(
                    value = uiState.contactEmail,
                    onValueChange = viewModel::updateContactEmail,
                    label = { Text("Contact Email*") },
                    modifier = Modifier.fillMaxWidth(),
                    singleLine = true,
                    keyboardOptions = KeyboardOptions(keyboardType = KeyboardType.Email),
                    shape = shape
                )

                Spacer(modifier = Modifier.height(12.dp))

                OutlinedTextField(
                    value = uiState.contactTelegram,
                    onValueChange = viewModel::updateContactTelegram,
                    label = { Text("Contact Telegram") },
                    modifier = Modifier.fillMaxWidth(),
                    singleLine = true,
                    shape = shape
                )

                Spacer(modifier = Modifier.height(24.dp))

                Button(
                    onClick = viewModel::createEvent,
                    modifier = Modifier
                        .fillMaxWidth()
                        .height(52.dp),
                    enabled = !uiState.isLoading &&
                            uiState.title.isNotEmpty() &&
                            uiState.subtitle.isNotEmpty() &&
                            uiState.category.isNotEmpty() &&
                            uiState.date.isNotEmpty() &&
                            uiState.time.isNotEmpty() &&
                            uiState.location.isNotEmpty() &&
                            uiState.spotsLeft.isNotEmpty() &&
                            uiState.description.isNotEmpty() &&
                            uiState.contactPhone.isNotEmpty() &&
                            uiState.contactEmail.isNotEmpty(),
                    shape = MaterialTheme.shapes.large,
                    colors = ButtonDefaults.buttonColors(
                        containerColor = colors.primary,
                        contentColor = colors.onPrimary,
                        disabledContainerColor = colors.primary.copy(alpha = 0.5f),
                        disabledContentColor = colors.onPrimary.copy(alpha = 0.5f)
                    )
                ) {
                    if (uiState.isLoading) {
                        CircularProgressIndicator(
                            color = colors.onPrimary,
                            strokeWidth = 2.dp,
                            modifier = Modifier.size(20.dp)
                        )
                    } else {
                        Text(
                            "Create Event",
                            style = MaterialTheme.typography.labelLarge
                        )
                    }
                }

                uiState.error?.let { error ->
                    Spacer(modifier = Modifier.height(12.dp))
                    Text(
                        text = error,
                        color = colors.error,
                        style = MaterialTheme.typography.bodySmall,
                        modifier = Modifier.padding(horizontal = 4.dp)
                    )
                }

                Spacer(modifier = Modifier.height(16.dp))
            }
        }
    }
}