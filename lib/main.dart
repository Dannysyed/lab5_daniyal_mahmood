import 'package:flutter/material.dart';
import 'package:lab5_daniyal_mahmood/pet.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Pet Adoption lab5',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Pet Adoption Home '),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({required this.title, super.key});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage>
    with SingleTickerProviderStateMixin {
  final List<Pet> _pets = [
    Pet(
        name: 'Daniyal',
        breed: 'BullDog',
        description: 'A Family dog which helps to be secured',
        photo: 'assets/pet1.jpg',
        availableForAdoption: true),
    Pet(
        name: 'Thomas',
        breed: 'Labrador',
        description: 'A great family dog, loves to play and sniff around.',
        photo: 'assets/pet2.jpg',
        availableForAdoption: false),
    Pet(
        name: 'Tony',
        breed: 'German Shepherd',
        description:
            'A highly intelligent and trainable breed with nose sense.',
        photo: 'assets/pet3.jpg',
        availableForAdoption: true),
    Pet(
        name: 'Tiger',
        breed: 'Pug',
        description: 'A curious and friendly little explorer dog for family.',
        photo: 'assets/pet4.jpg',
        availableForAdoption: true),
    Pet(
        name: 'Pugie',
        breed: 'Bulldog',
        description: 'A King and courageous breed with a distinctive look.',
        photo: 'assets/pet5.jpg',
        availableForAdoption: true),
  ];
  //using AnimationController here
  late AnimationController _controller;
  Animation<double> _animation = const AlwaysStoppedAnimation<double>(1.0);

  @override
  void initState() {
    //used for onetime initializations , setting up animation controllers
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..forward();
    _animation = CurvedAnimation(
        parent: _controller,
        curve: Curves
            .easeIn); // Animation1 for home screen appearance is used here
  }

  @override
  void dispose() {
    //  removeing the state object  from the widget tree permanently
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: FadeTransition(
        opacity: _animation, // Fade in animation2 for home screen
        child: ListView.builder(
          itemCount: _pets.length,
          itemBuilder: (context, index) {
            return ScaleTransition(
              scale: _animation, // Scale animation3 for list items
              child: Card(
                child: ListTile(
                  leading: Hero(
                    tag: _pets[index].name,
                    child: Image.asset(
                      // Rendering of the images as per index
                      _pets[index].photo,
                      width: 50,
                      height: 50,
                    ),
                  ),
                  title: Text(_pets[index].name),
                  onTap: () {
                    Navigator.push(
                      //using the navigation to shift to petDetails screen with index
                      context,
                      MaterialPageRoute(
                        builder: (context) => PetDetails(pet: _pets[index]),
                      ),
                    );
                  },
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class PetDetails extends StatefulWidget {
  final Pet pet;

  const PetDetails({required this.pet, super.key});

  @override
  State<PetDetails> createState() => _PetDetailsState();
}

class _PetDetailsState extends State<PetDetails>
    with SingleTickerProviderStateMixin {
  late AnimationController _textController;
  late Animation<Offset> _textAnimation;

  @override
  void initState() {
    super.initState();
    _textController = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    );
    _textAnimation = Tween<Offset>(
      begin: const Offset(1.0, 0.0),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _textController,
      curve: Curves.easeInOut,
    ));
    _textController.forward();
  }

  @override
  void dispose() {
    _textController.dispose(); // using state dispose to dispose text after ui
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.pet.name) //using Name of pet as title,
          ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Hero(
              tag: widget.pet.name,
              child: RotationTransition(
                turns: const AlwaysStoppedAnimation(
                    45 / 360), // Rotation animation4 for pet image
                child: Image.asset(
                  widget.pet.photo,
                  width: 300,
                  height: 300,
                ),
              ),
            ),
            SlideTransition(
              position: _textAnimation, // Slide in animation5 for text
              child: Column(
                children: [
                  const SizedBox(
                    height: 30,
                  ), // used sized box here to give some distance between image and description
                  Text(widget.pet.breed),
                  Text(widget.pet.description),
                  Text(widget.pet.availableForAdoption
                      ? 'Available for Adoption'
                      : 'Not Available for Adoption'), //Checking for boolen as per pet availabliity
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
