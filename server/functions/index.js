/* eslint-disable */
const functions = require("firebase-functions");
const stripe = require("stripe")(functions.config().stripe.testkey);
const admin = require('firebase-admin');
const moment = require('moment');
const axios = require('axios');

admin.initializeApp();

const generatedResponse = function(intent) {
    switch (intent.status) {
        case "requires_action":
            return {
                clientSecret: intent.client_secret,
                requiresAction: true,
                status: intent.status,
            };
        case "requires_payment_method":
            return {
                "error": "Your card was denied. Please provide a different payment method.",
            };
        case "succeeded":
            console.log("Payment Succeeded");
            console.log("client "+intent.client_secret);
            console.log("status "+intent.status);
            console.log("payment id "+intent.id);
            return {
                clientSecret: intent.client_secret,
                status: intent.status,
                paymentIntentId: intent.id
            };
    }
    return {
        "error": "Your card was denied. Please provide a different payment method.",
    };
};

exports.StripePayEndpointMethodId = functions.https.onRequest(async (req, res) => {
    console.log("1 body "+req.body);

    const {paymentMethodId, grandTotal, currency, useStripeSdk} = req.body;

    const orderAmount = grandTotal;
    console.log("3 paymentMethodId "+paymentMethodId+" stripe is "+stripe);

    try {
        if (paymentMethodId) {
            // Create paymentIntent
            const params = {
                amount: orderAmount,
                confirm: true,
                confirmation_method: "manual",
                currency: currency,
                payment_method: paymentMethodId,
                use_stripe_sdk: useStripeSdk,
            };
            const intent = await stripe.paymentIntents.create(params);

            return res.send(generatedResponse(intent));
        }
        return res.sendStatus(500);
    } catch (e) {
        return res.send({error: e.message});
    }
});

exports.StripePayEndpointIntentId = functions.https.onRequest(async (req, res) => {
    console.log("1 intent body "+req.body);

    const {paymentIntentId} = req.body;
    try {
        if (paymentIntentId ) {
            console.log("2 paymentIntentId "+paymentIntentId);

            const intent = await stripe.paymentIntents.confirm(paymentIntentId);
            console.log("3 intent "+intent);

            return res.send(generatedResponse(intent));
        }
        return res.sendStatus(400);
    } catch (e) {
        return res.send({error: e.message});
    }
});

exports.processRefund = functions.firestore.document('refunds/{refundId}')
  .onCreate(async (snapshot, context) => {
    try {
      console.log('Refund started successfully:', snapshot.data());

      const paymentIntentId = snapshot.data().paymentIntentId;
      const artistId = snapshot.data().artistId;
      const hostId = snapshot.data().hostId;

      // Use the chargeId to initiate the refund in Stripe
      const refund = await stripe.refunds.create({
        payment_intent: paymentIntentId,
      });

      // Update the Firestore document to store refund information or status
      await snapshot.ref.update({
        refundStatus: 1, // or 'failed' based on the refund result
        refundId: refund.id, // Store the refund ID for reference
      });

      console.log('Refund processed successfully:', refund);

      // Fetch the artist's last name from the "users" collection
      const hostDoc = await admin.firestore().collection('users').doc(hostId).get();
      const hostName = hostDoc.data().userInfo.name;

      // Fetch the host's FCM token from the "fcmTokens" collection
      const artisTokenDoc = await admin.firestore().collection('fcmTokens').doc(artistId).get();
      const artistFcmToken = artisTokenDoc.data().token;

            // Prepare the push notification payload
            const payload = {
              notification: {
                title: 'Your booking request was refunded',
                body: `Unfortunately ${hostName} has rejected your booking request. We refunded your booking.`,
                content_available : 'true',
                priority : 'high',
              },
              data: {
                    title: 'Your booking request was refunded',
                    body: `Unfortunately ${hostName} has rejected your booking request. We refunded your booking.`,
                    click_action: 'FLUTTER_NOTIFICATION_CLICK',
                    screen: "homePage",//or secondScreen or thirdScreen
                },
            };

            console.log('Token. '+ artistFcmToken+' payload '+payload);


            // Send the push notification to the host using FCM
            await admin.messaging().sendToDevice(artistFcmToken, payload);

            console.log('Refund Push notification sent successfully.');

      return null;
    } catch (error) {
      console.error('Error processing refund:', error);

      // Update the Firestore document with an error status
      await snapshot.ref.update({
        refundStatus: 2,
        error: error.message,
      });

      return null;
    }
  });



