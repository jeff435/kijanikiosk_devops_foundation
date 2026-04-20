const { processPayment } = require('../src/index');

describe('Payment Processing', () => {
    test('should process valid payment', () => {
        const result = processPayment(100, 'KES');
        expect(result.status).toBe('success');
        expect(result.amount).toBe(100);
    });

    test('should reject zero amount', () => {
        expect(() => processPayment(0, 'KES')).toThrow('Invalid payment amount');
    });
});
