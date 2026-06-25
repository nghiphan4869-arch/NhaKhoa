import 'package:flutter/material.dart';

class MenuCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final Color color;
  final VoidCallback? onTap;

  const MenuCard({
    super.key,
    required this.icon,
    required this.title,
    required this.color,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,

        child: Container(
          height: 110, 
          padding: const EdgeInsets.all(14),

          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(18),
          ),

          child: Column(
            mainAxisAlignment:
                MainAxisAlignment.center,

            children: [

              Icon(
                icon,
                size: 35,
                color: Colors.black87,
              ),

              const SizedBox(height: 12),

              Expanded(
                child: Text(
                  title,
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,

                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}