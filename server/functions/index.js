/* eslint-disable */
const { onRequest } = require("firebase-functions/v2/https");
const { onDocumentCreated } = require('firebase-functions/v2/firestore');
const { onSchedule } = require('firebase-functions/v2/scheduler');
//const stripe = require("stripe")(process.env.STRIPE_TEST_KEY);
const functions = require('firebase-functions');
const stripe = require("stripe")(functions.config().stripe.testkey);
const admin = require('firebase-admin');
const moment = require('moment');
const axios = require('axios');
const { v4: uuidv4 } = require('uuid');
const { Storage } = require('@google-cloud/storage');
const { CloudTasksClient } = require('@google-cloud/tasks');
const path = require('path');

admin.initializeApp();
const db = admin.firestore();
const storage = new Storage();
const client = new CloudTasksClient();

const generatedResponse = function(intent) {
   console.log("intent " + intent.status);
   console.log("secret " + intent.client_secret);

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

exports.StripePayEndpointMethodId = onRequest(async (req, res) => {
    console.log("1 body " + req.body);
    console.log("Stripe Test Key: ", functions.config().stripe.testkey);

    const { paymentMethodId, grandTotal, currency, useStripeSdk } = req.body;

    const orderAmount = grandTotal;
    console.log("3 paymentMethodId " + paymentMethodId + " stripe is " + stripe);

    try {
        if (paymentMethodId) {
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
        return res.send({ error: e.message });
    }
});

exports.StripePayEndpointIntentId = onRequest(async (req, res) => {
    console.log("1 intent body " + req.body);

    const { paymentIntentId } = req.body;
    try {
        if (paymentIntentId) {
            console.log("2 paymentIntentId " + paymentIntentId);

            const intent = await stripe.paymentIntents.confirm(paymentIntentId);
            console.log("3 intent " + intent);

            return res.send(generatedResponse(intent));
        }
        return res.sendStatus(400);
    } catch (e) {
        return res.send({ error: e.message });
    }
});

exports.processRefund = onDocumentCreated("refunds/{refundId}", async (event) => {
    const snapshot = event.data;
    const refundData = snapshot.data();

    try {
        const paymentIntentId = refundData.paymentIntentId;
        const artistId = refundData.artistId;
        const hostId = refundData.hostId;

        const refund = await stripe.refunds.create({
            payment_intent: paymentIntentId,
        });

        await db.collection('refunds').doc(event.params.refundId).update({
            refundStatus: 1,
            refundId: refund.id,
        });

        const hostDoc = await db.collection('users').doc(hostId).get();
        const hostName = hostDoc.data().userInfo.name;

        const artistTokenDoc = await db.collection('fcmTokens').doc(artistId).get();
        const artistFcmToken = artistTokenDoc.data().token;

        const payload = {
            notification: {
                title: 'Your booking request was refunded',
                body: `Unfortunately ${hostName} has rejected your booking request. We refunded your booking.`,
            },
            data: {
                title: 'Your booking request was refunded',
                body: `Unfortunately ${hostName} has rejected your booking request. We refunded your booking.`,
            },
        };

        await admin.messaging().sendToDevice(artistFcmToken, payload);
        console.log('Refund Push notification sent successfully.');

        return null;
    } catch (error) {
        console.error('Error processing refund:', error);
        await db.collection('refunds').doc(event.params.refundId).update({
            refundStatus: 2,
            error: error.message,
        });
        return null;
    }
});

exports.markPendingBookingsAsCancelled = onSchedule({
    schedule: '00 03 * * *',
    timeZone: 'Europe/London',
    retryConfig: {
        retryCount: 3,
        minBackoffSeconds: 10,
    },
}, async (context) => {
    try {
        const pendingBookingsSnapshot = await db.collection('bookings')
            .where('bookingStatus', '==', 0)
            .get();

        console.log(`Number of pending bookings: ${pendingBookingsSnapshot.size}`);

        for (const bookingDoc of pendingBookingsSnapshot.docs) {
            const bookingData = bookingDoc.data();
            const bookingTime = bookingData.bookingTime.toDate();

            const timeDifference = (new Date() - bookingTime) / (1000 * 60 * 60);

            if (timeDifference > 48) {
                await createTask(bookingDoc.id, bookingData);
                console.log(`Task created for booking ${bookingDoc.id}`);
            }
        }

        console.log('Tasks created for all pending bookings.');
    } catch (error) {
        console.error('Error scheduling tasks for bookings:', error);
    }
});

async function createTask(bookingId, bookingData) {
    const project = 'artb2b-34af2';
    const queue = 'pendingBookings';
    const location = 'europe-central2';

    const parent = client.queuePath(project, location, queue);

    const task = {
        httpRequest: {
            httpMethod: 'POST',
            url: 'https://us-central1-artb2b-34af2.cloudfunctions.net/processPendingBooking',
            headers: {
                'Content-Type': 'application/json',
            },
            body: Buffer.from(JSON.stringify({ bookingId, bookingData })).toString('base64'),
        },
    };

    const request = {
        parent: parent,
        task: task,
    };

    await client.createTask(request);
}

exports.processPendingBooking = onRequest(async (req, res) => {
    const bookingId = req.body.bookingId;
    const bookingData = req.body.bookingData;

    try {
        await db.collection('bookings').doc(bookingId).update({ bookingStatus: 3 });

        console.log(`Booking ${bookingId} marked as cancelled.`);

        const refund = {
            bookingId: bookingId,
            paymentIntentId: bookingData.paymentIntentId,
            refundStatus: 0,
            refundTimestamp: admin.firestore.FieldValue.serverTimestamp(),
            artistId: bookingData.artistId,
            hostId: bookingData.hostId,
        };

        await db.collection('refunds').doc(bookingId).set(refund);
        console.log(`Refund added to the "refunds" collection for booking ${bookingId}.`);

        res.status(200).send('Booking processed successfully.');
    } catch (error) {
        console.error('Error processing booking:', error);
        res.status(500).send('Error processing booking: ' + error);
    }
});


// Function to process monthly payouts for hosts
exports.processMonthlyPayouts = onSchedule({
    schedule: '0 14 * * *',
    timeZone: 'Europe/Rome',
    retryConfig: {
        retryCount: 3,
        minBackoffSeconds: 10,
    },
}, async (event) => {
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


/* eslint-disable */