const express = require('express');
const fetch = require('node-fetch');
const router = express.Router();

const SERVER_KEY = 'YOUR_SERVER_KEY_HERE'; // FCM server key??

const sendPushNotification = async (deviceToken, title, message) => {
    const url = 'https://fcm.googleapis.com/fcm/send';
    
    const notificationBody = {
        to: deviceToken,
        notification: {
            title: title,
            body: message,
            sound: 'default',
        },
        priority: "high",
    };

    try {
        const response = await fetch(url, {
            method: 'POST',
            headers: {
                'Authorization': `key=${SERVER_KEY}`,
                'Content-Type': 'application/json',
            },
            body: JSON.stringify(notificationBody),
        });

        if (response.ok) {
            return await response.json();
        } else {
            console.error('Error sending notification:', response.statusText);
            throw new Error('Errore sending notification');
        }
    } catch (error) {
        console.error('Errore:', error);
        throw error;
    }
};

// Endpoint per inviare notifiche
router.post('/send-notification', async (req, res) => {
    const { deviceToken, title, message } = req.body;

    if (!deviceToken || !title || !message) {
        return res.status(400).json({ error: 'Missing data' });
    }

    try {
        const result = await sendPushNotification(deviceToken, title, message);
        res.status(200).json({ success: true, result });
    } catch (error) {
        res.status(500).json({ error: 'Error sending notification', details: error.message });
    }
});

module.exports = router;
