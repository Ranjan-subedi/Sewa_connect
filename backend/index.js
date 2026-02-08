const express = require('express');
const app = express();
const dotenv = require('dotenv');
dotenv.config();
const cors = require('cors');
app.use(express.json());
app.use(express.urlencoded({extended: true}));
app.use(cors());
const UserModel = require('./src/model/userSchema');

const connectDB = require('./src/model/dbmodel');
connectDB();

app.get('/', (req, res) => {
    res.send('Hello, My  Users!');
});


app.post('/addUser', async(req, res) => {
    const {email} = req.body;

    const existingUser = await UserModel.findOne({email: email});
    if (existingUser) {
         res.status(400).json({message: "User already exists"});
    }else{
        const newUser = new UserModel({
            name: req.body.name,
            email: req.body.email,
            password: req.body.password,
            phone: req.body.phone
        });

        await newUser.save().then(()=>{
            res.status(201).json({
                newUser,
                message: "User added successfully"});
        });
    }
});




const PORT = process.env.PORT || 3000;
app.listen(PORT, ()=>{
    console.log(`Server is running on port ${PORT}`);
});