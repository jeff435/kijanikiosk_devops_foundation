// KijaniKiosk Payments Service
console.log('KijaniKiosk Payments service initialized');

function processPayment(amount, currency) {
    if (amount <= 0) {
        throw new Error('Invalid payment amount');
    }
    return {
        status: 'success',
        amount: amount,
        currency: currency,
        transactionId: Date.now().toString()
    };
}

module.exports = { processPayment };
