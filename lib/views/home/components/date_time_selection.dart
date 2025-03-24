import 'package:flutter/material.dart';

class DateTimeSelectionWidget extends StatelessWidget {
  final VoidCallback ontap;
  final String title;
  final String time;
  final bool isTime;

  const DateTimeSelectionWidget({
    super.key,
    required this.ontap,
    required this.title,
    required this.time,
    this.isTime = false,
  });

  @override
  Widget build(BuildContext context) {
    var textTheme = Theme.of(context).textTheme;
    return GestureDetector(
      onTap: ontap,
      child: Container(
        width: double.infinity,
        margin: EdgeInsets.fromLTRB(20, 20, 20, 0),
        height: 55,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: Colors.white,
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 10),
              child: Text(
                title,
                style: textTheme.displaySmall,
              ),
            ),
            Container(
              margin: EdgeInsets.only(
                right: 10,
              ),
              width: isTime ? 150 : 80,
              height: 35,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.grey.shade100,
              ),

              // This will show Date Time as Time
              child: Center(
                child: Text(
                  time,
                  style: textTheme.titleSmall,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
