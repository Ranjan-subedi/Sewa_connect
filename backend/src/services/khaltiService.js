const axios = require('axios');

const KHALTI_BASE_URL = process.env.KHALTI_ENV === 'production'
    ? 'https://khalti.com/api/v2'
    : 'https://dev.khalti.com/api/v2';

const getKhaltiHeaders = () => ({
    Authorization: `Key ${process.env.KHALTI_SECRET_KEY}`,
    'Content-Type': 'application/json',
});

const initiatePayment = async ({
    amount,
    purchaseOrderId,
    purchaseOrderName,
    customerInfo,
}) => {
    const payload = {
        return_url: process.env.KHALTI_RETURN_URL || 'https://test.com/payment/success',
        website_url: process.env.KHALTI_WEBSITE_URL || 'https://sewaconnect.com',
        amount: Math.round(amount * 100),
        purchase_order_id: purchaseOrderId,
        purchase_order_name: purchaseOrderName,
        customer_info: {
            name: customerInfo.name,
            email: customerInfo.email,
            phone: customerInfo.phone || '9800000000',
        },
    };

    const response = await axios.post(
        `${KHALTI_BASE_URL}/epayment/initiate/`,
        payload,
        { headers: getKhaltiHeaders() },
    );

    return response.data;
};

const verifyPayment = async (pidx) => {
    const response = await axios.post(
        `${KHALTI_BASE_URL}/epayment/lookup/`,
        { pidx },
        { headers: getKhaltiHeaders() },
    );

    return response.data;
};

module.exports = { initiatePayment, verifyPayment };
