@Composable
fun ExploreScreen(
    viewModel: ExploreViewModel = hiltViewModel(),
    onEventClick: (Event) -> Unit
) {
    val state by viewModel.state.collectAsState()

    when {
        state.isLoading -> CenterAlignedColumn {
            CircularProgressIndicator()
        }
        state.error != null -> CenterAlignedColumn {
            Text("Error loading events: ${state.error}")
            Button(onClick = { viewModel.loadEvents() }) {
                Text("Retry")
            }
        }
        else -> ExploreContent(
            events = state.events,
            onEventClick = onEventClick
        )
    }
}

@Composable
private fun ExploreContent(
    events: List<Event>,
    onEventClick: (Event) -> Unit
) {
    Column(modifier = Modifier.fillMaxSize()) {
        Text(
            text = "Explore",
            style = MaterialTheme.typography.h4,
            modifier = Modifier.padding(16.dp)
        )

        LazyColumn {
            items(events) { event ->
                EventCard(event = event, onClick = { onEventClick(event) })
            }
        }
    }
}

@Composable
fun EventCard(event: Event, onClick: () -> Unit) {
    Card(
        modifier = Modifier
            .fillMaxWidth()
            .padding(8.dp)
            .clickable(onClick = onClick),
        elevation = 4.dp
    ) {
        Column {
            AsyncImage(
                model = event.image,
                contentDescription = event.title,
                modifier = Modifier
                    .fillMaxWidth()
                    .height(200.dp),
                contentScale = ContentScale.Crop
            )

            Column(modifier = Modifier.padding(16.dp)) {
                Text(
                    text = event.title,
                    style = MaterialTheme.typography.h5
                )
                Text(
                    text = event.subtitle,
                    style = MaterialTheme.typography.body1,
                    color = MaterialTheme.colors.onSurface.copy(alpha = 0.6f)
                )

                Spacer(modifier = Modifier.height(8.dp))

                Row(verticalAlignment = Alignment.CenterVertically) {
                    Icon(Icons.Default.LocationOn, contentDescription = "Location")
                    Text(
                        text = event.location,
                        modifier = Modifier.padding(start = 4.dp)
                    )
                }

                Row(verticalAlignment = Alignment.CenterVertically) {
                    Icon(Icons.Default.DateRange, contentDescription = "Date")
                    Text(
                        text = "${event.date} • ${event.time}",
                        modifier = Modifier.padding(start = 4.dp)
                    )
                }

                Spacer(modifier = Modifier.height(8.dp))

                Text(
                    text = "${event.spotsLeft} spots left",
                    color = if (event.spotsLeft > 0) Color.Green else Color.Red
                )

                Button(
                    onClick = onClick,
                    modifier = Modifier.align(Alignment.End)
                ) {
                    Text("View Details")
                }
            }
        }
    }
}