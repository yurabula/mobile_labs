import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        textTheme: const TextTheme(bodyMedium: TextStyle(fontSize: 16)),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.grey.shade100,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          labelStyle: const TextStyle(color: Colors.grey),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue.shade600,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
            textStyle: const TextStyle(fontSize: 16),
            elevation: 2,
          ),
        ),
      ),
      home: const ImageSwitcherScreen(),
    );
  }
}

class ImageSwitcherScreen extends StatefulWidget {
  const ImageSwitcherScreen({super.key});

  @override
  State<ImageSwitcherScreen> createState() => ImageSwitcherScreenState();
}

class ImageSwitcherScreenState extends State<ImageSwitcherScreen> {
  final TextEditingController controller = TextEditingController();
  final List<String> images = [
    'assets/kardashians/meme1.jpg',
    'assets/kardashians/meme2.png',
    'assets/kardashians/meme3.jpg',
    'assets/kardashians/meme4.jpeg',
  ];
  int currentImageIndex = 0;
  bool showImage = true;

  void handleSubmit() {
    if (controller.text.trim() == 'Cucumber') {
      setState(() {
        showImage = false;
      });
    }
    controller.clear();
  }

  void changeImage() {
    setState(() {
      currentImageIndex = (currentImageIndex + 1) % images.length;
      showImage = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Image Changer'),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: Colors.black87,
      ),
      backgroundColor: const Color(0xFFF5F7FA),
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 30),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  child:
                      showImage
                          ? ClipRRect(
                            key: ValueKey<int>(currentImageIndex),
                            borderRadius: BorderRadius.circular(16),
                            child: Image.asset(
                              images[currentImageIndex],
                              width: 300,
                              height: 300,
                              fit: BoxFit.cover,
                            ),
                          )
                          : const SizedBox.shrink(),
                ),
                const SizedBox(height: 30),
                TextField(
                  controller: controller,
                  decoration: const InputDecoration(
                    labelText: 'Enter "Cucumber" to remove image',
                    prefixIcon: Icon(Icons.text_fields),
                  ),
                ),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton.icon(
                      onPressed: handleSubmit,
                      icon: const Icon(Icons.send),
                      label: const Text('Submit'),
                    ),
                    const SizedBox(width: 16),
                    ElevatedButton.icon(
                      onPressed: changeImage,
                      icon: const Icon(Icons.image),
                      label: const Text('Change Image'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
