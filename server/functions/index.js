/* eslint-disable */
const functions = require("firebase-functions");
const stripe = require("stripe")(functions.config().stripe.testkey);
const admin = require('firebase-admin');
const moment = require('moment');
const axios = require('axios');

const { v4: uuidv4 } = require('uuid');
const { Storage } = require('@google-cloud/storage');
const path = require('path');

admin.initializeApp();
const db = admin.firestore();
const storage = new Storage();


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
      const artistName = artistDoc.data().artInfo.artistName;

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



const WISE_API_BASE_URL = 'https://api.sandbox.transferwise.tech';

// Helper function to make an authenticated request using the personal token
async function makeWiseApiRequest(endpoint, method = 'GET', data = null) {
    const personalToken = functions.config().wise.api_key;

    try {
        const response = await axios({
            url: `${WISE_API_BASE_URL}${endpoint}`,
            method: method,
            headers: {
                'Authorization': `Bearer ${personalToken}`,
                'Content-Type': 'application/json',
            },
            data: data
        });

        return response.data;
    } catch (error) {
        console.error(`Error making request to ${endpoint}:`, error.response ? error.response.data : error.message);
        throw new Error(`Failed to make API request to ${endpoint}`);
    }
}

// Helper function to upload PDF to Firebase Storage
async function uploadPDFToStorage(pdfBuffer, userId, fileName) {
    const bucketName = admin.storage().bucket().name;
    const filePath = `${userId}/receipts/${fileName}`;
    const file = storage.bucket(bucketName).file(filePath);

    await file.save(pdfBuffer, {
        contentType: 'application/pdf',
    });

    const signedUrl = await file.getSignedUrl({
        action: 'read',
        expires: '03-01-2500',
    });

    return signedUrl[0];
}


// Function to create a bank account ID for a customer
exports.createBankAccount = functions.https.onRequest(async (req, res) => {
    const userId = req.body.userId;

    if (!userId) {
        return res.status(400).send('Missing userId');
    }

    try {
        const userDoc = await admin.firestore().collection('users').doc(userId).get();
        if (!userDoc.exists) {
            return res.status(404).send('User not found');
        }

        const userData = userDoc.data();
        const payoutInfo = userData.payoutInfo;

        if (!payoutInfo) {
            return res.status(400).send('User payout info is missing');
        }

        const profiles = await makeWiseApiRequest(`/v1/profiles`);
        const profileId = profiles[0].id;

            const bankAccount = await makeWiseApiRequest(`/v1/accounts`, 'POST', {
            profile: profileId,
            accountHolderName: payoutInfo.accountHolder,
            currency: payoutInfo.currency,
            type: 'iban',
            details: {
                iban: payoutInfo.iban,
                legalType: 'PRIVATE',
            },
        });

        const bankAccountId = bankAccount.id;

        await admin.firestore().collection('users').doc(userId).update({
            'payoutInfo.bankAccountId': bankAccountId,
        });

        res.status(200).send('Bank account created successfully');
    } catch (error) {
        console.error('Error creating bank account:', error);
        res.status(500).send(error.message);
    }
});


