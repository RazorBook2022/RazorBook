// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:razor_book/helpers/colors.dart';
import 'package:razor_book/views/barbershop_screens/notification_view.dart';

import '../view_model/bookings_view_model.dart';
import 'package:rating_dialog/rating_dialog.dart';

import 'common_widgets/pages_appbar.dart';

class ViewBookings extends StatefulWidget {
  const ViewBookings({Key? key}) : super(key: key);

  @override
  State<ViewBookings> createState() => _ViewBookingsState();
}

/*                                  
    the logic here is as follow : 
    we have four states 
    1: is ongoing 
      card  color is white, condition to make it is : is_cancelled=false + is_completed= false
      options: is to cancel it, condition should be : is_completed= false + is_cancelled= false
    2: is cancelled
      card color is : red , condition : is_cancelled == true + is_completed = false
      opitons : try to click on it , will result in an alert message , condition :is_cancelled == true + is_completed = false
    3: is completed but no review
      card color yellow, condition : is_completed = true && cancelled == false
      options: add review, condition: is_completed = true && cancelled == false 
    4: is completed with reivew is_completed = true && cancelled == true
      card color green, 
      options: none
  */

/*
  note : there might be a need to add new serivce methods to update the status of 
  the order , is complete or no+ is cancelled or not
  maybe we used the same method we had but just add a new variable to it which is -is_complete-
  
   */

