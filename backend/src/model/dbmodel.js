const mongoose = require('mongoose');
const dotenv = require('dotenv');
dotenv.config();

const connectDB = async ()=>{
    try {

        const databaseurl = process.env.MONGOOSE_URL;

        if (!databaseurl) {
            console.log("Database URL is not defined in environment variables");
            return;
        }


        await mongoose.connect(databaseurl).then(
            console.log("Database Connected Successfully now ")
        ).catch((err)=>{
            console.log("Error connecting to database: ", err);
        });

    } catch (err) {
        console.log(err);
    }
}


module.exports = connectDB;