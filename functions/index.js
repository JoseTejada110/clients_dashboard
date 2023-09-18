/**
 * Import function triggers from their respective submodules:
 *
 * const {onCall} = require("firebase-functions/v2/https");
 * const {onDocumentWritten} = require("firebase-functions/v2/firestore");
 *
 * See a full list of supported triggers at https://firebase.google.com/docs/functions
 */

const {onCall} = require("firebase-functions/v2/https");
const logger = require("firebase-functions/logger");
const admin = require("firebase-admin");
const {initializeApp} = require("firebase-admin/app");

initializeApp();


exports.sendNotificationToTopic = onCall((data, context) => {
    const {title, message, topic} = data.data;
    const payload = {
        topic: topic,
        notification: {
            title: title,
            body: message
        }
    };

    admin.messaging().send(payload)
    .then((result) => {
        return true;
    })
    .catch((error) => {
        return false;
    });
});

exports.sendNotificationToUser = onCall((data, context) => {
    const {title, message, tokens} = data.data;
    const payload = {
        tokens: tokens,
        notification: {
            title: title,
            body: message
        }
    };

    admin.messaging().sendEachForMulticast(payload)
    .then((result) => {
        return true;
    })
    .catch((error) => {
        return false;
    });
});