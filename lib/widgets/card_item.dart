import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class CardItem extends StatelessWidget {
  final title;
  final description;
  final id;
  const CardItem(
      {super.key, this.id, required this.title, required this.description});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const CircleAvatar(
            radius: 30,
            backgroundColor: Color.fromARGB(76, 155, 190, 255),
            child: Icon(
              Icons.food_bank_rounded,
              color: Colors.black,
              size: 30,
            ),
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.5,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Text(
                //   '$id',
                //   maxLines: 1,
                //   overflow: TextOverflow.ellipsis,
                //   style: const TextStyle(
                //     fontSize: 22,
                //     fontWeight: FontWeight.w700,
                //     color: Color.fromARGB(255, 51, 51, 51),
                //   ),
                // ),
                Text(
                  '$title',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                    color: Color.fromARGB(255, 51, 51, 51),
                  ),
                ),
                Text(
                  '$description',
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w500,
                    color: Color.fromARGB(255, 149, 149, 149),
                  ),
                ),
              ],
            ),
          ),
          IconButton(
              onPressed: () {
                print(id);
              },
              icon: const Icon(Icons.more_vert))
        ],
      ),
    );
  }
}