// Function to process monthly payouts for hosts
exports.processMonthlyPayouts = functions.pubsub.schedule('0 14 * * *')
    .timeZone('Europe/Rome')
    .onRun(async (context) => {
        const usersSnapshot = await admin.firestore().collection('users')
            .where('userInfo.userType', '==', 1)
            .get();

        for (const userDoc of usersSnapshot.docs) {
            const userData = userDoc.data();
            const payoutInfo = userData.payoutInfo;
            const balance = userData.balance;

            if (!payoutInfo || !balance || parseFloat(balance) <= 0) {
                console.log(`Skipping user ${userDoc.id}: Missing payout info or zero balance`);
                continue;
            }

            try {
                const profiles = await makeWiseApiRequest(`/v1/profiles`);
                const profileId = profiles[0].id;

                let bankAccountId = payoutInfo.bankAccountId;

                if (!bankAccountId) {
                    console.log(`Creating bank account for user ${userDoc.id}`);
                    const bankAccount = await makeWiseApiRequest(`/v1/accounts`, 'POST', {
                        profile: profileId,
                        accountHolderName: payoutInfo.accountHolder,
                        currency: payoutInfo.currency,
                        type: 'iban',
                        details: {
                            iban: payoutInfo.accountNumber,
                            legalType: 'PRIVATE',
                        },
                    });
                    bankAccountId = bankAccount.id;

                    await admin.firestore().collection('users').doc(userDoc.id).update({
                        'payoutInfo.bankAccountId': bankAccountId,
                    });
                }

                const quoteData = {
                    sourceCurrency: payoutInfo.currency,
                    targetCurrency: payoutInfo.currency,
                    sourceAmount: parseFloat(balance),
                    targetAmount: null,
                    profileId: profileId,
                    targetAccount: bankAccountId,
                    preferredPayIn: "BALANCE",
                };
                const quote = await makeWiseApiRequest(`/v3/profiles/${profileId}/quotes`, 'POST', quoteData);

                const payoutRef = admin.firestore().collection('payouts').doc();
                await payoutRef.set({
                    userId: userDoc.id,
                    sourceAmount: quote.sourceAmount,
                    targetAmount: quote.paymentOptions[0].targetAmount,
                    totalFee: quote.paymentOptions[0].fee.total,
                    createdAt: admin.firestore.FieldValue.serverTimestamp(),
                    quoteId: quote.id,
                    payoutStatus: 0, // Initiated
                });

                const transferData = {
                    sourceAccount: null,
                    targetAccount: bankAccountId,
                    quoteUuid: quote.id,
                    customerTransactionId: uuidv4(),
                    details: {
                        reference: "Monthly payout",
                        transferPurpose: "verification.transfers.purpose.pay.bills",
                    },
                };
                const transfer = await makeWiseApiRequest('/v1/transfers', 'POST', transferData);

                await payoutRef.update({
                    transferId: transfer.id,
                    customerTransactionId: transfer.customerTransactionId,
                    targetCurrency: transfer.targetCurrency,
                    payoutStatus: 1, // On Progress
                });

                const fundTransfer = await makeWiseApiRequest(`/v3/profiles/${profileId}/transfers/${transfer.id}/payments`, 'POST', {
                    type: 'BALANCE',
                });

                await payoutRef.update({
                    payoutStatus: fundTransfer.status === 'COMPLETED' ? 2 : 4, // 2 for Completed, 4 for Failed
                });

                await admin.firestore().collection('users').doc(userDoc.id).update({
                    balance: "0",
                });

                console.log(`Payout processed successfully for user ${userDoc.id}`);
            } catch (error) {
                console.error(`Error processing payout for user ${userDoc.id}:`, error.message);
            }
        }
    });