exports.notifyOnAccept = functions.firestore.document('accepted/{acceptedId}')
  .onCreate(async (snapshot, context) => {
    try {
      console.log('Push notification for accepted started successfully:', snapshot.data());

      const paymentIntentId = snapshot.data().paymentIntentId;
      const artistId = snapshot.data().artistId;
      const hostId = snapshot.data().hostId;


      // Fetch the artist's last name from the "users" collection
      const hostDoc = await admin.firestore().collection('users').doc(hostId).get();
      const hostName = hostDoc.data().userInfo.name;

      // Fetch the host's FCM token from the "fcmTokens" collection
      const artisTokenDoc = await admin.firestore().collection('fcmTokens').doc(artistId).get();
      const artistFcmToken = artisTokenDoc.data().token;

            // Prepare the push notification payload
            const payload = {
              notification: {
                title: 'Your booking request has been accepted!',
                body: `Congratulations! ${hostName} accepted your booking request! Get ready for your exhibition!`,
                content_available : 'true',
                priority : 'high',
              },
              data: {
                    title: 'Your booking request has been accepted!',
                    body: `Congratulations! ${hostName} accepted your booking request! Get ready for your exhibition!`,
                    click_action: 'FLUTTER_NOTIFICATION_CLICK',
                    screen: "homePage",//or secondScreen or thirdScreen
                  },
            };

            console.log('Token. '+ artistFcmToken+' payload '+payload);


            // Send the push notification to the host using FCM
            await admin.messaging().sendToDevice(artistFcmToken, payload);

            console.log('Accepted Push notification sent successfully.');

      return null;
    } catch (error) {
      console.error('Error processing refund:', error);

      // Update the Firestore document with an error status
      await snapshot.ref.update({
        refundStatus: 2,
        error: error.message,
      });

      return null;
    }
  });

exports.sendBookingNotification = functions.firestore
  .document('bookings/{bookingId}')
  .onCreate(async (snapshot, context) => {
    try {
      // Get the booking data
      const bookingData = snapshot.data();
      const artistId = bookingData.artistId;
      const hostId = bookingData.hostId;

      // Fetch the artist's last name from the "users" collection
      const artistDoc = await admin.firestore().collection('users').doc(artistId).get();
      const artistName = artistDoc.data().userInfo.name;

      const totalPrice = bookingData.totalPrice;
      const currencyCode = bookingData.currencyCode;

      // Format the Date to "DD-MM-YYYY" format
      const from = moment(bookingData.from.toDate()).format('DD-MM-YYYY');
      const to = moment(bookingData.to.toDate()).format('DD-MM-YYYY');

      // Fetch the host's FCM token from the "fcmTokens" collection
      const hostTokenDoc = await admin.firestore().collection('fcmTokens').doc(hostId).get();
      const hostFcmToken = hostTokenDoc.data().token;

      // Prepare the push notification payload
      const payload = {
        notification: {
          title: 'New Booking Request',
          body: `Congratulations ! ${artistName} has sent you a booking request from ${from} to ${to} for ${totalPrice} ${currencyCode}. `,
          content_available : 'true',
          priority : 'high',
        },
        data: {
              title: 'New Booking Request',
              body: `Congratulations ! ${artistName} has sent you a booking request from ${from} to ${to} for ${totalPrice} ${currencyCode}. `,
              click_action: 'FLUTTER_NOTIFICATION_CLICK',
              screen: "bookingRequests",//or secondScreen or thirdScreen
            },
      };

      console.log('Token. '+ hostFcmToken+' payload '+payload);


      // Send the push notification to the host using FCM
      await admin.messaging().sendToDevice(hostFcmToken, payload);

      console.log('Push notification sent successfully.');
    } catch (error) {
      console.error('Error sending push notification:', error);
    }
  });

