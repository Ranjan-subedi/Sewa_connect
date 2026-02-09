const express = require('express');
const app = express();

const dotenv = require('dotenv');
dotenv.config();

const cors = require('cors');
app.use(cors());

app.use(express.json());
app.use(express.urlencoded({extended: true}));

const UserModel = require('./src/model/userSchema');
const connectDB = require('./src/model/dbmodel');
connectDB();

app.get('/', (req, res) => {
    res.send('Hello, My  Users!');
});


app.post('/registerUser', async(req, res) => {
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

app.post('/loginUser', async (req, res) => {
    try {
        const {email, password} = req.body;
        
        const existingUser = await UserModel.findOne({email: email});

        if (!existingUser) {
            return res.status(400).json({
                message : "User not found"
            });
        }
        if (existingUser.password !== password) {
            return res.status(401).json({
                message : "invalid password"
            });
        }
        if (existingUser.password == password && existingUser.email == email) {
             return res.status(200).json({
                message: "LogIn Successfull",
                _id: existingUser._id,
                name: existingUser.name,
                email: existingUser.email,
                phone: existingUser.phone   
            });
        }
    } catch (error) {
        return res.status(500).json({message : 'Server error !'});
    }
});








const PORT = process.env.PORT || 3000;
app.listen(PORT, ()=>{
    console.log(`Server is running on port ${PORT}`);
});