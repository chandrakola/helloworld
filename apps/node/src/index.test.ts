import request from 'supertest';
import express from 'express';

const app = express();
app.get('/', (req, res) => {
    res.send('Hello World from Node with TypeScript!');
});

describe('GET /', () => {
    it('responds with Hello World', async () => {
        const response = await request(app).get('/');
        expect(response.status).toBe(200);
        expect(response.text).toBe('Hello World from Node with TypeScript!');
    });
});