exports.markPendingBookingsAsCancelled = functions.pubsub
    .schedule('35 20 * * *') // Set the schedule to run at 5:30 AM every day
    .timeZone('Europe/London').onRun(async (context) => {
  const db = admin.firestore();
  try {
    const pendingBookingsSnapshot = await db.collection('bookings').where('bookingStatus', '==', 0).get();

    for (const bookingDoc of pendingBookingsSnapshot.docs) {
      const bookingData = bookingDoc.data();
      const bookingTime = bookingData.bookingTime.toDate();

      // Calculate the time difference in hours
      const timeDifference = (new Date() - bookingTime) / (1000 * 60 * 60);

      if (timeDifference > 24 && !bookingData.cancelled) {
        // Update the booking status to cancelled
        await bookingDoc.ref.update({ bookingStatus: 3 });

        console.log(`Booking ${bookingDoc.id} marked as cancelled.`);


         // Update the host's bookings array
//          const hostRef = db.collection('users').doc(bookingData.hostId);
//          const hostData = await hostRef.get();
//          const existingBookings = hostData.data().bookings || [];
//
//          const updatedBookings = existingBookings.map(booking => {
//            if (booking.bookingId === bookingDoc.id) {
//             console.log(`Booking ${bookingDoc.id} marked as cancelled. Corresponding host bookings updated.`);
//
//              return { ...booking, bookingStatus: 3 };
//            }
//            return booking;
//          });
//
//          await hostRef.update({ bookings: updatedBookings });
//
//          // Update the artist's bookings array
//          const artistRef = db.collection('users').doc(bookingData.artistId);
//          const artistData = await artistRef.get();
//          const artistExistingBookings = artistData.data().bookings || [];
//
//          const artistUpdatedBookings = artistExistingBookings.map(booking => {
//            if (booking.bookingId === bookingDoc.id) {
//              console.log(`Booking ${bookingDoc.id} marked as cancelled. Corresponding artist bookings updated.`);
//
//              return { ...booking, bookingStatus: 3 };
//            }
//            return booking;
//          });
//
//          await artistRef.update({ bookings: artistUpdatedBookings });


        console.log(`Booking ${bookingDoc.id} marked as cancelled.`);

         const refund = {
                    bookingId: bookingDoc.id,
                    paymentIntentId: bookingData.paymentIntentId,
                    refundStatus: 0,
                    refundTimestamp: admin.firestore.FieldValue.serverTimestamp(),
                    artistId: bookingData.artistId,
                    hostId: bookingData.hostId,
         };

          await db.collection('refunds').doc(bookingDoc.id).set(refund);

          console.log(`Refund added to the "refunds" collection for booking ${bookingDoc.id}.`);

      }
    }

    console.log('Cancellation check completed.');
  } catch (error) {
    console.error('Error marking bookings as cancelled:', error);
  }
});