class _ViewBookingsState extends State<ViewBookings> {
  @override
  Widget build(BuildContext context) {
    // locator<BookingsViewModel>().getBookings();

    // this is connecting to the view model which is provided globally through a multi-provider
    BookingsViewModel model = context.watch<BookingsViewModel>();

    // // run the get bookings method in the view model
    // model.getBookings();

    return Scaffold(
      appBar: CustomAppBar(
          bartitle: const Text(
            "Bookings",
            style: TextStyle(
              fontFamily: "MetropolisExtra",
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Helper.kTitleTextColor,
            ),
          ),
          onPressedFunctionForRightAction: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (ctx) => BarberNotificationView()));
          },
          appBarRightIcon: const Icon(
            Icons.notifications,
            color: Helper.kTitleTextColor,
          )),
      body: FutureBuilder(
          future: model.getBookings(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (snapshot.hasError) {
              return const Center(
                child: Text("Error"),
              );
            } else {
              return ListView.builder(
                itemCount: model.bookingsList?.length,
                itemBuilder: (context, index) {
                  return Card(
                    margin: const EdgeInsets.all(10),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    color: model.bookingsList![index].is_cancelled == false &&
                            model.bookingsList![index].is_completed == false
                        ? Colors.white
                        : model.bookingsList![index].is_cancelled == true &&
                                model.bookingsList![index].is_completed == false
                            ? const Color.fromARGB(255, 255, 152, 152)
                            : model.bookingsList![index].is_cancelled ==
                                        false &&
                                    model.bookingsList![index].is_completed ==
                                        true &&
                                    model.bookingsList![index].rating == 0
                                ? Colors.amberAccent[200]
                                : model.bookingsList![index].is_cancelled ==
                                            false &&
                                        model.bookingsList![index]
                                                .is_completed ==
                                            true &&
                                        model.bookingsList![index].rating != 0
                                    ? Color.fromARGB(255, 52, 205, 121)
                                    : Helper.kFABColor,
                    child: ListTile(
                      //these are the icons on the leading of the card to indicate the stauts of the booking
                      //*DON'T MAKE THEM const OTHERWISE THERE WILL BE RENDERING ERROR

                      leading: model.bookingsList![index].is_cancelled ==
                                  false &&
                              model.bookingsList![index].is_completed == false
                          ? Icon(
                              size: 40,
                              Icons.calendar_month,
                              color: Helper.kFABColor,
                            )
                          : model.bookingsList![index].is_cancelled == true &&
                                  model.bookingsList![index].is_completed ==
                                      false
                              ? Icon(
                                  size: 40,
                                  Icons.free_cancellation,
                                  color: Colors.white,
                                )
                              : model.bookingsList![index].is_cancelled ==
                                          false &&
                                      model.bookingsList![index].is_completed ==
                                          true &&
                                      model.bookingsList![index].rating == 0
                                  ? Icon(
                                      size: 40,
                                      Icons.rate_review,
                                      color: Colors.white,
                                    )
                                  : model.bookingsList![index].is_cancelled ==
                                              false &&
                                          model.bookingsList![index]
                                                  .is_completed ==
                                              true &&
                                          model.bookingsList![index].rating != 0
                                      ? Icon(
                                          size: 40,
                                          Icons.done,
                                          color: Colors.white,
                                        )
                                      : Icon(
                                          size: 40,
                                          Icons.done,
                                          color: Colors.white,
                                        ),
                      title: Text(
                          "Booking Time: ${model.bookingsList![index].time} \nBooking Date: ${model.bookingsList![index].date}"),
                      subtitle: model.bookingsList![index].rating != 0 &&
                              model.bookingsList![index].rating != null
                          ? Text(
                              "Rating: ${model.bookingsList![index].rating}/5 \nComment: ${model.bookingsList![index].comment}")
                          : Text(""),
                      trailing:
                          Text("${model.bookingsList![index].total_price}RM"),
                      enabled: true,
                      onTap: () {
                        //inside the the if conditions you must edit the
                        //boolean variables after he/she clicks on the alert button

                        if (model.bookingsList![index].is_cancelled == true &&
                            model.bookingsList![index].is_completed == false) {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: const Text("Booking was Cancelled"),
                                content: const Text(
                                    "You had cancelled your booking."),
                                actions: <Widget>[
                                  TextButton(
                                    style: TextButton.styleFrom(
                                      primary: Colors.grey,
                                    ),
                                    onPressed: () {
                                      //no need to edit any boolean variabiles here
                                      Navigator.of(context).pop();
                                    },
                                    child: const Text("Dismiss"),
                                  ),
                                ],
                              );
                            },
                          );
                        }

                        if (model.bookingsList![index].is_cancelled != true &&
                            model.bookingsList![index].is_completed != true) {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: const Text("Cancel Booking"),
                                content: const Text(
                                    "are you sure you want to cancel your ongoing booking?"),
                                actions: <Widget>[
                                  TextButton(
                                    style: TextButton.styleFrom(
                                      primary: Colors.grey,
                                    ),
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: const Text("Dismiss"),
                                  ),
                                  TextButton(
                                    style: TextButton.styleFrom(
                                      primary: Colors.red,
                                    ),
                                    child: const Text("Confirm"),
                                    onPressed: () {
                                      try {
                                        //change the vairables here since it's already rated and completed so the variables should
                                        //be ------- is_completed = false && is_canceled=true------------------
                                        //this will prevent the user from re-cancelling it again and it will show the
                                        //alert message in line 118

                                        model.cancelBooking(
                                            model.bookingsList![index].id);
                                        Navigator.of(context).pop();
                                      } catch (e) {
                                        print(e.toString());
                                      }
                                    },
                                  )
                                ],
                              );
                            },
                          );
                        }
                        //here it there should be another condition -condition inside condition- to differniate between customer and barbershop sides
                        //if he is a customer= ture then activate this condition
                        //e.g. : if user.['user-type'] == customer {then condition in line 196 is here}
                        if (model.currentUser?.user_type == "customer" &&
                            model.bookingsList![index].is_completed == true &&
                            model.bookingsList![index].is_cancelled != true &&
                            model.bookingsList![index].rating == 0) {
                          showDialog(
                            context: context,
                            barrierDismissible:
                                true, // set to false if you want to force a rating
                            builder: (BuildContext context) {
                              return RatingDialog(
                                title: const Text(
                                  'Rate you Experience',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 25,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                initialRating: 1,
                                message: const Text(
                                  'Rate about your Experince with this order',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(fontSize: 15),
                                ),
                                submitButtonText: 'Submit',
                                onSubmitted: (response) {
                                  //call the add rate function here
                                  //response.rating to access the stars
                                  //to access the comments response.comment
                                  model.rateBooking(
                                      model.bookingsList![index].b_id!,
                                      model.bookingsList![index].id!,
                                      response.rating,
                                      response.comment);

                                  //change the vairables here since it's already rated and completed so the variables should
                                  //be ------- is_completed = true && is_canceled=true------------------
                                  //this will prevent the user from re-rating the shop
                                },
                              );
                            },
                          );
                        }

                        if (model.bookingsList![index].is_completed == true &&
                            model.bookingsList![index].is_cancelled == true) {
                          showDialog(
                            context: context,
                            barrierDismissible:
                                true, // set to false if you want to force a rating
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: const Text("Order is Completed"),
                                content: const Text(
                                    "this mesage means that you attended the barbershop and got haircut"),
                                actions: <Widget>[
                                  TextButton(
                                    style: TextButton.styleFrom(
                                      primary: Colors.grey,
                                    ),
                                    onPressed: () {
                                      //no need to edit any boolean variabiles here
                                      Navigator.of(context).pop();
                                    },
                                    child: const Text("Dismiss"),
                                  ),
                                ],
                              );
                            },
                          );
                        }
                      },
                    ),
                  );
                },
              );
            }
          }),
    );
  }
}
