require('dotenv').config();
const express = require('express');
const bodyParser = require('body-parser');
const axios = require('axios');

const app = express();
app.use(bodyParser.json());

app.post('/alexa', async (req, res) => {
    const accessToken = req.body.context.System.user.accessToken;

    if (!accessToken) {
        return res.json({
            response: {
                outputSpeech: {
                    type: 'PlainText',
                    text: 'Please link your account to use this skill.'
                },
                shouldEndSession: true
            }
        });
    }

    try {
        const response = await axios.get(`${process.env.API_ENDPOINT}/userinfo`, {
            headers: {
                Authorization: `Bearer ${accessToken}`
            }
        });

        const userInfo = response.data;

        return res.json({
            response: {
                outputSpeech: {
                    type: 'PlainText',
                    text: `Hello, ${userInfo.name}! How can I assist you today?`
                },
                shouldEndSession: false
            }
        });
    } catch (error) {
        console.error('Error fetching user info:', error);

        return res.json({
            response: {
                outputSpeech: {
                    type: 'PlainText',
                    text: 'There was an error accessing your account information. Please try again later.'
                },
                shouldEndSession: true
            }
        });
    }
});

const PORT = process.env.PORT || 8080;
app.listen(PORT, () => {
    console.log(`Server is running on port ${PORT}`);
});
