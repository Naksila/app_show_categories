import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class CardList extends StatelessWidget {
  final title;
  final description;
  final id;
  const CardList(
      {super.key, this.id, required this.title, required this.description});

  @override
  Widget build(BuildContext context) {
    return Row(
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
    );
  }
}

// class CardList extends StatefulWidget {
//   final title;
//   final description;
//   final id;
//   final onPressed;
//   const CardList(
//       {super.key,
//       this.id,
//       required this.title,
//       required this.description,
//       this.onPressed});

//   @override
//   State<CardList> createState() => _CardListState();
// }

// class _CardListState extends State<CardList> {
//   @override
//   Widget build(BuildContext context) {
//     return Slidable(
//         endActionPane: ActionPane(
//           motion: const ScrollMotion(),
//           children: [
//             SlidableAction(
//               onPressed: widget.onPressed,
//                (context) {
//               //   print(widget.id);
//               // },
//               backgroundColor: const Color(0xFFFE4A49),
//               foregroundColor: Colors.white,
//               icon: Icons.delete,
//               label: 'Delete',
//             ),
//           ],
//         ),
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             const CircleAvatar(
//               radius: 30,
//               backgroundColor: Color.fromARGB(76, 155, 190, 255),
//               child: Icon(
//                 Icons.food_bank_rounded,
//                 color: Colors.black,
//                 size: 30,
//               ),
//             ),
//             SizedBox(
//               width: MediaQuery.of(context).size.width * 0.5,
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     '${widget.id}',
//                     maxLines: 1,
//                     overflow: TextOverflow.ellipsis,
//                     style: const TextStyle(
//                       fontSize: 22,
//                       fontWeight: FontWeight.w700,
//                       color: Color.fromARGB(255, 51, 51, 51),
//                     ),
//                   ),
//                   Text(
//                     '${widget.title}',
//                     maxLines: 1,
//                     overflow: TextOverflow.ellipsis,
//                     style: const TextStyle(
//                       fontSize: 22,
//                       fontWeight: FontWeight.w700,
//                       color: Color.fromARGB(255, 51, 51, 51),
//                     ),
//                   ),
//                   Text(
//                     '${widget.description}',
//                     maxLines: 2,
//                     overflow: TextOverflow.ellipsis,
//                     style: const TextStyle(
//                       fontSize: 22,
//                       fontWeight: FontWeight.w500,
//                       color: Color.fromARGB(255, 149, 149, 149),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//             IconButton(
//                 onPressed: () {
//                   print(widget.id);
//                 },
//                 icon: const Icon(Icons.more_vert))
//           ],
//         ));
//   }
// }
