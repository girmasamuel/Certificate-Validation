import express from 'express';
import multer  from 'multer';
import { create } from 'ipfs-http-client';

const app = express();
const port = 3000;

// Set up IPFS client with Project ID and Project Secret
const ipfs = create({
    host: 'ipfs.infura.io',
    port: 5001,
    protocol: 'https',
    headers: {
        authorization: 'Basic ' + Buffer.from('cirtificate-validadtion:cHduzJ6gCGdTlP6cfnJHtPs0MV62WeAZBKCcTf1ZGyB6uxqJjrLTNQ').toString('base64')
    }
});

// Set up multer for file uploads
const storage = multer.memoryStorage();
const upload = multer({ storage });

app.post('/upload', upload.single('file'), async (req, res) => {
    try {
        const added = await ipfs.add(req.file.buffer);
        res.json({ ipfsHash: added.path });
    } catch (error) {
        console.error('Error uploading file:', error);
        res.status(500).send('Error uploading file.');
    }
});

app.listen(port, () => {
    console.log(`Server running at http://localhost:${port}`);
});