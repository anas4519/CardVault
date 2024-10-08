require("dotenv").config()
const express = require("express")
const userRoute = require("./routes/user")
const mongoose = require("mongoose")
const path = require('path');
const cardRoute = require("./routes/card")

const app = express();
app.use(express.json())

const PORT = process.env.PORT || 8000;
mongoose.connect(process.env.MONGO_URL).then((e) => console.log("MongoDB connected!")
)
// app.use(express.urlencoded({extended: true}))
app.use(express.static(path.join(__dirname, 'public')));
app.use('/user', userRoute)
app.use('/card', cardRoute)
app.listen(PORT, () => console.log(`Server started at PORT:${PORT}`));