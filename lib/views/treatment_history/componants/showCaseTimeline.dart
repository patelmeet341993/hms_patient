import 'package:flutter/material.dart';
import 'package:hms_models/hms_models.dart';
import 'package:timeline_tile/timeline_tile.dart';

class ShowcaseTimelineTile extends StatelessWidget {
  ShowcaseTimelineTile({required this.visitModel});
  VisitModel visitModel;
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF004E92),
            Color(0xFF000428),
          ],
        ),
      ),
      child: SafeArea(
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: Center(
            child: Column(
              children: <Widget>[
                const SizedBox(height: 16),
                const Text(
                  'TimelineTile Showcase',
                  style: TextStyle(
                    fontSize: 32,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 16),
                Expanded(
                  child: ListView.builder(
                    itemCount: visitModel.treatmentActivity.length,
                    itemBuilder: (BuildContext context, int index) {
                      final example = visitModel.treatmentActivity[index];

                      return TimelineTile(
                        alignment: TimelineAlign.manual,
                        lineXY: 0.1,
                        isFirst: index == 0,
                        isLast: index == visitModel.treatmentActivity.length - 1,
                        indicatorStyle: IndicatorStyle(
                          width: 40,
                          height: 40,
                          indicator: IndicatorExample(number: '${index + 1}'),
                          drawGap: true,
                        ),
                        beforeLineStyle: LineStyle(
                          color: Colors.white.withOpacity(0.2),
                        ),
                        endChild: GestureDetector(
                          child: RowExample( treatmentActivityModel: example,),
                          onTap: () {
                            // Navigator.push(
                            //   context,
                            //   MaterialPageRoute<ShowcaseTimeline>(
                            //     builder: (_) =>
                            //         ShowcaseTimeline(example: example),
                            //   ),
                            // );
                          },
                        ),
                      );
                    },
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class IndicatorExample extends StatelessWidget {
  const IndicatorExample({Key? key, required this.number}) : super(key: key);

  final String number;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.fromBorderSide(
          BorderSide(
            color: Colors.grey.withOpacity(0.2),
            width: 4,
          ),
        ),
      ),
      child: Center(
        child: Text(
          number,
          style: const TextStyle(fontSize: 14),
        ),
      ),
    );
  }
}

class RowExample extends StatelessWidget {
  RowExample({Key? key, required this.treatmentActivityModel}) : super(key: key);

  TreatmentActivityModel treatmentActivityModel;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Row(
        children: <Widget>[
          Expanded(
            child: Text(
              treatmentActivityModel.treatmentActivityStatus,
            ),
          ),
          const Icon(
            Icons.navigate_next,
            color: Colors.black,
            size: 26,
          ),
        ],
      ),
    );
  }
}