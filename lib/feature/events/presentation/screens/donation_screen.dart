import 'package:donation_management/core/presentation/utils/app_router.dart';
import 'package:donation_management/core/presentation/utils/app_style.dart';
import 'package:donation_management/feature/events/data/enums/donation_type.dart';
import 'package:donation_management/feature/events/data/models/event_dto.dart';
import 'package:donation_management/feature/events/presentation/screens/add_edit_donation_screen.dart';
import 'package:donation_management/feature/events/presentation/widgets/donation_type_section.dart';
import 'package:flutter/material.dart';

class DonationScreen extends StatefulWidget {
  const DonationScreen({
    Key? key,
    required this.args,
  }) : super(key: key);

  final DonationScreenArgs args;

  @override
  State<DonationScreen> createState() => _DonationScreenState();
}

class _DonationScreenState extends State<DonationScreen> {
  bool forMaterial = false;

  void onTabTapped(int index) {
    setState(() {
      if (index == 0) {
        forMaterial = false;
      } else {
        forMaterial = true;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'Donations',
            style: AppStyle.kStyleBold.copyWith(
              fontSize: 22.0,
              color: AppStyle.kColorWhite,
            ),
          ),
          bottom: TabBar(
            onTap: onTabTapped,
            isScrollable: false,
            indicatorColor: AppStyle.kColorWhite,
            labelStyle: AppStyle.kStyleBold.copyWith(
              color: Colors.white,
            ),
            tabs: [
              Tab(text: DonationType.service.text()),
              Tab(text: DonationType.material.text()),
            ],
          ),
        ),
        body: TabBarView(
          physics: const NeverScrollableScrollPhysics(),
          children: [
            DonationTypeSection(
              eventId: widget.args.event.eventId!,
              donationType: DonationType.service,
            ),
            DonationTypeSection(
              eventId: widget.args.event.eventId!,
              donationType: DonationType.material,
            ),
          ],
        ),
        floatingActionButton: (widget.args.showAddDonation)
            ? FloatingActionButton(
                onPressed: () {
                  Navigator.pushNamed(
                    context,
                    AppRouter.addEditDonationScreen,
                    arguments: AddEditDonationScreenArgs(
                      widget.args.event.eventId!,
                      forMaterial: forMaterial,
                    ),
                  );
                },
                child: const Icon(Icons.add),
              )
            : const SizedBox.shrink(),
      ),
    );
  }
}

class DonationScreenArgs {
  final EventDto event;
  final bool showAddDonation;

  DonationScreenArgs({required this.event, this.showAddDonation = true});
}
