import express, { Request, Response } from 'express';

const app = express();
const port = 8004;

app.get('/', (req: Request, res: Response) => {
    res.send('Hello World from Node.js (Monorepo)!!!');
});

app.listen(port, () => {
    console.log(`Server running at http://localhost:${port}`);
});
