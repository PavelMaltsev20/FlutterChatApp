const functions = require("firebase-functions");

exports.MyFunction = functions.firestore
    .document("chat/{message}")
    .onCreate((snapshot, context) => {
        console.log(snapshot.data());
    });
