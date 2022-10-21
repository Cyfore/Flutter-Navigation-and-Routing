import 'package:flutter/material.dart';
import 'package:navigation_routing_system/utils/navigate/go_to_view.dart';

import '../../utils/navigate/push_N_W_Extract.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: {
        ExtractArgumentsScreen.routeName: (context) => const ExtractArgumentsScreen(),
        '/deneme2': (context) => const Deneme2(),
      },
      // Provide a function to handle named routes.
      // Use this function to identify the named
      // route being pushed, and create the correct
      // Screen.
      onGenerateRoute: (settings) {
        // If you push the PassArguments route
        if (settings.name == PassArgumentsScreen.routeName) {
          // Cast the arguments to the correct
          // type: ScreenArguments.
          final args = settings.arguments as ScreenArguments;

          // Then, extract the required data from
          // the arguments and pass the data to the
          // correct screen.
          return MaterialPageRoute(
            builder: (context) {
              return PassArgumentsScreen(
                title: args.title,
                message: args.message,
                imagesInfo: args.imagesInfo,
              );
            },
          );
        }

        if (settings.name == '/deneme') {
          return MaterialPageRoute(
            builder: (context) => const Deneme(),
          );
        }
        // The code only supports
        // PassArgumentsScreen.routeName right now.
        // Other values need to be implemented if we
        // add them. The assertion here will help remind
        // us of that higher up in the call stack, since
        // this assertion would otherwise fire somewhere
        // in the framework.
        assert(false, 'Need to implement ${settings.name}');
        return null;
      },
      title: 'Navigation with Arguments',
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});
  final title = 'Extract Arguments Screen';
  final message = 'This message is extracted in the build method.';
  @override
  Widget build(BuildContext context) {
    final imageInfo = ImageModul().paintingMap;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Screen'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // A button that navigates to a named route.
            // The named route extracts the arguments
            // by itself.
            ElevatedButton(
              onPressed: () {
                // When the user taps the button,
                // navigate to a named route and
                // provide the arguments as an optional
                // parameter.
                push_N_W_Extract(context, title, message, imageInfo);
              },
              child: const Text('Navigate to screen that extracts arguments'),
            ),
            // A button that navigates to a named route.
            // For this route, extract the arguments in
            // the onGenerateRoute function and pass them
            // to the screen.
            ElevatedButton(
              onPressed: () {
                // When the user taps the button, navigate
                // to a named route and provide the arguments
                // as an optional parameter.
                push_N_W_Extract(
                  context,
                  'Accept Arguments Screen',
                  'This message is extracted in the onGenerateRoute '
                      'function.',
                  imageInfo,
                );
              },
              child: const Text('Navigate to a named that accepts arguments'),
            ),
          ],
        ),
      ),
    );
  }
}

// A Widget that extracts the necessary arguments from
// the ModalRoute.
class ExtractArgumentsScreen extends StatelessWidget {
  const ExtractArgumentsScreen({super.key});

  static const routeName = '/extractArguments';

  @override
  Widget build(BuildContext context) {
    // Extract the arguments from the current ModalRoute
    // settings and cast them as ScreenArguments.
    final args = ModalRoute.of(context)!.settings.arguments as ScreenArguments;

    return Scaffold(
      appBar: AppBar(
        title: InkWell(
            onTap: () {
              Navigator.pushNamed(context, '/deneme');
            },
            child: Text(args.title)),
      ),
      body: Center(
        child: Column(
          children: [
            GestureDetector(onTap: () => Navigator.pushNamed(context, '/deneme2'), child: Text(args.message)),
            const Expanded(
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: MyPageView(),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class MyPageView extends StatelessWidget {
  const MyPageView({super.key});

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as ScreenArguments;
    final List<Map> imageInfos = args.imagesInfo;
    return SizedBox(
      height: 300,
      width: 300,
      child: PageView.builder(
        itemCount: args.imagesInfo.length,
        itemBuilder: (context, index) {
          return InkWell(
              onTap: () {
                goToView(context, MangaDetail(imageInfos: imageInfos[index]));
              },
              child: Image.asset(args.imagesInfo[index]['image']));
        },
      ),
    );
  }
}

// A Widget that accepts the necessary arguments via the
// constructor.
class PassArgumentsScreen extends StatelessWidget {
  static const routeName = '/passArguments';

  final String title;
  final String message;
  final List<Map> imagesInfo;

  // This Widget accepts the arguments as constructor
  // parameters. It does not extract the arguments from
  // the ModalRoute.
  //
  // The arguments are extracted by the onGenerateRoute
  // function provided to the MaterialApp widget.
  const PassArgumentsScreen({
    super.key,
    required this.title,
    required this.message,
    required this.imagesInfo,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('title'),
      ),
      body: Center(
        child: Column(
          children: [
            Text(message),
          ],
        ),
      ),
    );
  }
}

// You can pass any object to the arguments parameter.
// In this example, create a class that contains both
// a customizable title and message.
class ScreenArguments {
  final String title;
  final String message;
  final List<Map> imagesInfo;
  ScreenArguments(this.title, this.message, this.imagesInfo);
}

class ImageModul {
  List<Map> paintingMap = [
    {
      'image': 'assets/pic6.jpg',
      'name': 'Acrylic Wall',
    },
    {
      'image': 'assets/pic2.jpg',
      'name': 'Starry Yellow',
    },
    {
      'image': 'assets/pic3.jpg',
      'name': 'Snow pastures',
    },
    {
      'image': 'assets/pic4.jpg',
      'name': 'Paints',
    },
    {
      'image': 'assets/pic5.jpg',
      'name': 'Bright Light',
    },
    {
      'image': 'assets/pic7.jpg',
      'name': '3D Art',
    },
  ];
}

class MangaDetail extends StatelessWidget {
  const MangaDetail({super.key, required this.imageInfos});
  final Map imageInfos;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SizedBox(
          height: 300,
          width: 300,
          child: Image.asset(imageInfos['image']),
        ),
      ),
    );
  }
}

class Deneme extends StatelessWidget {
  const Deneme({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Container(
          color: Colors.white,
          child: GestureDetector(onTap: () => Navigator.pop(context), child: const Text('pop1!!')),
        ),
      ),
    );
  }
}

class Deneme2 extends StatelessWidget {
  const Deneme2({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Container(
          color: Colors.white,
          child: GestureDetector(onTap: () => Navigator.pop(context), child: const Text('deneme pop2')),
        ),
      ),
    );
  }
}