/* eslint-disable */
const functions = require("firebase-functions");
const stripe = require("stripe")(functions.config().stripe.testkey);
const admin = require('firebase-admin');
const moment = require('moment');
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
            return {
                clientSecret: intent.client_secret,
                status: intent.status,
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
          body: `Congratulations ! ${artistName} has sent you a booking request from ${from} to ${to} for ${totalPrice} £. `,
          content_available : 'true',
          priority : 'high',
        },
        data: {
              messageID: 'messageID',
              messageTimestamp: '12341232132',
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

/* eslint-disable */