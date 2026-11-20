import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/movies_provider.dart';
import '../widgets/mood_selector.dart';
import '../widgets/movie_card.dart';

class MoviesPage extends StatelessWidget {
  const MoviesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<MoviesProvider>();

    return Scaffold(
      appBar: AppBar(title: const Text('¿Qué veo este fin de semana?')),
      body: Column(
        children: [
          MoodSelector(
            selected: provider.mood,
            onSelected: provider.selectMood,
          ),
          Expanded(child: _Body(provider: provider)),
        ],
      ),
    );
  }
}

class _Body extends StatelessWidget {
  const _Body({required this.provider});

  final MoviesProvider provider;

  @override
  Widget build(BuildContext context) {
    switch (provider.status) {
      case MoviesStatus.loading:
        return const Center(child: CircularProgressIndicator());

      case MoviesStatus.error:
        return Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.error_outline, size: 48),
                const SizedBox(height: 12),
                Text(provider.errorMessage ?? '', textAlign: TextAlign.center),
                const SizedBox(height: 16),
                FilledButton(
                  onPressed: () => provider.selectMood(provider.mood),
                  child: const Text('Reintentar'),
                ),
              ],
            ),
          ),
        );

      case MoviesStatus.success:
        final featured = provider.featured;
        if (featured == null) {
          return const Center(
            child: Text('No encontramos películas para este ánimo.'),
          );
        }
        final theme = Theme.of(context);
        return ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Text('Tu película de hoy', style: theme.textTheme.titleMedium),
            const SizedBox(height: 8),
            MovieCard(movie: featured, highlight: true),
            const SizedBox(height: 8),
            FilledButton.tonalIcon(
              onPressed: provider.surpriseMe,
              icon: const Icon(Icons.casino_outlined),
              label: const Text('Sorpréndeme con otra'),
            ),
            const SizedBox(height: 24),
            Text('Más opciones', style: theme.textTheme.titleMedium),
            const SizedBox(height: 8),
            for (final movie in provider.others) MovieCard(movie: movie),
          ],
        );
    }
  }
}
