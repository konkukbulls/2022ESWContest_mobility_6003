const functions = require("firebase-functions");
const admin = require('firebase-admin');
admin.initializeApp(functions.config().firebase);


exports.helloWorld = functions.database.ref('notification/status').onUpdate(evt => {

    const payload1 = {
        notification: {
            title : 'BCCS',
            body : '주행 중 이벤트가 발생했습니다.',
            badge : '1',
            sound : 'default'
        }
    };
    
    const payload2 = {
        notification: {
            title : 'BCCS',
            body : '주차 중 이벤트가 발생했습니다.',
            badge : '1',
            sound : 'default'
        }
    };
    

    return admin.database().ref('fcm-token').once('value').then(allToken => {
        if (allToken.val() && evt.after.val() == 'drive') {
            console.log('token available');
            const token = Object.keys(allToken.val());
            return admin.messaging().sendToDevice(token, payload1);
        } 
        else if (allToken.val() && evt.after.val() == 'park') {
                    console.log('token available');
                    const token = Object.keys(allToken.val());
                    return admin.messaging().sendToDevice(token, payload2);
        } 
        else {
            console.log('No token available');
        }
    });
});