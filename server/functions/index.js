/* eslint-disable */
const functions = require("firebase-functions");
//// All available logging functions
//const {
//  log,
//  info,
//  debug,
//  warn,
//  error,
//  write,
//} = require("firebase-functions/logger");
const stripe = require("stripe")(functions.config().stripe.testkey);

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
/* eslint-disable */