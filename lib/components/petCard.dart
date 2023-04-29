// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';

class PetCardWidget extends StatelessWidget {
  final String imageUrl;
  final String petName;
  final String breed;
  final String region;
  final String ownerName;
  final String phoneOwner;
  final String id;
  final Function onDeletePressed;
  final Function onActivateDiactivatePressed;
  final Function onApprovePressed;
  final Function onDisApprovePressed;
  final bool isActive;
  final bool isAdopted;

  final String status;

  const PetCardWidget({
    Key? key,
    required this.imageUrl,
    required this.petName,
    required this.breed,
    required this.region,
    required this.ownerName,
    required this.phoneOwner,
    required this.id,
    required this.onDeletePressed,
    required this.onActivateDiactivatePressed,
    required this.onApprovePressed,
    required this.status,
    required this.onDisApprovePressed,
    required this.isActive,
    required this.isAdopted,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            // Pet Image
            ClipRRect(
              borderRadius: BorderRadius.circular(8.0),
              child: Image.network(
                imageUrl,
                height: 140,
                width: 260,
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(width: 16.0),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Pet Name
                  Row(
                    children: [
                      Icon(
                        Icons.pets,
                        color: Colors.deepPurple,
                      ),
                      SizedBox(width: 8.0),
                      Text(
                        petName,
                        style: TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 4.0),
                  // Breed
                  Row(
                    children: [
                      Icon(Icons.category, color: Colors.deepPurple),
                      SizedBox(width: 8.0),
                      Text(breed),
                    ],
                  ),
                  SizedBox(height: 4.0),
                  // Region
                  Row(
                    children: [
                      Icon(Icons.location_on, color: Colors.deepPurple),
                      SizedBox(width: 8.0),
                      Text(region),
                    ],
                  ),
                  SizedBox(height: 4.0),
                  // Owner Name
                  Row(
                    children: [
                      Icon(Icons.person, color: Colors.deepPurple),
                      SizedBox(width: 8.0),
                      Text(ownerName),
                    ],
                  ),
                  SizedBox(height: 4.0),
                  // Phone Owner
                  Row(
                    children: [
                      Icon(Icons.phone, color: Colors.deepPurple),
                      SizedBox(width: 8.0),
                      Text(phoneOwner),
                    ],
                  ),
                  SizedBox(height: 4.0),
                  // Pet ID
                  Row(
                    children: [
                      Icon(Icons.label, color: Colors.deepPurple),
                      SizedBox(width: 8.0),
                      Text(id),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(width: 16.0),
            // Buttons

            status == "waiting"
                ? Column(
                    children: [
                      IconButton(
                        icon: Icon(Icons.thumb_up, color: Colors.green),
                        onPressed: () => onApprovePressed(),
                      ),
                      IconButton(
                        icon: Icon(Icons.thumb_down, color: Colors.red),
                        onPressed: () => onDisApprovePressed(),
                      ),
                    ],
                  )
                : isAdopted && isActive == false
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(
                            "Adopted",
                            style: TextStyle(color: Colors.deepPurple),
                          ),
                          Icon(
                            Icons.check_circle,
                            color: Colors.deepPurple,
                          ),
                        ],
                      )
                    : Column(
                        children: [
                          TextButton.icon(
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                  title: isActive
                                      ? Text('Diactivate Post')
                                      : Text('Activate'),
                                  content: isActive
                                      ? Text(
                                          'Are you sure you want to Diactivate this Post ?')
                                      : Text(
                                          'Are you sure you want to Acivate this Post'),
                                  actions: <Widget>[
                                    TextButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      child: Text('No'),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      child: Text('Yes'),
                                    ),
                                  ],
                                ),
                              );
                            },
                            icon: Icon(
                              isActive
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                              color: isActive ? Colors.green : Colors.red,
                            ),
                            label: isActive
                                ? Text("Diactivate Post")
                                : Text("Activate Post"),
                          ),
                        ],
                      ),
          ],
        ),
      ),
    );
  }
}
