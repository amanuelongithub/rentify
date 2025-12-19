import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/state_manager.dart';
import 'package:yegnabet/controller/home_controller.dart';
import 'package:yegnabet/utils/globals.dart';
import 'package:yegnabet/views/widgets/custom_divider.dart';
import 'package:yegnabet/views/widgets/selectable_chip.dart';
import 'package:yegnabet/views/widgets/text_minimizer.dart';
// import 'package:yegnabet/views/widgets/custom_divider.dart';

class DetailsPage extends StatelessWidget {
  const DetailsPage({super.key});
  static String route = '/details-page';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GetBuilder<HomeController>(
        builder: (ctr) {
          String? cover = ctr.detailModel?.coverImage;
          String? title = ctr.detailModel?.title ?? ctr.detailModel?.location?.name;
          String? location = ctr.detailModel?.location?.name;
          String? city = ctr.detailModel?.location?.city;
          String? area = ctr.detailModel?.location?.area;
          String? country = ctr.detailModel?.location?.country;
          String? status = ctr.detailModel!.forRent! ? "For Rent" : "For Sell";
          String? price = ctr.detailModel?.prices?.price ?? ctr.detailModel?.location?.name;
          String? type = ctr.detailModel!.type;
          int? size = ctr.detailModel!.squareMeter;
          int? bedroom = ctr.detailModel?.bedRoom;
          String? garages = ctr.detailModel!.garages;
          int? bathroom = ctr.detailModel!.bathRoom;
          String? condition = ctr.detailModel!.condition;
          List<String> features = ctr.detailModel!.features ?? [];

          return LayoutBuilder(
            builder: (_, constraints) {
              final headerHeight = constraints.maxHeight * .50; // 55 % of screen

              return NestedScrollView(
                headerSliverBuilder: (_, innerBoxIsScrolled) => [
                  SliverAppBar(
                    expandedHeight: headerHeight,
                    pinned: true,
                    floating: false,
                    stretch: true,
                    elevation: 0,
                    flexibleSpace: FlexibleSpaceBar(
                      background: Hero(
                        tag: '${ctr.detailModel!.id} img',
                        child: Stack(
                          fit: StackFit.expand,
                          children: [
                            CachedNetworkImage(imageUrl: cover!, width: double.infinity, fit: BoxFit.cover),
                            Positioned(
                              bottom: 10,
                              left: 0,
                              right: 0,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: List.generate(
                                  ctr.detailModel!.images!.length,
                                  (index) => Padding(
                                    padding: const EdgeInsets.only(left: 6.0),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(3),
                                      child: Container(
                                        width: 40,
                                        height: 40,
                                        decoration: BoxDecoration(borderRadius: BorderRadius.circular(5)),
                                        child: CachedNetworkImage(imageUrl: ctr.detailModel!.images![index], fit: BoxFit.cover),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
                body: SingleChildScrollView(
                  physics: const ClampingScrollPhysics(),
                  child: Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(horizontal: hPadding, vertical: 15),
                    decoration: BoxDecoration(
                      color: Theme.of(context).scaffoldBackgroundColor,
                      borderRadius: BorderRadius.vertical(top: Radius.circular(kRadius)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          title ?? "",
                          maxLines: 3,
                          style: const TextStyle(fontSize: xxlfont, fontWeight: FontWeight.bold, letterSpacing: 0),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          'Updated on October 25, 2024 at 12:50 pm',
                          style: const TextStyle(fontSize: sfont, color: Colors.grey, letterSpacing: 0),
                        ),
                        // const SizedBox(height: 10),
                        // Padding(
                        //   padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        //   child: RichText(
                        //     textAlign: TextAlign.center,
                        //     text: TextSpan(
                        //       style: TextStyle(color: getTheme(context).onPrimary, fontSize: sfont),
                        //       children: [
                        //         TextSpan(text: "● $location  "),
                        //         TextSpan(text: "● $type "),
                        //         TextSpan(text: "● $bedroom bed room  "),
                        //         TextSpan(text: "● $garages garages "),
                        //       ],
                        //     ),
                        //   ),
                        // ),
                        const SizedBox(height: 16),
                        Container(
                          width: double.infinity,
                          height: 52,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            gradient: LinearGradient(
                              colors: [getTheme(context).secondary.withValues(alpha: 0.3), Colors.white.withValues(alpha: 0.1)],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Column(
                                  mainAxisAlignment: .spaceAround,
                                  children: [
                                    Text("5.0", textAlign: TextAlign.center),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: _buildStars(
                                        5,
                                        color: getTheme(context).onPrimary, // your colour
                                        size: 15, // your size
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(vertical: 15),
                                child: Container(
                                  width: 1,
                                  height: double.infinity,
                                  color: getTheme(context).onPrimary.withValues(alpha: 0.6),
                                ),
                              ),
                              Expanded(
                                child: Column(
                                  mainAxisAlignment: .spaceAround,
                                  children: [
                                    Text(
                                      status,
                                      style: TextStyle(
                                        fontSize: mfont,
                                        fontWeight: FontWeight.w500,
                                        color: getTheme(context).secondary,
                                        letterSpacing: 0,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(vertical: 15),
                                child: Container(
                                  width: 1,
                                  height: double.infinity,
                                  color: getTheme(context).onPrimary.withValues(alpha: 0.6),
                                ),
                              ),
                              Expanded(
                                child: Column(
                                  mainAxisAlignment: .spaceAround,
                                  children: [
                                    Text(
                                      "35",
                                      style: const TextStyle(fontSize: mfont, fontWeight: FontWeight.w500, letterSpacing: 0),
                                    ),
                                    Text("Users review"),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 15),
                        CustomDivider(),
                        Column(
                          crossAxisAlignment: .start,
                          spacing: 5,
                          children: [
                            Text(
                              'About this house',
                              style: const TextStyle(fontSize: mfont, fontWeight: FontWeight.bold, letterSpacing: 0),
                            ),
                            TextMinimizer(
                              text:
                                  'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Donec lectus dolor, blandit sit amet fermentum ac, ullamcorper bibendum nisl. Pellentesque habitant morbi tristique senectus et netus et malesuada fames ac turpis egestas. Sed quis urna eu arcu convallis sagittis mollis et ligula. Integer vulputate sed ligula a ornare. Phasellus viverra ultrices mi at finibus. Pellentesque id sodales est. In hac habitasse platea dictumst. Vivamus vehicula mauris nunc, at pretium ante aliquam vel. Duis et condimentum tortor, et hendrerit ligula. Quisque augue mauris, convallis non ligula vitae, porttitor rhoncus enim. Vestibulum erat ante, vehicula vitae blandit sed, aliquam nec massa. Nunc bibendum leo leo, at ornare lectus ornare quis. Nam aliquam dui nec urna sagittis posuere. Donec elit nibh, imperdiet eu neque elementum, porta tincidunt tellus. Nulla facilisi. Vestibulum efficitur sed mauris eget mattis. Nullam pharetra nisl ex, at iaculis enim ultrices et. Pellentesque scelerisque venenatis lorem vel convallis. Quisque malesuada lobortis velit sit amet porta. Pellentesque lacinia orci ut vestibulum semper. Integer vitae efficitur quam. Quisque quis tristique nisi. Morbi scelerisque ex non felis mollis, in iaculis enim dictum. Cras mollis tincidunt pulvinar. Quisque vitae venenatis eros, non iaculis nisl. Vivamus dui nibh, dignissim ac lectus id, fringilla mollis lacus. Sed a dolor mauris. Aenean vitae massa purus. Suspendisse id tortor nulla. Cras quis sollicitudin augue. Vivamus eget odio sit amet ex lacinia porttitor. Duis ullamcorper velit nibh, eu consectetur est venenatis vel. Vivamus rutrum volutpat convallis. Integer a elit eget ipsum suscipit interdum. Vestibulum nec congue felis, eu suscipit quam. Quisque feugiat eleifend convallis. Sed dictum purus ac faucibus scelerisque. Vivamus faucibus gravida massa nec tempor. Aliquam pellentesque faucibus elementum',
                              maxLines: 5,
                            ),
                          ],
                        ),
                        const SizedBox(height: 15),
                        Column(
                          crossAxisAlignment: .start,
                          children: [
                            Text(
                              'Details',
                              style: const TextStyle(fontSize: mfont, fontWeight: FontWeight.bold, letterSpacing: 0),
                            ),
                            const SizedBox(height: 10),
                            Container(
                              padding: EdgeInsets.all(hPadding - 5),
                              decoration: BoxDecoration(gradient: gradient(context), borderRadius: BorderRadius.circular(kRadius)),
                              child: Column(
                                // spacing: 25/,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [Text("Price"), Text(formatNumberWithCommas(price!))],
                                  ),
                                  Padding(padding: const EdgeInsets.symmetric(vertical: 5.0), child: CustomDivider()),

                                  Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Text("Property Type"), Text(type!)]),
                                  Padding(padding: const EdgeInsets.symmetric(vertical: 5.0), child: CustomDivider()),
                                  Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Text("Property Status"), Text(status)]),
                                  Padding(padding: const EdgeInsets.symmetric(vertical: 5.0), child: CustomDivider()),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text("Property Size"),
                                      RichText(
                                        text: TextSpan(
                                          children: [
                                            TextSpan(text: "$size m"),
                                            TextSpan(
                                              text: "²",
                                              style: TextStyle(fontFeatures: [FontFeature.superscripts()]),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  Padding(padding: const EdgeInsets.symmetric(vertical: 5.0), child: CustomDivider()),
                                  Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Text("Bedrooms"), Text("$bedroom")]),
                                  Padding(padding: const EdgeInsets.symmetric(vertical: 5.0), child: CustomDivider()),
                                  Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Text("Condition"), Text(condition!)]),
                                  Padding(padding: const EdgeInsets.symmetric(vertical: 5.0), child: CustomDivider()),
                                  Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Text("Garages"), Text("$garages")]),
                                  Padding(padding: const EdgeInsets.symmetric(vertical: 5.0), child: CustomDivider()),
                                  Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Text("Bathrooms"), Text('$bathroom')]),
                                ],
                              ),
                            ),
                            const SizedBox(height: 10),
                            CustomDivider(),
                            const SizedBox(height: 10),
                            Text(
                              'Features',
                              style: const TextStyle(fontSize: mfont, fontWeight: FontWeight.bold, letterSpacing: 0),
                            ),
                            const SizedBox(height: 20),
                            Wrap(
                              spacing: 10,
                              runSpacing: 10,
                              children: features.map((feature) {
                                return GestureDetector(
                                  child: selectableChip(label: feature, icon: Icons.check, isSelected: false),
                                );
                              }).toList(),
                            ),
                            const SizedBox(height: 10),
                            Text(
                              'Address',
                              style: const TextStyle(fontSize: mfont, fontWeight: FontWeight.bold, letterSpacing: 0),
                            ),
                            const SizedBox(height: 20),
                            Container(
                              width: double.infinity,
                              padding: EdgeInsets.all(hPadding),
                              decoration: BoxDecoration(
                                gradient: gradient(context),
                                borderRadius: BorderRadius.circular(kRadius),
                                border: Border.all(color: getTheme(context).primary.withValues(alpha: 0.3)),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                spacing: 15,
                                children: [
                                  Row(
                                    children: [
                                      Text("Address: "),
                                      Expanded(child: Text(location!)),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Text("City: "),
                                      Expanded(child: Text("$city")),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Text("Area: "),
                                      Expanded(child: Text("$area")),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Text("Country: "),
                                      Expanded(child: Text("$country")),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  List<Widget> _buildStars(double rate, {required Color color, required double size}) {
    final full = rate.floor();
    final half = (rate - full) >= 0.5;
    final empty = 5 - full - (half ? 1 : 0);

    return [
      ...List.generate(full, (_) => Icon(Icons.star, color: color, size: size)),
      if (half) Icon(Icons.star_half, color: color, size: size),
      ...List.generate(empty, (_) => Icon(Icons.star_border, color: color, size: size)),
    ];
  }
}