//
//
//// Main function to get profile, create recipient, and send money
//exports.sendPayout = functions.https.onRequest(async (req, res) => {
//    const userId = req.body.userId;
//    console.log('userid:', userId);
//
//    if (!userId) {
//        console.log(' missing userid:', userId);
//        return res.status(400).send('Missing userId');
//    }
//
//    try {
//        // Step 1: Get the user's Firestore document
//        const userDoc = await admin.firestore().collection('users').doc(userId).get();
//        if (!userDoc.exists) {
//            console.log('userid not found:', userId);
//            return res.status(404).send('User not found');
//        }
//
//        const userData = userDoc.data();
//        const payoutInfo = userData.payoutInfo;
//        const balance = userData.balance;
//
//        if (!payoutInfo || !balance) {
//            return res.status(400).send('User payout info or balance is missing');
//        }
//
//// Step 2: Get Wise profile ID
//        const profiles = await makeWiseApiRequest(`/v1/profiles`); // Ensure you're using the correct version
//        const profileId = profiles[0].id; // Assuming we use the first profile ID
//        console.log('Wise profile ID retrieved:', profileId);
//
//        // Step 3: Check if the user already has a bank account ID
//        let bankAccountId;
//        if (payoutInfo.bankAccountId) {
//            console.log('Bank account ID already exists for user:', userId);
//            // Use the existing bank account ID
//            bankAccountId = payoutInfo.bankAccountId;
//            console.log('Using existing bank account ID:', bankAccountId);
//        } else {
//            console.log('No bank account ID found for user:', userId);
//            // Create a new recipient account if no bank account ID exists
//            console.log('Creating new bank account for user:', userId);
//            const bankAccount = await makeWiseApiRequest(`/v1/accounts`, 'POST', {
//                profile: profileId, // Use the first profile ID
//                accountHolderName: payoutInfo.accountHolder,
//                currency: payoutInfo.currency,
//                type: 'iban',
//                details: {
//                    iban: payoutInfo.accountNumber,
//                    legalType: 'PRIVATE', // or 'BUSINESS'
//                },
//            });
//
//            bankAccountId = bankAccount.id;
//
//            // Store the new bank account ID in the user's Firestore document
//            await admin.firestore().collection('users').doc(userId).update({
//                'payoutInfo.bankAccountId': bankAccountId,
//            });
//            console.log('Stored new bank account ID in Firestore for user:', userId);
//        }
//
//
//                console.log(' quote:', userId);
//
//
//        // Step 4: Create a quote
//        const quoteData = {
//            sourceCurrency: "EUR",
//            targetCurrency: "EUR",
//            sourceAmount: parseFloat(balance),
//            targetAmount: null,
//            profileId: profileId, // store to db
//            targetAccount: bankAccountId, // Now using the bank account ID we ensured exists
//            preferredPayIn: "BALANCE",
//        };
//        const quote = await makeWiseApiRequest(`/v3/profiles/${profileId}/quotes`, 'POST', quoteData);
//
//        console.log(' quote id :', quote.id);
//
//        // Save relevant information from the quote in Firestore
//        const payoutRef = db.collection('payouts').doc();
//        await payoutRef.set({
//            userId: userId,
//            sourceAmount: quote.sourceAmount,
//            targetAmount: quote.paymentOptions[0].targetAmount,
//            totalFee: quote.paymentOptions[0].fee.total,
//            createdAt: admin.firestore.FieldValue.serverTimestamp(),
//            quoteId: quote.id,
//            payoutStatus: 0, // Initiated
//        });
//
//                console.log(' stored in payout collection id :', quote.id);
//
//
//        // Step 5: Create a transfer
//        const transferData = {
//            sourceAccount: null,
//            targetAccount: bankAccountId,
//            quoteUuid: quote.id,
//            customerTransactionId: uuidv4(),
//            details: {
//                reference: "to my friend",
//                transferPurpose: "verification.transfers.purpose.pay.bills"
//            }
//        };
//        const transfer = await makeWiseApiRequest('/v1/transfers', 'POST', transferData);
//
//                console.log('transfer done :', transfer.id);
//
//        // Update the payout status in Firestore
//        await payoutRef.update({
//            transferId: transfer.id,
//            customerTransactionId: transfer.customerTransactionId,
//            payoutStatus: 1, // On Progress
//        });
//
//                        console.log('updated  payout :', transfer.id);
//
//
//        // Step 6: Fund the transfer
//        const fundTransfer = await makeWiseApiRequest(`/v3/profiles/${profileId}/transfers/${transfer.id}/payments`, 'POST', {
//            type: 'BALANCE',
//        });
//                                console.log('funded  payout :', transfer.id);
//
//
//        // Update the payout status in Firestore based on the transfer status
//        await payoutRef.update({
//            payoutStatus: fundTransfer.status === 'COMPLETED' ? 2 : 4, // 2 for Completed, 4 for Failed
//        });
//
//              console.log('payout completed  payout :', transfer.id);
//
//
//           //This needs to be done on a later stage because the invoice is not yet available
////
////        // Step 7: Retrieve the receipt PDF
////        const receiptResponse = await axios.get(`${WISE_API_BASE_URL}/v1/transfers/${transfer.id}/receipt.pdf`, {
////            headers: {
////                'Authorization': `Bearer ${functions.config().wise.api_key}`,
////            }
////        });
////
////                      console.log('invoice  payout :', transfer.id);
////
////
////        // Step 8: Upload the receipt PDF to Firebase Storage
////        const receiptFileName = `wise_invoice_${new Date().toISOString().slice(0, 10)}.pdf`;
////        const receiptUrl = await uploadPDFToStorage(receiptResponse.data, userId, receiptFileName);
////
////                      console.log('invoice  stored :', transfer.id);
////
////
////        // Step 9: Update the payout object in Firestore with the receipt URL
////        await payoutRef.update({
////            receiptUrl: receiptUrl,
////        });
////
////                      console.log('payout updated  stored :', transfer.id);
//
//        res.status(200).send('Payout processed successfully');
//
//    } catch (error) {
//        console.error('Error processing payout:', error);
//        res.status(500).send(error.message);
//    }
//});


/* eslint-disable */