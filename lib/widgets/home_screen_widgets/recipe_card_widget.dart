import 'package:flutter/material.dart';

class RecipeCard extends StatelessWidget {
  final String title;
  final String time;
  final int difficultyEstimation;
  final String mealName;
  final String imageUrl;
  final VoidCallback? onTap; // New: Add onTap callback

  const RecipeCard({
    super.key,
    required this.title,
    required this.time,
    required this.difficultyEstimation,
    required this.mealName,
    required this.imageUrl,
    this.onTap, // New: Make optional
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap, // New: Trigger navigation on tap
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
              child: imageUrl.isNotEmpty
                  ? Image.network(
                imageUrl,
                height: 120,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    height: 120,
                    color: Colors.grey[300],
                    child: const Icon(Icons.broken_image, size: 40, color: Colors.grey),
                  );
                },
              )
                  : Container(
                height: 120,
                color: Colors.grey[300],
                child: const Icon(Icons.image, size: 40, color: Colors.grey),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Icons.access_time, size: 16, color: Colors.grey),
                      const SizedBox(width: 4),
                      Text(time, style: const TextStyle(color: Colors.grey)),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Text(
                        'Difficulty',
                        style: TextStyle(color: Colors.grey, fontSize: 14),
                      ),
                      const SizedBox(width: 4),
                      ...List.generate(
                        difficultyEstimation,
                            (index) => const Icon(
                          Icons.star,
                          size: 16,
                          color: Colors.orange,
                        ),
                      ),
                      ...List.generate(
                        5 - difficultyEstimation,
                            (index) => const Icon(
                          Icons.star_border,
                          size: 16,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    mealName.toUpperCase(),
                    style: const TextStyle(color: Colors.orange, fontSize: 12, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}