/* eslint-disable */
const functions = require("firebase-functions");
const log = require("firebase-functions/logger");
const stripe = require("stripe")(functions.config().stripe.testkey);

const calculateOrderAmount = (items) => {
    prices = [];
    catalog = [
        {"id": 0, "price": 100},
    ];

    items.forEach((item) => {
        price = catalog.find((x) => x.id == item.id).price;
        prices.push(price);
    });

    return parseInt(prices.map((a) => parseInt(a)).reduce((a, b) => a+b) * 100);
};

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
            log("Payment Succeeded");
            log("client "+intent.client_secret);
            log("status "+intent.status);
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
    log("1 body "+req.body);

    const {paymentMethodId, items, currency, useStripeSdk} = req.body;

    const orderAmount = calculateOrderAmount(items);
    log("3 paymentMethodId "+paymentMethodId+" stripe is "+stripe);

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
        return res.sendStatus(400);
    } catch (e) {
        return res.send({error: e.message});
    }
});

exports.StripePayEndpointIntentId = functions.https.onRequest(async (req, res) => {
    const {paymentIntentId} = req.body;
    try {
        if (paymentIntentId ) {
            const intent = await stripe.paymentIntents.confirm(paymentIntentId);
            return res.send(generatedResponse(intent));
        }
        return res.sendStatus(400);
    } catch (e) {
        return res.send({error: e.message});
    }
});
/* eslint-disable */