//exports.scheduledPaypalPayout = functions.pubsub
//  .schedule('36 16 * * *') // Set the schedule to run at 5:30 AM every day
//  .timeZone('Europe/London') // Set your timezone
//  .onRun(async (context) => {
//    try {
//      const usersSnapshot = await admin.firestore().collection('users').get();
//
//      const promises = [];
//
//      usersSnapshot.forEach((userDoc) => {
//        const user = userDoc.data();
//        const userId = userDoc.id;
//        const currencyCode = user.userInfo.address.currencyCode;
//
//        // Check if user has a PayPal account
//        if (user.bookingSettings && user.bookingSettings.paypalAccount) {
//          const amount = parseFloat(user.balance || '0'); // You might need to adjust this based on your user data structure
//
//            console.log('send '+amount+' '+currencyCode+' to '+user.bookingSettings.paypalAccount);
//
//          promises.push(sendPaypalPayout(userId, user.bookingSettings.paypalAccount, amount, currencyCode ));
//        }
//      });
//
//      // Wait for all promises to resolve
//      await Promise.all(promises);
//
//      console.log('Scheduled PayPal Payouts completed.');
//      return null;
//    } catch (error) {
//      console.error('Scheduled PayPal Payouts Error:', error);
//      return null;
//    }
//  });
//
//async function sendPaypalPayout(userId, receiverEmail, amount, currencyCode) {
//  try {
//    // Fetch PayPal auth token
//    const paypalAuthToken = await getPaypalAuthToken();
//
//    // Make a request to the PayPal Payouts API
//    const response = await axios.post(
//      'https://api-m.sandbox.paypal.com/v1/payments/payouts',
//      {
//        sender_batch_header: {
//                  sender_batch_id: `batch_${userId}_${Date.now()}`,
//                  email_subject: 'You have a new payout from ArtB2B!',
//                  email_message: 'You received a new payout. Thanks for using our service! ArtB2B'
//        },
//        items: [
//          {
//            recipient_type: 'EMAIL',
//            amount: {
//              value: amount.toFixed(2),
//              currency: currencyCode,
//            },
//            receiver: receiverEmail,
//            note: 'Payment from ArtB2B',
//            sender_item_id: `item_${userId}_1`,
//          },
//        ],
//      },
//      {
//        headers: {
//          'Content-Type': 'application/json',
//          Authorization: `Bearer ${paypalAuthToken}`,
//        },
//      }
//    );
//
//    // Log the PayPal Payout response
//    console.log('PayPal Payout Response:', response.data);
//
//    // Initialize the status
//    let status = 'initialized';
//
//    // Check if the PayPal payout was successful (HTTP status code 2xx)
//    if (response.status >= 200 && response.status < 300) {
//      // Insert entry in payouts collection
//      await admin.firestore().collection('payouts').add({
//        userId: userId,
//        amount: amount,
//        currencyCode: currencyCode,
//        timestamp: admin.firestore.FieldValue.serverTimestamp(),
//        status: '0',
//      });
//
//      // Update user's balance to 0
//      await admin.firestore().collection('users').doc(userId).update({
//        balance: '0',
//      });
//
//      console.log(`Payout for user ${userId} completed. Balance updated to 0.`);
//    } else {
//    await admin.firestore().collection('payouts').add({
//            userId: userId,
//            amount: amount,
//            currencyCode: currencyCode,
//            timestamp: admin.firestore.FieldValue.serverTimestamp(),
//            status: '1',
//          });
//      console.error(`PayPal Payout for user ${userId} failed. Status Code: ${response.status}`);
//    }
//  } catch (error) {
//  await admin.firestore().collection('payouts').add({
//          userId: userId,
//          amount: amount,
//          currencyCode: currencyCode,
//          timestamp: admin.firestore.FieldValue.serverTimestamp(),
//          status: '1',
//        });
//    console.error(`PayPal Payout for user ${userId} Error:`, error.response ? error.response.data : error.message);
//  }
//}
//
//async function getPaypalAuthToken() {
//    const clientId = 'Ad4ikZGk8HA0wYDuRGD4XfmjEfXW2trGLo7ZiFzYYt7YhwRQjpoMu8QsoJ0EM7oLYEcjsp7Tgo8vCTR-';
//    const clientSecret = 'EGx7cWt3CJkgM5Lv06mzej5Dg43BwHSCTxLnurH_VU1FhgKJ8oCFKVV_PKmlg2SNdc_jrF4iHi-MG1co';
//
//    // Encode credentials using Buffer
//    const credentials = Buffer.from(`${clientId}:${clientSecret}`).toString('base64');
//
//
//  try {
//    const response = await axios.post(
//      'https://api-m.sandbox.paypal.com/v1/oauth2/token',
//      'grant_type=client_credentials',
//      {
//        headers: {
//          'Content-Type': 'application/x-www-form-urlencoded',
//          'Authorization': `Basic ${credentials}`,
//        },
//      }
//    );
//
//    return response.data.access_token;
//  } catch (error) {
//    console.error('PayPal Auth Token Error:', error.response ? error.response.data : error.message);
//    throw error;
//  }
//}



/* eslint-disable */